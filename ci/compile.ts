import {Glob}  from 'glob'
import * as fs from 'fs'
import * as path from 'path'

process.env.NEXT_VERSION = process.argv[2] || "0.0.0"
const getFileContents = (filePath: string): Promise<Buffer> => {
    return new Promise((resolve, reject) => {
        fs.readFile(filePath, (err, contents) => {
            if (err) return err;
            resolve(contents)
        })
    })
}

const outDir = process.argv[3] || './dist/http-wrapper'

type Context = "client" | "server" | "shared"

class LuaBuilder {

    constructor(public readonly contexts: Context[], public readonly ignores?: string[]) {
        if (ignores === undefined) {
            this.ignores = []
        }
    }

    public compile(): Promise<void> {
        return new Promise(async (resolve, reject) => {
            for(const context of this.contexts) {
                const contextBuff = await this.getContextBuffer(context)
                await this.writeContext(context, contextBuff)
            }
            fs.readFile(`./src/fxmanifest.lua`, 'utf8', (err, manifest) => {
                const newManifest = manifest.replace(/^(version )'(.*)'$/gm, `$1 '${process.env.NEXT_VERSION || '0.0.0'}'`)
                fs.writeFile(`${outDir}/fxmanifest.lua`, newManifest, () => {
                    fs.writeFile(`./src/fxmanifest.lua`, newManifest, () => {
                        resolve()
                    })
                })
            })
        })
    }

    private isFileIgnored(name: string): boolean {
        const base = path.basename(name)
        const found = this.ignores.find(v => v.indexOf(base) > -1)
        return found !== undefined
    }

    private getContextBuffer(context: Context): Promise<Buffer> {
        return new Promise((resolve, reject) => {
            const glob = new Glob(`./src/${context}/**/*.lua`, {absolute: true}, async (err, matches) => {
                let output: Buffer[] = []
                for (const file of matches) {
                    if(file.indexOf("fxmanifest.lua") > -1 || this.isFileIgnored(file)) continue;

                    const contents = await getFileContents(file)
                    output.push(contents, Buffer.from("\n\n", "utf-8"))
                }
                resolve(Buffer.concat(output))
            })
        })
    }

    private writeContext(context: string, buff: Buffer): Promise<void> {
        return new Promise((resolve, reject) => {
            fs.mkdir(outDir, {recursive: true}, () => {
                fs.mkdir(`${outDir}/${context}`, {recursive: true}, () => {
                    fs.writeFile(`${outDir}/${context}/${context}.lua`, buff, (err) => {
                        resolve()
                    })
                })
            })
        })
    }
}

const builder = new LuaBuilder(["server"], ["json.lua"])
builder.compile().then(() => {

})
