import SwiftUI

@main
struct OpenCueApp: App {
    @StateObject private var storage = CueStorage()
    
    var body: some Scene {
        WindowGroup {
            ScriptLibraryView()
                .environmentObject(storage)
                .frame(minWidth: 800, minHeight: 600)
                .onReceive(NotificationCenter.default.publisher(for: .startPrompting)) { notification in
                    if let script = notification.object as? ScriptDocument {
                        FloatingWindowController.shared.showPrompter(for: script)
                    }
                }
        }
    }
}
