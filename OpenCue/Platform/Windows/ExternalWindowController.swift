import AppKit
import SwiftUI

@MainActor
class ExternalWindowController: NSObject, NSWindowDelegate {
    static let shared = ExternalWindowController()
    
    private var windows: [UUID: NSWindow] = [:]
    
    func showPrompter(with engine: PlaybackEngine, on screen: NSScreen) {
        let windowID = UUID()
        
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        
        window.level = .normal
        window.isOpaque = false
        window.backgroundColor = .black
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        let prompterView = PrompterView(engine: engine)
        window.contentView = NSHostingView(rootView: prompterView)
        
        window.setFrame(screen.frame, display: true)
        window.makeKeyAndOrderFront(nil)
        
        window.toggleFullScreen(nil)
        
        windows[windowID] = window
    }
    
    func closeAll() {
        for window in windows.values {
            window.close()
        }
        windows.removeAll()
    }
}
