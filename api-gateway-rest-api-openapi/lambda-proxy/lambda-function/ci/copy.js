const FS = require("fs");
const Path = require("path");
const Utility = require("util");
const Process = require("process");

/***
 * Promisified Version of {@link FS.cp}
 * ---
 *
 * Asynchronously copies the entire directory structure from source to destination, including subdirectories and files.
 * - When copying a directory to another directory, globs are not supported.
 *
 * @experimental
 *
 * @param source {typeof import("fs").PathOrFileDescriptor} source path to copy.
 * @param target {typeof import("fs").PathOrFileDescriptor} destination path to copy to.
 * @returns {Promise<?>}
 *
 * @constructor
 *
 */

const Copy = async (source, target) => {
    const $ = Utility.promisify(FS.cp);

    await $(Path.resolve(source), Path.resolve(target), {
        dereference: true,
        errorOnExist: false,
        filter: undefined,
        force: true,
        preserveTimestamps: false,
        recursive: true
    });
}

module.exports = { Copy };

const Arguments = Process.argv.splice(2);

const Source = (Arguments.includes("--source")) ? Arguments[Arguments.indexOf("--source") + 1] ?? null : null;
const Target = (Arguments.includes("--target")) ? Arguments[Arguments.indexOf("--target") + 1] ?? null : null;

(Target && Source) && (async () => await Copy(Source, Target))();
