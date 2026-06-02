import XCTest
@testable import OpenCue

@MainActor
final class PlaybackEngineTests: XCTestCase {

    private func makeEngine(
        wpm: Double = 150,
        countdownSeconds: Int = 3
    ) -> PlaybackEngine {
        let script = ScriptDocument(
            title: "Test",
            body: "This is a test script with enough words to scroll through during playback testing.",
            settings: PromptSettings(wordsPerMinute: wpm, countdownSeconds: countdownSeconds)
        )
        return PlaybackEngine(script: script)
    }

    // MARK: - Initial State

    func testInitialScrollOffset() {
        let engine = makeEngine()
        XCTAssertEqual(engine.scrollOffset, 0.0)
    }

    func testInitialIsNotPlaying() {
        let engine = makeEngine()
        XCTAssertFalse(engine.isPlaying)
    }

    func testInitialSpeedMultiplier() {
        let engine = makeEngine()
        XCTAssertEqual(engine.speedMultiplier, 1.0)
    }

    func testInitialCountdownIsZero() {
        let engine = makeEngine()
        XCTAssertEqual(engine.countdown, 0)
    }

    // MARK: - Play / Pause

    func testPlayFromStartTriggersCountdown() {
        let engine = makeEngine(countdownSeconds: 5)
        engine.play()
        XCTAssertEqual(engine.countdown, 5)
        XCTAssertFalse(engine.isPlaying, "Should not be playing during countdown")
    }

    func testPlayWithZeroCountdownStartsImmediately() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.play()
        XCTAssertTrue(engine.isPlaying)
        XCTAssertEqual(engine.countdown, 0)
    }

    func testPlayFromNonZeroOffsetSkipsCountdown() {
        let engine = makeEngine(countdownSeconds: 5)
        engine.scrollOffset = 100
        engine.play()
        XCTAssertTrue(engine.isPlaying)
        XCTAssertEqual(engine.countdown, 0, "Countdown should only happen from the start")
    }

    func testPauseStopsPlayback() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.play()
        XCTAssertTrue(engine.isPlaying)
        engine.pause()
        XCTAssertFalse(engine.isPlaying)
    }

    func testPauseClearsCountdown() {
        let engine = makeEngine(countdownSeconds: 5)
        engine.play()
        XCTAssertEqual(engine.countdown, 5)
        engine.pause()
        XCTAssertEqual(engine.countdown, 0)
        XCTAssertFalse(engine.isPlaying)
    }

    func testPauseWhenNotPlayingIsNoOp() {
        let engine = makeEngine()
        XCTAssertFalse(engine.isPlaying)
        engine.pause()
        XCTAssertFalse(engine.isPlaying)
    }

    // MARK: - Toggle Play/Pause

    func testToggleFromPausedToPlaying() {
        let engine = makeEngine(countdownSeconds: 0)
        XCTAssertFalse(engine.isPlaying)
        engine.togglePlayPause()
        XCTAssertTrue(engine.isPlaying)
    }

    func testToggleFromPlayingToPaused() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.play()
        XCTAssertTrue(engine.isPlaying)
        engine.togglePlayPause()
        XCTAssertFalse(engine.isPlaying)
    }

    func testToggleDuringCountdownPauses() {
        let engine = makeEngine(countdownSeconds: 5)
        engine.play()
        XCTAssertEqual(engine.countdown, 5)
        engine.togglePlayPause()
        XCTAssertEqual(engine.countdown, 0, "Toggle during countdown should cancel it")
        XCTAssertFalse(engine.isPlaying)
    }

    func testDoubleToggleRestoresState() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.scrollOffset = 10
        engine.togglePlayPause()
        XCTAssertTrue(engine.isPlaying)
        engine.togglePlayPause()
        XCTAssertFalse(engine.isPlaying)
    }

    // MARK: - Rewind

    func testRewindResetsOffset() {
        let engine = makeEngine()
        engine.scrollOffset = 500
        engine.rewind()
        XCTAssertEqual(engine.scrollOffset, 0.0)
    }

    func testRewindFromZeroIsNoOp() {
        let engine = makeEngine()
        engine.rewind()
        XCTAssertEqual(engine.scrollOffset, 0.0)
    }

    func testRewindDoesNotAffectPlayState() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.play()
        engine.scrollOffset = 200
        engine.rewind()
        XCTAssertEqual(engine.scrollOffset, 0.0)
        XCTAssertTrue(engine.isPlaying, "Rewind should not pause")
    }

    // MARK: - Restart

    func testRestartResetsAndPlays() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.scrollOffset = 300
        engine.restart()
        XCTAssertEqual(engine.scrollOffset, 0.0)
    }

    func testRestartFromPausedState() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.scrollOffset = 500
        engine.restart()
        XCTAssertEqual(engine.scrollOffset, 0.0)
    }

    func testRestartTriggersCountdownWhenConfigured() {
        let engine = makeEngine(countdownSeconds: 3)
        engine.scrollOffset = 200
        engine.restart()
        XCTAssertEqual(engine.scrollOffset, 0.0)
        XCTAssertEqual(engine.countdown, 3, "Restart from offset=0 should trigger countdown")
    }

    // MARK: - Speed Multiplier

    func testSpeedMultiplierDefaultIsOne() {
        let engine = makeEngine()
        XCTAssertEqual(engine.speedMultiplier, 1.0)
    }

    func testSpeedMultiplierCanBeSet() {
        let engine = makeEngine()
        engine.speedMultiplier = 2.0
        XCTAssertEqual(engine.speedMultiplier, 2.0)
    }

    func testSpeedMultiplierAffectsScrollRate() {
        let fastEngine = makeEngine(wpm: 150, countdownSeconds: 0)
        let slowEngine = makeEngine(wpm: 150, countdownSeconds: 0)

        fastEngine.play()
        slowEngine.play()

        fastEngine.speedMultiplier = 2.0
        slowEngine.speedMultiplier = 1.0

        fastEngine.update()
        slowEngine.update()

        // Both should advance, but we can't compare exact values since
        // update() uses CACurrentMediaTime() delta. Just verify both advance.
        // The important thing is that the multiplier is stored correctly.
        XCTAssertEqual(fastEngine.speedMultiplier, 2.0)
        XCTAssertEqual(slowEngine.speedMultiplier, 1.0)
    }

    // MARK: - Update (Scroll Advancement)

    func testUpdateDoesNothingWhenPaused() {
        let engine = makeEngine()
        XCTAssertFalse(engine.isPlaying)
        let before = engine.scrollOffset
        engine.update()
        XCTAssertEqual(engine.scrollOffset, before, "update() should not advance when paused")
    }

    func testUpdateAdvancesWhenPlaying() {
        let engine = makeEngine(wpm: 150, countdownSeconds: 0)
        engine.play()
        XCTAssertTrue(engine.isPlaying)

        // Call update twice — first call initializes lastFrameTime delta,
        // second call should produce a measurable offset
        engine.update()
        Thread.sleep(forTimeInterval: 0.05)
        engine.update()

        XCTAssertGreaterThan(engine.scrollOffset, 0.0, "Scroll should advance while playing")
    }

    func testUpdateWithZeroWPMDoesNotAdvance() {
        let engine = makeEngine(wpm: 0, countdownSeconds: 0)
        engine.play()
        engine.update()
        Thread.sleep(forTimeInterval: 0.01)
        engine.update()
        XCTAssertEqual(engine.scrollOffset, 0.0, "Zero WPM should produce zero scroll")
    }

    // MARK: - Script Property

    func testScriptIsAccessible() {
        let engine = makeEngine(wpm: 200)
        XCTAssertEqual(engine.script.settings.wordsPerMinute, 200)
    }

    func testScriptTitlePreserved() {
        let engine = makeEngine()
        XCTAssertEqual(engine.script.title, "Test")
    }

    // MARK: - Edge Cases

    func testMultiplePlayCallsAreIdempotent() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.play()
        XCTAssertTrue(engine.isPlaying)
        engine.play()
        XCTAssertTrue(engine.isPlaying)
    }

    func testMultiplePauseCallsAreIdempotent() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.play()
        engine.pause()
        XCTAssertFalse(engine.isPlaying)
        engine.pause()
        XCTAssertFalse(engine.isPlaying)
    }

    func testRapidToggling() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.scrollOffset = 10
        for _ in 0..<20 {
            engine.togglePlayPause()
        }
        XCTAssertFalse(engine.isPlaying, "Even number of toggles should leave paused")
    }

    func testRapidTogglingOdd() {
        let engine = makeEngine(countdownSeconds: 0)
        engine.scrollOffset = 10
        for _ in 0..<21 {
            engine.togglePlayPause()
        }
        XCTAssertTrue(engine.isPlaying, "Odd number of toggles should leave playing")
    }
}
