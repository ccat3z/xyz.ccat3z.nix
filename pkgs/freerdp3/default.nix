{ super, ... }:
super.freerdp3.override {
  libkrb5 = null;
}
