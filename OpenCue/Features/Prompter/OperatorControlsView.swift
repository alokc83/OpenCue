import SwiftUI

struct OperatorControlsView: View {
    @ObservedObject var engine: PlaybackEngine
    
    var body: some View {
        VStack(spacing: 20) {
            Text(engine.script.title)
                .font(.largeTitle)
            
            Text(engine.isPlaying ? "Playing" : (engine.countdown > 0 ? "Starting in \(engine.countdown)" : "Paused"))
                .font(.headline)
                .foregroundColor(engine.isPlaying ? .green : .orange)
            
            HStack(spacing: 30) {
                Button(action: { engine.restart() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title)
                }
                .buttonStyle(.plain)
                
                Button(action: { engine.rewind() }) {
                    Image(systemName: "backward.end.fill")
                        .font(.title)
                }
                .buttonStyle(.plain)
                
                Button(action: { engine.togglePlayPause() }) {
                    Image(systemName: engine.isPlaying || engine.countdown > 0 ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
            
            VStack {
                Text("Speed Multiplier: \(String(format: "%.1fx", engine.speedMultiplier))")
                Slider(value: $engine.speedMultiplier, in: 0.1...5.0, step: 0.1)
                    .frame(width: 200)
            }
            
            Button("Close Prompter") {
                ExternalWindowController.shared.closeAll()
                // Send notification to go back to editor
                NotificationCenter.default.post(name: .closeOperatorView, object: nil)
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension Notification.Name {
    static let closeOperatorView = Notification.Name("closeOperatorView")
}
