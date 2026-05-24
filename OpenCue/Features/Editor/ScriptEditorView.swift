import SwiftUI

struct ScriptEditorView: View {
    @Binding var script: ScriptDocument
    @EnvironmentObject var storage: CueStorage
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Script Title", text: $script.title)
                .font(.largeTitle)
                .textFieldStyle(.plain)
                .padding()
            
            Divider()
            
            TextEditor(text: $script.body)
                .font(.body)
                .padding()
        }
        .onChange(of: script.title) { _ in
            storage.saveScript(script)
        }
        .onChange(of: script.body) { _ in
            storage.saveScript(script)
        }
        .navigationTitle(script.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: startPrompting) {
                    Label("Prompt", systemImage: "play.fill")
                }
            }
        }
    }
    
    private func startPrompting() {
        NotificationCenter.default.post(name: .startPrompting, object: script)
    }
}

extension Notification.Name {
    static let startPrompting = Notification.Name("startPrompting")
}
