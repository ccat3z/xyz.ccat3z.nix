import Clutter from 'gi://Clutter';
import {Panel} from 'resource:///org/gnome/shell/ui/panel.js';
import {Extension, InjectionManager} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

function vfunc_allocate(box) {
    this.set_allocation(box);

    let allocWidth = box.x2 - box.x1;
    let allocHeight = box.y2 - box.y1;

    let [, leftNaturalWidth] = this._leftBox.get_preferred_width(-1);
    let [, centerNaturalWidth] = this._centerBox.get_preferred_width(-1);
    let [, rightNaturalWidth] = this._rightBox.get_preferred_width(-1);

    let sideWidth, centerWidth;
    centerWidth = centerNaturalWidth;

    // get workspace area and center date entry relative to it
    let monitor = Main.layoutManager.findMonitorForActor(this);
    let centerOffset = 0;
    if (monitor) {
        let workArea = Main.layoutManager.getWorkAreaForMonitor(monitor.index);
        centerOffset = 2 * (workArea.x - monitor.x) + workArea.width - monitor.width;
    }

    sideWidth = Math.max(0, (allocWidth - centerWidth + centerOffset) / 2);

    let childBox = new Clutter.ActorBox();

    childBox.y1 = 0;
    childBox.y2 = allocHeight;
    if (this.get_text_direction() === Clutter.TextDirection.RTL) {
        childBox.x1 = Math.max(
            allocWidth - Math.min(Math.floor(sideWidth), leftNaturalWidth),
            0);
        childBox.x2 = allocWidth;
    } else {
        childBox.x1 = 0;
        childBox.x2 = Math.min(Math.floor(sideWidth), leftNaturalWidth);
    }
    this._leftBox.allocate(childBox);

    childBox.x1 = Math.ceil(sideWidth);
    childBox.y1 = 0;
    childBox.x2 = childBox.x1 + centerWidth;
    childBox.y2 = allocHeight;
    this._centerBox.allocate(childBox);

    childBox.y1 = 0;
    childBox.y2 = allocHeight;
    if (this.get_text_direction() === Clutter.TextDirection.RTL) {
        childBox.x1 = 0;
        childBox.x2 = Math.min(Math.floor(sideWidth), rightNaturalWidth);
    } else {
        childBox.x1 = Math.max(
            // allocWidth - Math.min(Math.floor(sideWidth), rightNaturalWidth),
            allocWidth - rightNaturalWidth,
            0);
        childBox.x2 = allocWidth;
    }
    this._rightBox.allocate(childBox);
}

export default class ExtendLeftBox extends Extension {
    constructor(metadata) {
        super(metadata);
        this._injectionManager = new InjectionManager();
    }

    enable() {
        this._injectionManager.overrideMethod(
            Panel.prototype, 'vfunc_allocate', originalMethod => {
                return vfunc_allocate
            }
        );
    }

    disable() {
        this._injectionManager.clear();
    }
}
