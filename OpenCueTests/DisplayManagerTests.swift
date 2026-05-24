import XCTest
@testable import OpenCue

final class DisplayManagerTests: XCTestCase {
    
    func testDisplayManagerInitialization() {
        let manager = DisplayManager()
        
        // Assert that displays are populated on init
        XCTAssertFalse(manager.availableDisplays.isEmpty)
        
        // Assert it matches NSScreen.screens
        XCTAssertEqual(manager.availableDisplays.count, NSScreen.screens.count)
    }
    
    func testDisplayManagerRefreshNotification() {
        let manager = DisplayManager()
        
        // Clear to test the refresh works
        manager.availableDisplays = []
        XCTAssertTrue(manager.availableDisplays.isEmpty)
        
        // Post notification to trigger refreshDisplays
        NotificationCenter.default.post(name: NSApplication.didChangeScreenParametersNotification, object: nil)
        
        // Should be repopulated
        XCTAssertFalse(manager.availableDisplays.isEmpty)
        XCTAssertEqual(manager.availableDisplays.count, NSScreen.screens.count)
    }
}
