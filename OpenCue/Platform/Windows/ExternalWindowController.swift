import AppKit
import SwiftUI

class ExternalWindowController: NSObject, NSWindowDelegate {
    static let shared = ExternalWindowController()
    
    private var windows: [UUID: NSWindow] = [:]
    
    func showPrompter(for script: ScriptDocument, on screen: NSScreen) {
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
        
        let prompterView = PrompterView(script: script)
        window.contentView = NSHostingView(rootView: prompterView)
        
        window.setFrame(screen.frame, display: true)
        window.makeKeyAndOrderFront(nil)
        
        window.toggleFullScreen(nil)
        
        windows[windowID] = window
    }
}
