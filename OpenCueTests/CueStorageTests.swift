import XCTest
@testable import OpenCue

@MainActor
final class CueStorageTests: XCTestCase {

    private var tempDir: URL!
    private var storage: CueStorage!

    override func setUp() {
        super.setUp()
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent("OpenCueTests_\(UUID().uuidString)")
        try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        storage = CueStorage(directory: tempDir)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
        storage = nil
        tempDir = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testEmptyDirectoryLoadsNoScripts() {
        XCTAssertTrue(storage.scripts.isEmpty)
    }

    // MARK: - Save

    func testSaveCreatesFile() {
        let script = ScriptDocument(title: "First Script", body: "Hello")
        storage.saveScript(script)

        let filePath = tempDir.appendingPathComponent("\(script.id.uuidString).json")
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path))
    }

    func testSaveAddsToScriptsArray() {
        let script = ScriptDocument(title: "Test")
        storage.saveScript(script)
        XCTAssertEqual(storage.scripts.count, 1)
        XCTAssertEqual(storage.scripts[0].title, "Test")
    }

    func testSaveUpdatesTimestamp() {
        let oldDate = Date(timeIntervalSince1970: 1000)
        let script = ScriptDocument(title: "Old", updatedAt: oldDate)
        storage.saveScript(script)
        XCTAssertGreaterThan(storage.scripts[0].updatedAt, oldDate)
    }

    func testSaveMultipleScripts() {
        for i in 0..<5 {
            let script = ScriptDocument(title: "Script \(i)")
            storage.saveScript(script)
        }
        XCTAssertEqual(storage.scripts.count, 5)
    }

    func testSaveOverwritesExistingScript() {
        var script = ScriptDocument(title: "V1", body: "original")
        storage.saveScript(script)
        XCTAssertEqual(storage.scripts.count, 1)

        script.title = "V2"
        script.body = "updated"
        storage.saveScript(script)

        XCTAssertEqual(storage.scripts.count, 1, "Should update in-place, not duplicate")
        XCTAssertEqual(storage.scripts[0].title, "V2")
        XCTAssertEqual(storage.scripts[0].body, "updated")
    }

    func testSaveWritesValidJSON() throws {
        let script = ScriptDocument(title: "JSON Test", body: "content")
        storage.saveScript(script)

        let filePath = tempDir.appendingPathComponent("\(script.id.uuidString).json")
        let data = try Data(contentsOf: filePath)
        let decoded = try JSONDecoder().decode(ScriptDocument.self, from: data)
        XCTAssertEqual(decoded.id, script.id)
        XCTAssertEqual(decoded.title, "JSON Test")
        XCTAssertEqual(decoded.body, "content")
    }

    // MARK: - Load

    func testLoadReadsFromDisk() throws {
        let script = ScriptDocument(title: "Persisted")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(script)
        let filePath = tempDir.appendingPathComponent("\(script.id.uuidString).json")
        try data.write(to: filePath)

        storage.loadScripts()
        XCTAssertEqual(storage.scripts.count, 1)
        XCTAssertEqual(storage.scripts[0].title, "Persisted")
        XCTAssertEqual(storage.scripts[0].id, script.id)
    }

    func testLoadIgnoresNonJSONFiles() throws {
        let txtPath = tempDir.appendingPathComponent("notes.txt")
        try "not a script".write(to: txtPath, atomically: true, encoding: .utf8)
        storage.loadScripts()
        XCTAssertTrue(storage.scripts.isEmpty)
    }

    func testLoadIgnoresCorruptedJSON() throws {
        let filePath = tempDir.appendingPathComponent("\(UUID().uuidString).json")
        try "{ broken json".write(to: filePath, atomically: true, encoding: .utf8)
        storage.loadScripts()
        XCTAssertTrue(storage.scripts.isEmpty)
    }

    func testLoadSortsByUpdatedAtDescending() throws {
        let older = ScriptDocument(title: "Older", updatedAt: Date(timeIntervalSince1970: 1000))
        let newer = ScriptDocument(title: "Newer", updatedAt: Date(timeIntervalSince1970: 2000))

        let encoder = JSONEncoder()
        for script in [older, newer] {
            let data = try encoder.encode(script)
            let path = tempDir.appendingPathComponent("\(script.id.uuidString).json")
            try data.write(to: path)
        }

        storage.loadScripts()
        XCTAssertEqual(storage.scripts.count, 2)
        XCTAssertEqual(storage.scripts[0].title, "Newer")
        XCTAssertEqual(storage.scripts[1].title, "Older")
    }

    func testLoadMultipleFiles() throws {
        let encoder = JSONEncoder()
        for i in 0..<10 {
            let script = ScriptDocument(
                title: "Script \(i)",
                updatedAt: Date(timeIntervalSince1970: Double(i) * 1000)
            )
            let data = try encoder.encode(script)
            let path = tempDir.appendingPathComponent("\(script.id.uuidString).json")
            try data.write(to: path)
        }

        storage.loadScripts()
        XCTAssertEqual(storage.scripts.count, 10)
        XCTAssertEqual(storage.scripts[0].title, "Script 9", "Most recently updated should be first")
    }

    // MARK: - Delete

    func testDeleteRemovesFile() {
        let script = ScriptDocument(title: "To Delete")
        storage.saveScript(script)

        let filePath = tempDir.appendingPathComponent("\(script.id.uuidString).json")
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath.path))

        storage.deleteScript(script)
        XCTAssertFalse(FileManager.default.fileExists(atPath: filePath.path))
    }

    func testDeleteRemovesFromArray() {
        let script = ScriptDocument(title: "To Delete")
        storage.saveScript(script)
        XCTAssertEqual(storage.scripts.count, 1)

        storage.deleteScript(script)
        XCTAssertTrue(storage.scripts.isEmpty)
    }

    func testDeleteNonexistentScriptIsNoOp() {
        let script = ScriptDocument(title: "Never Saved")
        storage.deleteScript(script)
        XCTAssertTrue(storage.scripts.isEmpty)
    }

    func testDeleteOnlyRemovesTargetScript() {
        let keep = ScriptDocument(title: "Keep")
        let remove = ScriptDocument(title: "Remove")
        storage.saveScript(keep)
        storage.saveScript(remove)
        XCTAssertEqual(storage.scripts.count, 2)

        storage.deleteScript(remove)
        XCTAssertEqual(storage.scripts.count, 1)
        XCTAssertEqual(storage.scripts[0].id, keep.id)
    }

    // MARK: - Round Trip

    func testSaveLoadRoundTrip() {
        let original = ScriptDocument(
            title: "Round Trip",
            body: "Full content here",
            segments: [ScriptSegment(title: "Intro", startCharacterIndex: 0)],
            settings: PromptSettings(fontSize: 80, mirrorHorizontal: true)
        )
        storage.saveScript(original)

        let freshStorage = CueStorage(directory: tempDir)
        XCTAssertEqual(freshStorage.scripts.count, 1)
        XCTAssertEqual(freshStorage.scripts[0].title, "Round Trip")
        XCTAssertEqual(freshStorage.scripts[0].body, "Full content here")
        XCTAssertEqual(freshStorage.scripts[0].segments.count, 1)
        XCTAssertEqual(freshStorage.scripts[0].settings.fontSize, 80)
        XCTAssertEqual(freshStorage.scripts[0].settings.mirrorHorizontal, true)
    }

    func testSaveDeleteSaveNewRoundTrip() {
        let first = ScriptDocument(title: "First")
        storage.saveScript(first)
        storage.deleteScript(first)

        let second = ScriptDocument(title: "Second")
        storage.saveScript(second)

        let freshStorage = CueStorage(directory: tempDir)
        XCTAssertEqual(freshStorage.scripts.count, 1)
        XCTAssertEqual(freshStorage.scripts[0].title, "Second")
    }

    // MARK: - Sort Order After Operations

    func testSortOrderMaintainedAfterSave() {
        let older = ScriptDocument(title: "Older")
        storage.saveScript(older)

        Thread.sleep(forTimeInterval: 0.01)

        let newer = ScriptDocument(title: "Newer")
        storage.saveScript(newer)

        XCTAssertEqual(storage.scripts[0].title, "Newer")
        XCTAssertEqual(storage.scripts[1].title, "Older")
    }

    func testSortOrderUpdatedWhenResaving() {
        let first = ScriptDocument(title: "First")
        storage.saveScript(first)

        Thread.sleep(forTimeInterval: 0.01)

        let second = ScriptDocument(title: "Second")
        storage.saveScript(second)

        XCTAssertEqual(storage.scripts[0].title, "Second")

        Thread.sleep(forTimeInterval: 0.01)

        var updatedFirst = storage.scripts.first(where: { $0.id == first.id })!
        updatedFirst.title = "First Updated"
        storage.saveScript(updatedFirst)

        XCTAssertEqual(storage.scripts[0].title, "First Updated", "Resaved script should move to top")
    }

    // MARK: - Unicode Content Persistence

    func testUnicodeContentSurvivesRoundTrip() {
        let script = ScriptDocument(title: "日本語", body: "Héllo 🎬 wörld")
        storage.saveScript(script)

        let freshStorage = CueStorage(directory: tempDir)
        XCTAssertEqual(freshStorage.scripts[0].title, "日本語")
        XCTAssertEqual(freshStorage.scripts[0].body, "Héllo 🎬 wörld")
    }
}
