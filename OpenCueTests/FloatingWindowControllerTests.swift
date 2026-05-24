import XCTest
@testable import OpenCue

@MainActor
final class FloatingWindowControllerTests: XCTestCase {
    
    func testShowPrompterCreatesWindow() {
        let script = ScriptDocument(title: "Test", body: "Hello")
        
        let initialWindowCount = NSApp.windows.count
        
        FloatingWindowController.shared.showPrompter(for: script)
        
        XCTAssertGreaterThan(NSApp.windows.count, initialWindowCount)
        
        // Find the panel we just created
        let panel = NSApp.windows.compactMap { $0 as? NSPanel }.last
        XCTAssertNotNil(panel)
        XCTAssertTrue(panel!.isFloatingPanel)
        XCTAssertEqual(panel!.level, .floating)
        XCTAssertEqual(panel!.titleVisibility, .hidden)
        
        // Clean up by simulating windowWillClose or just closing
        panel?.close()
        FloatingWindowController.shared.windowWillClose(Notification(name: NSWindow.willCloseNotification))
    }
}
