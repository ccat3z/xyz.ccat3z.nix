import Clutter from 'gi://Clutter';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import Shell from 'gi://Shell';
import St from 'gi://St';
import Meta from 'gi://Meta';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import GObject from 'gi://GObject';
import spawn from './spawn.js';

const Clipboard = St.Clipboard.get_default();
const CLIPBOARD_TYPE = St.ClipboardType.CLIPBOARD;

async function translate(text, target='zh', brief=true) {
    let cmd = ['@trans@'];
    cmd.push(':' + target);
    if (brief) cmd.push('-brief');
    // cmd.push('-e');
    // cmd.push('bing');
    cmd.push(text);
    
    try {
        return (await spawn(cmd)).replace(/\n$/, '') || 'no resp'
    } catch(e) {
        log("spawn trans command failed: " + e);
        return "failed"
    }
}

const TranslateIndicator = GObject.registerClass(class TranslateIndicator extends PanelMenu.Button {
    _init() {
        super._init(0.0, 'Trabslate Label');
        this._text = 'translate'
        this._buttonText = new St.Label({
            text: 'translate',
            y_align: Clutter.ActorAlign.CENTER
        });
        this.add_child(this._buttonText);
        this.connect('button-press-event', () => this.updateText(null, true));
    }

    async updateText(text=null, force=false) {
        if (text == null) text = this._text;

        // trim
        text = (text || '').trim();

        // ignore non-word
        if (!text.match(/^[a-zA-Z]{1,}$/)) return;

        // if unchanged
        if (this._text == text && !force) return;

        log("update: " + text)
        this._text = text;
        this._buttonText.set_text(text + ' → ' + '...');

        let ans
        try {
            ans = await translate(text);
        } catch (e) {
            ans = "err"
            logError(e, 'failed to translate')
        }
        this._buttonText.set_text(text + ' → ' + ans);
    }
})

export default class Extension {
    constructor() {
        this._clipboardListenerId = null;
    }

    enable() {
        this._connectClipboardListener();
        this._indicator = new TranslateIndicator();
        Main.panel.addToStatusArea('TranslateIndicator', this._indicator);
    }

    disable() {
        this._disconnectClipboardListener();
        this._indicator.destroy();
    }

    _connectClipboardListener() {
        var selection = Shell.Global.get().get_display().get_selection();
        this._clipboardListenerId = selection.connect('owner-changed', (selection, selectionType, selectionSource) => {
            if (selectionType === Meta.SelectionType.SELECTION_CLIPBOARD) {
                Clipboard.get_text(CLIPBOARD_TYPE, (clipboard, text) => this._onClipboardUpdate(text));
            }
        });
    }

    _disconnectClipboardListener() {
        if (this._clipboardListener == null) return;

        var selection = Shell.Global.get().get_display().get_selection();
        selection.disconnect(this._clipboardListenerId);
        this._clipboardListenerId = null;
    }

    _onClipboardUpdate(text) {
        this._indicator.updateText(text);
    }
}
