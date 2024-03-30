import GLib from 'gi://GLib';
import Gio from 'gi://Gio';

export default async function spawn(argv) {
    let [success, pid, stdinFile, stdoutFile, stderrFile] = GLib.spawn_async_with_pipes(
        null, argv, [], GLib.SpawnFlags.SEARCH_PATH, null);

    if (!success)
        return;

    GLib.close(stdinFile);
    GLib.close(stderrFile);

    let standardOutput = "";

    let stdoutStream = new Gio.DataInputStream({
        base_stream: new Gio.UnixInputStream({
            fd: stdoutFile
        })
    });


    return await readStream(stdoutStream);
}

async function readLineFromStream(stream) {
    return new Promise((resolve, reject) => {
        stream.read_line_async(
            GLib.PRIORITY_LOW,
            null,
            (source, result) => {
                let [line] = source.read_line_finish(result);

                if (line === null) {
                    reject(null);
                } else {
                    resolve(imports.byteArray.toString(line) + "\n");
                }
            }
        )
    });
}

async function readStream(stream) {
    let res = ''
    while (true) {
        try {
            res += await readLineFromStream(stream);
        } catch (e) {
            break;
        }
    }
    return res
}
