import SwiftUI

struct ScriptEditorView: View {
    @Binding var script: ScriptDocument
    @EnvironmentObject var storage: CueStorage
    @State private var showingSettings = false
    @StateObject private var displayManager = DisplayManager()
    @State private var operatorEngine: PlaybackEngine?
    
    var body: some View {
        ZStack {
            if let engine = operatorEngine {
                OperatorControlsView(engine: engine)
            } else {
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
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .closeOperatorView)) { _ in
            self.operatorEngine = nil
        }
        .navigationTitle(script.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    Button(action: { showingSettings = true }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .popover(isPresented: $showingSettings) {
                        PromptSettingsView(settings: $script.settings)
                    }
                    
                    Menu {
                        ForEach(displayManager.availableDisplays.indices, id: \.self) { index in
                            let screen = displayManager.availableDisplays[index]
                            Button("Display \(index + 1)") {
                                startExternalPrompting(on: screen)
                            }
                        }
                    } label: {
                        Label("External", systemImage: "display")
                    }
                    
                    Button(action: startPrompting) {
                        Label("Prompt", systemImage: "play.fill")
                    }
                }
            }
        }
    }
    
    private func startExternalPrompting(on screen: NSScreen) {
        let engine = PlaybackEngine(script: script)
        self.operatorEngine = engine
        ExternalWindowController.shared.showPrompter(with: engine, on: screen)
    }
    
    private func startPrompting() {
        NotificationCenter.default.post(name: .startPrompting, object: script)
    }
}

extension Notification.Name {
    static let startPrompting = Notification.Name("startPrompting")
}
