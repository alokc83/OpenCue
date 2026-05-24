import SwiftUI
import Combine
import QuartzCore

@MainActor
class PlaybackEngine: ObservableObject {
    @Published var scrollOffset: CGFloat = 0.0
    @Published var isPlaying: Bool = false
    @Published var speedMultiplier: Double = 1.0 // 1.0 = base speed
    @Published var countdown: Int = 0
    
    private var displayLink: CVDisplayLink?
    private var lastFrameTime: CFTimeInterval = 0
    private var countdownTimer: Timer?
    
    var script: ScriptDocument
    
    init(script: ScriptDocument) {
        self.script = script
        setupDisplayLink()
    }
    
    deinit {
        if let link = displayLink {
            CVDisplayLinkStop(link)
        }
        countdownTimer?.invalidate()
    }
    
    private func setupDisplayLink() {
        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let link = displayLink else { return }
        
        CVDisplayLinkSetOutputCallback(link, { (displayLink, inNow, inOutputTime, flagsIn, flagsOut, displayLinkContext) -> CVReturn in
            let engine = Unmanaged<PlaybackEngine>.fromOpaque(displayLinkContext!).takeUnretainedValue()
            
            DispatchQueue.main.async {
                engine.update()
            }
            
            return kCVReturnSuccess
        }, Unmanaged.passUnretained(self).toOpaque())
    }
    
    func play() {
        if scrollOffset == 0 && script.settings.countdownSeconds > 0 {
            startCountdown()
        } else {
            startEngine()
        }
    }
    
    private func startCountdown() {
        guard countdown == 0 else { return } // Already counting down
        countdown = script.settings.countdownSeconds
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.countdown -= 1
            if self.countdown <= 0 {
                timer.invalidate()
                self.startEngine()
            }
        }
    }
    
    private func startEngine() {
        guard let link = displayLink, !isPlaying else { return }
        lastFrameTime = CACurrentMediaTime()
        CVDisplayLinkStart(link)
        isPlaying = true
    }
    
    func pause() {
        guard let link = displayLink, isPlaying else { return }
        CVDisplayLinkStop(link)
        isPlaying = false
        countdownTimer?.invalidate()
        countdown = 0
    }
    
    func togglePlayPause() {
        if isPlaying || countdown > 0 {
            pause()
        } else {
            play()
        }
    }
    
    func rewind() {
        scrollOffset = 0.0
    }
    
    func restart() {
        pause()
        rewind()
        play()
    }
    
    private func update() {
        guard isPlaying else { return }
        
        let currentTime = CACurrentMediaTime()
        let delta = currentTime - lastFrameTime
        lastFrameTime = currentTime
        
        // Calculate speed (pixels per second) based on WPM. 
        // This is a naive calculation; in a real app, you'd calculate exact pixel height of text.
        // For MVP, map WPM to a base pixels-per-second value.
        let basePixelsPerSecond = (script.settings.wordsPerMinute / 60.0) * 100.0 // arbitrary multiplier for comfortable reading
        let pixelsToMove = basePixelsPerSecond * speedMultiplier * delta
        
        scrollOffset += CGFloat(pixelsToMove)
    }
}
