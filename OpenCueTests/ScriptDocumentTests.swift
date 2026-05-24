import XCTest
@testable import OpenCue

final class ScriptDocumentTests: XCTestCase {

    // MARK: - ScriptDocument Default Init

    func testDefaultInit() {
        let doc = ScriptDocument()
        XCTAssertEqual(doc.title, "New Script")
        XCTAssertEqual(doc.body, "")
        XCTAssertTrue(doc.segments.isEmpty)
        XCTAssertEqual(doc.settings, PromptSettings())
    }

    func testDefaultInitGeneratesUniqueIDs() {
        let a = ScriptDocument()
        let b = ScriptDocument()
        XCTAssertNotEqual(a.id, b.id)
    }

    func testDefaultInitSetsTimestamps() {
        let before = Date()
        let doc = ScriptDocument()
        let after = Date()
        XCTAssertGreaterThanOrEqual(doc.createdAt, before)
        XCTAssertLessThanOrEqual(doc.createdAt, after)
        XCTAssertGreaterThanOrEqual(doc.updatedAt, before)
        XCTAssertLessThanOrEqual(doc.updatedAt, after)
    }

    // MARK: - ScriptDocument Custom Init

    func testCustomInit() {
        let id = UUID()
        let created = Date(timeIntervalSince1970: 1000)
        let updated = Date(timeIntervalSince1970: 2000)
        let segments = [ScriptSegment(startCharacterIndex: 0)]
        let settings = PromptSettings(fontSize: 80)

        let doc = ScriptDocument(
            id: id,
            title: "My Script",
            body: "Hello world",
            createdAt: created,
            updatedAt: updated,
            segments: segments,
            settings: settings
        )

        XCTAssertEqual(doc.id, id)
        XCTAssertEqual(doc.title, "My Script")
        XCTAssertEqual(doc.body, "Hello world")
        XCTAssertEqual(doc.createdAt, created)
        XCTAssertEqual(doc.updatedAt, updated)
        XCTAssertEqual(doc.segments.count, 1)
        XCTAssertEqual(doc.settings.fontSize, 80)
    }

    // MARK: - ScriptDocument Codable

    func testCodableRoundTrip() throws {
        let original = ScriptDocument(
            title: "Test Script",
            body: "Line one\nLine two",
            segments: [
                ScriptSegment(title: "Intro", startCharacterIndex: 0, cuePointName: "CUE1"),
                ScriptSegment(startCharacterIndex: 20)
            ],
            settings: PromptSettings(
                fontSize: 72,
                lineHeight: 1.6,
                textWidth: 900,
                textColorHex: "#FF0000",
                backgroundColorHex: "#00FF00",
                backgroundOpacity: 0.8,
                wordsPerMinute: 180,
                mirrorHorizontal: true,
                mirrorVertical: true,
                countdownSeconds: 5
            )
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ScriptDocument.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.title, original.title)
        XCTAssertEqual(decoded.body, original.body)
        XCTAssertEqual(decoded.segments.count, 2)
        XCTAssertEqual(decoded.segments[0].title, "Intro")
        XCTAssertEqual(decoded.segments[0].cuePointName, "CUE1")
        XCTAssertEqual(decoded.segments[1].startCharacterIndex, 20)
        XCTAssertEqual(decoded.settings.fontSize, 72)
        XCTAssertEqual(decoded.settings.mirrorHorizontal, true)
        XCTAssertEqual(decoded.settings.countdownSeconds, 5)
    }

    func testCodableWithEmptyBody() throws {
        let original = ScriptDocument(title: "Empty", body: "")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptDocument.self, from: data)
        XCTAssertEqual(decoded.body, "")
    }

    func testCodableWithUnicodeContent() throws {
        let original = ScriptDocument(title: "日本語テスト", body: "Héllo wörld 🎬🎤")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptDocument.self, from: data)
        XCTAssertEqual(decoded.title, "日本語テスト")
        XCTAssertEqual(decoded.body, "Héllo wörld 🎬🎤")
    }

    func testCodablePreservesTimestampPrecision() throws {
        let original = ScriptDocument(
            createdAt: Date(timeIntervalSince1970: 1700000000.123),
            updatedAt: Date(timeIntervalSince1970: 1700000000.456)
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptDocument.self, from: data)
        XCTAssertEqual(decoded.createdAt.timeIntervalSince1970, original.createdAt.timeIntervalSince1970, accuracy: 0.001)
        XCTAssertEqual(decoded.updatedAt.timeIntervalSince1970, original.updatedAt.timeIntervalSince1970, accuracy: 0.001)
    }

    // MARK: - ScriptDocument Hashable / Identifiable

    func testHashableConsistency() {
        let doc = ScriptDocument(title: "A")
        var set = Set<ScriptDocument>()
        set.insert(doc)
        XCTAssertTrue(set.contains(doc))
    }

    func testIdenticalDocsAreEqual() {
        let id = UUID()
        let date = Date()
        let a = ScriptDocument(id: id, title: "Same", body: "body", createdAt: date, updatedAt: date)
        let b = ScriptDocument(id: id, title: "Same", body: "body", createdAt: date, updatedAt: date)
        XCTAssertEqual(a, b)
    }

    func testDifferentIDsMakeDocsUnequal() {
        let a = ScriptDocument(title: "Same")
        let b = ScriptDocument(title: "Same")
        XCTAssertNotEqual(a, b)
    }

    // MARK: - ScriptSegment

    func testSegmentDefaultInit() {
        let seg = ScriptSegment(startCharacterIndex: 42)
        XCTAssertEqual(seg.startCharacterIndex, 42)
        XCTAssertNil(seg.title)
        XCTAssertNil(seg.cuePointName)
    }

    func testSegmentCustomInit() {
        let id = UUID()
        let seg = ScriptSegment(id: id, title: "Section 1", startCharacterIndex: 100, cuePointName: "CUE_A")
        XCTAssertEqual(seg.id, id)
        XCTAssertEqual(seg.title, "Section 1")
        XCTAssertEqual(seg.startCharacterIndex, 100)
        XCTAssertEqual(seg.cuePointName, "CUE_A")
    }

    func testSegmentCodableRoundTrip() throws {
        let original = ScriptSegment(title: "Opener", startCharacterIndex: 0, cuePointName: "START")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptSegment.self, from: data)
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.title, "Opener")
        XCTAssertEqual(decoded.startCharacterIndex, 0)
        XCTAssertEqual(decoded.cuePointName, "START")
    }

    func testSegmentCodableWithNilOptionals() throws {
        let original = ScriptSegment(startCharacterIndex: 50)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptSegment.self, from: data)
        XCTAssertNil(decoded.title)
        XCTAssertNil(decoded.cuePointName)
    }

    // MARK: - PromptSettings

    func testPromptSettingsDefaults() {
        let settings = PromptSettings()
        XCTAssertEqual(settings.fontSize, 64.0)
        XCTAssertEqual(settings.lineHeight, 1.4)
        XCTAssertEqual(settings.textWidth, 800.0)
        XCTAssertEqual(settings.textColorHex, "#FFFFFF")
        XCTAssertEqual(settings.backgroundColorHex, "#000000")
        XCTAssertEqual(settings.backgroundOpacity, 1.0)
        XCTAssertEqual(settings.wordsPerMinute, 150.0)
        XCTAssertEqual(settings.mirrorHorizontal, false)
        XCTAssertEqual(settings.mirrorVertical, false)
        XCTAssertEqual(settings.countdownSeconds, 3)
    }

    func testPromptSettingsCustom() {
        let settings = PromptSettings(
            fontSize: 100,
            lineHeight: 2.0,
            textWidth: 1200,
            textColorHex: "#AABBCC",
            backgroundColorHex: "#112233",
            backgroundOpacity: 0.5,
            wordsPerMinute: 200,
            mirrorHorizontal: true,
            mirrorVertical: true,
            countdownSeconds: 10
        )
        XCTAssertEqual(settings.fontSize, 100)
        XCTAssertEqual(settings.lineHeight, 2.0)
        XCTAssertEqual(settings.textWidth, 1200)
        XCTAssertEqual(settings.textColorHex, "#AABBCC")
        XCTAssertEqual(settings.backgroundColorHex, "#112233")
        XCTAssertEqual(settings.backgroundOpacity, 0.5)
        XCTAssertEqual(settings.wordsPerMinute, 200)
        XCTAssertEqual(settings.mirrorHorizontal, true)
        XCTAssertEqual(settings.mirrorVertical, true)
        XCTAssertEqual(settings.countdownSeconds, 10)
    }

    func testPromptSettingsCodableRoundTrip() throws {
        let original = PromptSettings(
            fontSize: 48,
            wordsPerMinute: 120,
            mirrorHorizontal: true,
            countdownSeconds: 0
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(PromptSettings.self, from: data)
        XCTAssertEqual(decoded.fontSize, 48)
        XCTAssertEqual(decoded.wordsPerMinute, 120)
        XCTAssertEqual(decoded.mirrorHorizontal, true)
        XCTAssertEqual(decoded.countdownSeconds, 0)
    }

    func testPromptSettingsHashableEquality() {
        let a = PromptSettings(fontSize: 64)
        let b = PromptSettings(fontSize: 64)
        XCTAssertEqual(a, b)
    }

    func testPromptSettingsHashableInequality() {
        let a = PromptSettings(fontSize: 64)
        let b = PromptSettings(fontSize: 72)
        XCTAssertNotEqual(a, b)
    }

    // MARK: - ScriptDocument Mutation

    func testMutatingTitle() {
        var doc = ScriptDocument(title: "Original")
        doc.title = "Updated"
        XCTAssertEqual(doc.title, "Updated")
    }

    func testMutatingBody() {
        var doc = ScriptDocument(body: "")
        doc.body = "New content here"
        XCTAssertEqual(doc.body, "New content here")
    }

    func testMutatingSettings() {
        var doc = ScriptDocument()
        doc.settings.fontSize = 120
        doc.settings.mirrorHorizontal = true
        XCTAssertEqual(doc.settings.fontSize, 120)
        XCTAssertTrue(doc.settings.mirrorHorizontal)
    }

    func testAppendingSegments() {
        var doc = ScriptDocument()
        XCTAssertTrue(doc.segments.isEmpty)
        doc.segments.append(ScriptSegment(startCharacterIndex: 0))
        doc.segments.append(ScriptSegment(startCharacterIndex: 50))
        XCTAssertEqual(doc.segments.count, 2)
    }

    // MARK: - Large Content

    func testLargeBodyCodable() throws {
        let largeBody = String(repeating: "This is a long teleprompter script line. ", count: 10_000)
        let original = ScriptDocument(title: "Long Script", body: largeBody)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptDocument.self, from: data)
        XCTAssertEqual(decoded.body.count, largeBody.count)
    }

    func testManySegmentsCodable() throws {
        let segments = (0..<100).map { ScriptSegment(title: "Seg \($0)", startCharacterIndex: $0 * 100) }
        let original = ScriptDocument(segments: segments)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScriptDocument.self, from: data)
        XCTAssertEqual(decoded.segments.count, 100)
        XCTAssertEqual(decoded.segments[99].title, "Seg 99")
        XCTAssertEqual(decoded.segments[99].startCharacterIndex, 9900)
    }
}
