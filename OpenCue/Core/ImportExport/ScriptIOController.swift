import Foundation
import AppKit

struct ScriptIOController {
    
    static func importScript(completion: @escaping (ScriptDocument?) -> Void) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText, .init(filenameExtension: "md")!]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    let content = try String(contentsOf: url)
                    let title = url.deletingPathExtension().lastPathComponent
                    let script = ScriptDocument(title: title, body: content)
                    completion(script)
                } catch {
                    print("Error reading file: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    static func exportScript(_ script: ScriptDocument, completion: @escaping (Bool) -> Void) {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.init(filenameExtension: "md")!, .plainText]
        panel.nameFieldStringValue = "\(script.title).md"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                do {
                    try script.body.write(to: url, atomically: true, encoding: .utf8)
                    completion(true)
                } catch {
                    print("Error writing file: \(error)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}
