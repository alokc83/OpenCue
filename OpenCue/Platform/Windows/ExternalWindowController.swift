import AppKit
import SwiftUI

@MainActor
class ExternalWindowController: NSObject, NSWindowDelegate {
    static let shared = ExternalWindowController()

    private var windows: [UUID: NSWindow] = [:]
    private var engines: [UUID: PlaybackEngine] = [:]

    func showPrompter(with engine: PlaybackEngine, on screen: NSScreen) {
        let windowID = UUID()

        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )

        window.level = .screenSaver
        window.isOpaque = true
        window.backgroundColor = .black
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.animationBehavior = .none

        let prompterView = PrompterView(engine: engine)
        window.contentView = NSHostingView(rootView: prompterView)

        window.setFrame(screen.frame, display: true)
        window.makeKeyAndOrderFront(nil)

        windows[windowID] = window
        engines[windowID] = engine
    }

    func closeAll() {
        for (id, window) in windows {
            engines[id]?.stopEngine()
            window.contentView = nil
            window.orderOut(nil)
        }
        windows.removeAll()
        engines.removeAll()
    }
}
