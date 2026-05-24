import XCTest
import UniformTypeIdentifiers
@testable import OpenCue

class MockOpenPanel: OpenPanelProtocol {
    var allowedContentTypes: [UTType] = []
    var allowsMultipleSelection: Bool = false
    var canChooseDirectories: Bool = false
    var canCreateDirectories: Bool = false
    
    var responseToReturn: NSApplication.ModalResponse = .cancel
    var urlToReturn: URL?
    
    var url: URL? {
        return urlToReturn
    }
    
    func begin(completionHandler handler: @escaping (NSApplication.ModalResponse) -> Void) {
        handler(responseToReturn)
    }
}

class MockSavePanel: SavePanelProtocol {
    var allowedContentTypes: [UTType] = []
    var nameFieldStringValue: String = ""
    
    var responseToReturn: NSApplication.ModalResponse = .cancel
    var urlToReturn: URL?
    
    var url: URL? {
        return urlToReturn
    }
    
    func begin(completionHandler handler: @escaping (NSApplication.ModalResponse) -> Void) {
        handler(responseToReturn)
    }
}

final class ScriptIOControllerTests: XCTestCase {
    
    func testImportScriptSuccess() {
        let mockPanel = MockOpenPanel()
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("TestImport.md")
        try? "Import Content".write(to: fileURL, atomically: true, encoding: .utf8)
        
        mockPanel.responseToReturn = .OK
        mockPanel.urlToReturn = fileURL
        
        ScriptIOController.openPanelFactory = { mockPanel }
        
        let expectation = self.expectation(description: "Import successful")
        
        ScriptIOController.importScript { script in
            XCTAssertNotNil(script)
            XCTAssertEqual(script?.title, "TestImport")
            XCTAssertEqual(script?.body, "Import Content")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testImportScriptCancel() {
        let mockPanel = MockOpenPanel()
        mockPanel.responseToReturn = .cancel
        
        ScriptIOController.openPanelFactory = { mockPanel }
        
        let expectation = self.expectation(description: "Import cancelled")
        
        ScriptIOController.importScript { script in
            XCTAssertNil(script)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testImportScriptFailsRead() {
        let mockPanel = MockOpenPanel()
        let missingURL = FileManager.default.temporaryDirectory.appendingPathComponent("MissingFile.txt")
        mockPanel.responseToReturn = .OK
        mockPanel.urlToReturn = missingURL
        
        ScriptIOController.openPanelFactory = { mockPanel }
        
        let expectation = self.expectation(description: "Import failed due to missing file")
        
        ScriptIOController.importScript { script in
            XCTAssertNil(script)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExportScriptSuccess() {
        let mockPanel = MockSavePanel()
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("TestExport.md")
        try? FileManager.default.removeItem(at: fileURL)
        
        mockPanel.responseToReturn = .OK
        mockPanel.urlToReturn = fileURL
        
        ScriptIOController.savePanelFactory = { mockPanel }
        
        let expectation = self.expectation(description: "Export successful")
        
        let script = ScriptDocument(title: "TestExport", body: "Export Content")
        
        ScriptIOController.exportScript(script) { success in
            XCTAssertTrue(success)
            let writtenContent = try? String(contentsOf: fileURL)
            XCTAssertEqual(writtenContent, "Export Content")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExportScriptCancel() {
        let mockPanel = MockSavePanel()
        mockPanel.responseToReturn = .cancel
        
        ScriptIOController.savePanelFactory = { mockPanel }
        
        let expectation = self.expectation(description: "Export cancelled")
        let script = ScriptDocument(title: "TestExport", body: "Export Content")
        
        ScriptIOController.exportScript(script) { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testExportScriptFailsWrite() {
        let mockPanel = MockSavePanel()
        // Use a protected/invalid directory to force write failure
        let invalidURL = URL(fileURLWithPath: "/System/ProtectedFile.md")
        mockPanel.responseToReturn = .OK
        mockPanel.urlToReturn = invalidURL
        
        ScriptIOController.savePanelFactory = { mockPanel }
        
        let expectation = self.expectation(description: "Export failed due to write permissions")
        let script = ScriptDocument(title: "TestExport", body: "Export Content")
        
        ScriptIOController.exportScript(script) { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
