import Foundation
import Combine

@MainActor
class CueStorage: ObservableObject {
    @Published var scripts: [ScriptDocument] = []
    
    private let fileManager = FileManager.default
    private let scriptsDirectoryName = "Scripts"
    
    init() {
        loadScripts()
    }
    
    private var documentDirectory: URL? {
        guard let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return nil }
        let bundleID = Bundle.main.bundleIdentifier ?? "com.opencue.mac"
        let appDir = appSupport.appendingPathComponent(bundleID)
        let scriptsDir = appDir.appendingPathComponent(scriptsDirectoryName)
        
        if !fileManager.fileExists(atPath: scriptsDir.path) {
            do {
                try fileManager.createDirectory(at: scriptsDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create scripts directory: \(error)")
                return nil
            }
        }
        return scriptsDir
    }
    
    func loadScripts() {
        guard let dir = documentDirectory else { return }
        
        do {
            let files = try fileManager.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            let jsonFiles = files.filter { $0.pathExtension == "json" }
            
            var loadedScripts: [ScriptDocument] = []
            let decoder = JSONDecoder()
            
            for file in jsonFiles {
                do {
                    let data = try Data(contentsOf: file)
                    let script = try decoder.decode(ScriptDocument.self, from: data)
                    loadedScripts.append(script)
                } catch {
                    print("Error decoding file \(file.lastPathComponent): \(error)")
                }
            }
            
            self.scripts = loadedScripts.sorted(by: { $0.updatedAt > $1.updatedAt })
        } catch {
            print("Error loading scripts directory: \(error)")
        }
    }
    
    func saveScript(_ script: ScriptDocument) {
        guard let dir = documentDirectory else { return }
        var scriptToSave = script
        scriptToSave.updatedAt = Date()
        
        let fileURL = dir.appendingPathComponent("\(scriptToSave.id.uuidString).json")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(scriptToSave)
            try data.write(to: fileURL)
            
            if let index = scripts.firstIndex(where: { $0.id == script.id }) {
                scripts[index] = scriptToSave
            } else {
                scripts.insert(scriptToSave, at: 0)
            }
            scripts.sort(by: { $0.updatedAt > $1.updatedAt })
        } catch {
            print("Error saving script: \(error)")
        }
    }
    
    func deleteScript(_ script: ScriptDocument) {
        guard let dir = documentDirectory else { return }
        let fileURL = dir.appendingPathComponent("\(script.id.uuidString).json")
        
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            scripts.removeAll { $0.id == script.id }
        } catch {
            print("Error deleting script: \(error)")
        }
    }
}
