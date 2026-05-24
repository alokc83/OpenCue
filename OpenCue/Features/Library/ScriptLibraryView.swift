import SwiftUI

struct ScriptLibraryView: View {
    @EnvironmentObject var storage: CueStorage
    @State private var selectedScriptID: UUID?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedScriptID) {
                ForEach(storage.scripts) { script in
                    NavigationLink(value: script.id) {
                        VStack(alignment: .leading) {
                            Text(script.title)
                                .font(.headline)
                            Text(script.updatedAt, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(action: {
                            duplicateScript(script)
                        }) {
                            Label("Duplicate", systemImage: "doc.on.doc")
                        }
                        
                        Button(action: {
                            ScriptIOController.exportScript(script) { _ in }
                        }) {
                            Label("Export...", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            storage.deleteScript(script)
                            if selectedScriptID == script.id {
                                selectedScriptID = nil
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Scripts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Button(action: importScript) {
                            Label("Import", systemImage: "square.and.arrow.down")
                        }
                        Button(action: createNewScript) {
                            Label("New Script", systemImage: "plus")
                        }
                    }
                }
            }
        } detail: {
            if let selectedID = selectedScriptID,
               let index = storage.scripts.firstIndex(where: { $0.id == selectedID }) {
                ScriptEditorView(script: $storage.scripts[index])
            } else {
                Text("Select a script or create a new one.")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func createNewScript() {
        let newScript = ScriptDocument(title: "New Script \(storage.scripts.count + 1)")
        storage.saveScript(newScript)
        selectedScriptID = newScript.id
    }
    
    private func duplicateScript(_ script: ScriptDocument) {
        var newScript = script
        newScript.id = UUID()
        newScript.title = script.title + " (Copy)"
        newScript.createdAt = Date()
        newScript.updatedAt = Date()
        storage.saveScript(newScript)
        selectedScriptID = newScript.id
    }
    
    private func importScript() {
        ScriptIOController.importScript { importedScript in
            guard let importedScript = importedScript else { return }
            storage.saveScript(importedScript)
            selectedScriptID = importedScript.id
        }
    }
}
