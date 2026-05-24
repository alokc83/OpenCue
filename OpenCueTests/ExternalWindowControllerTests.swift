import XCTest
@testable import OpenCue

@MainActor
final class ExternalWindowControllerTests: XCTestCase {
    
    func testShowPrompterAndCloseAll() {
        let engine = PlaybackEngine(script: ScriptDocument())
        guard let screen = NSScreen.main else {
            XCTFail("No screens available for test")
            return
        }
        
        let initialWindowCount = NSApp.windows.count
        
        ExternalWindowController.shared.showPrompter(with: engine, on: screen)
        
        XCTAssertGreaterThan(NSApp.windows.count, initialWindowCount)
        
        let spawnedWindow = NSApp.windows.last
        XCTAssertNotNil(spawnedWindow)
        XCTAssertEqual(spawnedWindow?.backgroundColor, .black)
        XCTAssertEqual(spawnedWindow?.styleMask.contains(.borderless), true)
        
        ExternalWindowController.shared.closeAll()
    }
}
