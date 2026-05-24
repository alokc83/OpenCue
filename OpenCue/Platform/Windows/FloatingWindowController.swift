import AppKit
import SwiftUI

@MainActor
class FloatingWindowController: NSObject, NSWindowDelegate {
    static let shared = FloatingWindowController()
    
    private var window: NSPanel?
    
    func showPrompter(for script: ScriptDocument) {
        if window == nil {
            let panel = NSPanel(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                styleMask: [.titled, .closable, .resizable, .fullSizeContentView, .nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            
            panel.isFloatingPanel = true
            panel.level = .floating
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            panel.titleVisibility = .hidden
            panel.titlebarAppearsTransparent = true
            panel.isOpaque = false
            panel.backgroundColor = .clear
            
            panel.standardWindowButton(.closeButton)?.isHidden = false
            panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
            panel.standardWindowButton(.zoomButton)?.isHidden = true
            
            panel.delegate = self
            
            self.window = panel
        }
        
        let engine = PlaybackEngine(script: script)
        let prompterView = PrompterView(engine: engine)
        window?.contentView = NSHostingView(rootView: prompterView)
        
        window?.center()
        window?.makeKeyAndOrderFront(nil)
    }
    
    func windowWillClose(_ notification: Notification) {
        window = nil
    }
}
