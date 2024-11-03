#include <iostream>
#include <functional>
#include <format>

#include <hidapi.h>

#include "controller_structs.h"
#include "controller_constants.h"

namespace {
struct defer {
  std::function<void()> fn;
  ~defer()
  {
    if (fn)
      fn();
  }
};

std::string to_string(const wchar_t *wstr)
{
  if (!wstr)
    return {};

  char str[256];
  int len = std::wcstombs(str, wstr, 255);
  str[len] = 0;
  return std::string(str);
}

struct Exception {
  std::string msg;
  Exception();
  Exception(const std::string &msg) : msg(msg)
  {}
};

struct HidException : public Exception {
  HidException(const std::string &msg, hid_device *dev)
      : Exception(std::format("{} ({})", msg, to_string(hid_error(dev)))) {};
};

struct HidHolder {
  HidHolder()
  {
    auto res = hid_init();
    if (res != 0)
      throw HidException("hid_init failed", NULL);
  }

  ~HidHolder()
  {
    hid_exit();
  }
};

struct SteamdeckController {
  SteamdeckController()
  {
    auto devpath = SteamdeckController::findDevPath();
    std::cerr << "Using device: " << devpath << std::endl;

    dev = hid_open_path(devpath.c_str());
    if (!dev)
      throw HidException(std::format("Failed to open {}", devpath), NULL);
  }

  ~SteamdeckController()
  {
    if (dev)
      hid_close(dev);
  }

  std::string getManufacturer()
  {
    wchar_t wstr[256];
    auto res = hid_get_manufacturer_string(dev, wstr, 256);
    if (res != 0)
      throw HidException("Failed to get manufacturer", dev);
    return to_string(wstr);
  }

  void loop()
  {
    std::cerr << "Read data" << std::endl;
    ValveInReport_t report;
    while (true) {
      auto r = hid_read(dev, reinterpret_cast<uint8_t *>(&report), sizeof(report));

      if (r < 0)
        break;

      // for (int i = 0; i < sizeof(report.payload); i++) {
      // 	std::cerr << ' ' << std::setw(2) << std::setfill('0') << std::hex
      // 					  << (int) (reinterpret_cast<uint8_t *>(&report.payload.deckState))[i];
      // }
      // std::cerr << std::endl;
      std::cerr << report.payload.deckState.sLeftPadX << ' ' << report.payload.deckState.sLeftPadY << ' '
                << report.payload.deckState.sPressurePadLeft << std::endl;
    }
  }

  static std::string findDevPath()
  {
    auto *devs = hid_enumerate(0x28DE, 0x1205);
    auto *dev = devs;
    std::string results;

    while (dev) {
      if (dev->usage == 1 && dev->usage_page == 0xFFFF) {
        results.append(dev->path);
        break;
      }

      dev = dev->next;
    }
    hid_free_enumeration(devs);

    if (results.empty())
      throw Exception("Cannot find steamdeck controller");

    return results;
  }

  hid_device *dev;
};
}  // namespace

int main(int argc, char *argv[])
{
  try {
    HidHolder hid;
    SteamdeckController sdCtrl;
    std::cerr << "Opened " << sdCtrl.getManufacturer() << std::endl;

    uint8_t buffer[HID_FEATURE_REPORT_BYTES + 1] = {0};
    FeatureReportMsg *msg = (FeatureReportMsg *)(buffer + 1);
    msg->header.type = ID_SET_SETTINGS_VALUES;
    msg->header.length = 1 * sizeof(ControllerSetting);
    msg->payload.setSettingsValues.settings[0].settingNum = SETTING_LEFT_TRACKPAD_MODE;
    msg->payload.setSettingsValues.settings[0].settingValue = TRACKPAD_RADIAL_MODE;

    auto res = hid_send_feature_report(sdCtrl.dev, buffer, sizeof(buffer));
    if (res != sizeof(buffer))
			throw HidException("Failed to send feature", sdCtrl.dev);

    sdCtrl.loop();
  } catch (const Exception &e) {
    std::cerr << e.msg << std::endl;
    return 1;
  }

  return 0;
}