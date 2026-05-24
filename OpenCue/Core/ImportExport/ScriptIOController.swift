import Foundation
import AppKit
import UniformTypeIdentifiers

protocol OpenPanelProtocol {
    var allowedContentTypes: [UTType] { get set }
    var allowsMultipleSelection: Bool { get set }
    var canChooseDirectories: Bool { get set }
    var canCreateDirectories: Bool { get set }
    var url: URL? { get }
    func begin(completionHandler handler: @escaping (NSApplication.ModalResponse) -> Void)
}

extension NSOpenPanel: OpenPanelProtocol {}

protocol SavePanelProtocol {
    var allowedContentTypes: [UTType] { get set }
    var nameFieldStringValue: String { get set }
    var url: URL? { get }
    func begin(completionHandler handler: @escaping (NSApplication.ModalResponse) -> Void)
}

extension NSSavePanel: SavePanelProtocol {}

struct ScriptIOController {
    
    #if DEBUG
    static var openPanelFactory: () -> OpenPanelProtocol = { NSOpenPanel() }
    static var savePanelFactory: () -> SavePanelProtocol = { NSSavePanel() }
    #else
    private static let openPanelFactory: () -> OpenPanelProtocol = { NSOpenPanel() }
    private static let savePanelFactory: () -> SavePanelProtocol = { NSSavePanel() }
    #endif
    
    static func importScript(completion: @escaping (ScriptDocument?) -> Void) {
        var panel = openPanelFactory()
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
        var panel = savePanelFactory()
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
