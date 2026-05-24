import SwiftUI

struct PrompterView: View {
    @ObservedObject var engine: PlaybackEngine
    
    @State private var showControls: Bool = true
    
    init(engine: PlaybackEngine) {
        self.engine = engine
    }
    
    var body: some View {
        ZStack {
            Color(hex: engine.script.settings.backgroundColorHex)
                .opacity(engine.script.settings.backgroundOpacity)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        Text(engine.script.body)
                            .font(.system(size: engine.script.settings.fontSize, weight: .bold, design: .default))
                            .lineSpacing(engine.script.settings.lineHeight * engine.script.settings.fontSize - engine.script.settings.fontSize)
                            .foregroundColor(Color(hex: engine.script.settings.textColorHex))
                            .frame(width: min(geometry.size.width, engine.script.settings.textWidth), alignment: .leading)
                            .padding(.top, geometry.size.height / 2) // Start in middle
                            .padding(.bottom, geometry.size.height) // Space to scroll past end
                            .offset(y: -engine.scrollOffset)
                    }
                    .disabled(engine.isPlaying)
                }
            }
            
            // Middle marker
            HStack {
                Rectangle()
                    .fill(Color.red.opacity(0.5))
                    .frame(width: 20, height: 2)
                Spacer()
                Rectangle()
                    .fill(Color.red.opacity(0.5))
                    .frame(width: 20, height: 2)
            }
            
            // Controls overlay
            if showControls {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: { engine.restart() }) {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .buttonStyle(.plain)
                        .padding()
                        
                        Button(action: { engine.rewind() }) {
                            Image(systemName: "backward.end.fill")
                        }
                        .buttonStyle(.plain)
                        .padding()
                        
                        Button(action: { engine.togglePlayPause() }) {
                            Image(systemName: engine.isPlaying || engine.countdown > 0 ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        .padding()
                        
                        VStack {
                            Text(String(format: "%.1fx", engine.speedMultiplier))
                                .font(.caption)
                                .foregroundColor(.white)
                            Slider(value: $engine.speedMultiplier, in: 0.5...2.5, step: 0.1)
                                .frame(width: 100)
                        }
                        .padding()
                    }
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    .padding(.bottom, 20)
                }
            }
            
            // Countdown overlay
            if engine.countdown > 0 {
                Text("\(engine.countdown)")
                    .font(.system(size: 150, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: engine.script.settings.textColorHex).opacity(0.8))
                    .transition(.scale)
            }
        }
        .onHover { isHovering in
            withAnimation {
                showControls = isHovering || (!engine.isPlaying && engine.countdown == 0)
            }
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                switch event.keyCode {
                case 49: // Space
                    engine.togglePlayPause()
                    return nil
                case 126: // Up Arrow
                    engine.speedMultiplier = min(2.5, engine.speedMultiplier + 0.1)
                    return nil
                case 125: // Down Arrow
                    engine.speedMultiplier = max(0.5, engine.speedMultiplier - 0.1)
                    return nil
                default:
                    return event
                }
            }
        }
        // Support for mirroring
        .scaleEffect(x: engine.script.settings.mirrorHorizontal ? -1 : 1, 
                     y: engine.script.settings.mirrorVertical ? -1 : 1)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
