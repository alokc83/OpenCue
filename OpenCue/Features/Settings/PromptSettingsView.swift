import SwiftUI

struct PromptSettingsView: View {
    @Binding var settings: PromptSettings
    
    var body: some View {
        Form {
            Section(header: Text("Typography").font(.headline)) {
                VStack(alignment: .leading) {
                    Text("Font Size: \(Int(settings.fontSize))")
                    Slider(value: $settings.fontSize, in: 24...144, step: 2)
                }
                
                VStack(alignment: .leading) {
                    Text("Line Height: \(settings.lineHeight, specifier: "%.1f")")
                    Slider(value: $settings.lineHeight, in: 1.0...2.5, step: 0.1)
                }
                
                VStack(alignment: .leading) {
                    Text("Text Width: \(Int(settings.textWidth))")
                    Slider(value: $settings.textWidth, in: 400...1600, step: 50)
                }
            }
            
            Divider()
            
            Section(header: Text("Colors").font(.headline)) {
                ColorPicker("Text Color", selection: Binding(get: {
                    Color(hex: settings.textColorHex)
                }, set: { color in
                    settings.textColorHex = color.toHex() ?? "#FFFFFF"
                }))
                
                ColorPicker("Background Color", selection: Binding(get: {
                    Color(hex: settings.backgroundColorHex)
                }, set: { color in
                    settings.backgroundColorHex = color.toHex() ?? "#000000"
                }))
                
                VStack(alignment: .leading) {
                    Text("Background Opacity: \(Int(settings.backgroundOpacity * 100))%")
                    Slider(value: $settings.backgroundOpacity, in: 0.0...1.0, step: 0.05)
                }
            }
            
            Divider()
            
            Section(header: Text("Mirroring (Pro Hardware)").font(.headline)) {
                Toggle("Mirror Horizontal", isOn: $settings.mirrorHorizontal)
                Toggle("Mirror Vertical", isOn: $settings.mirrorVertical)
            }
        }
        .padding()
        .frame(width: 350, height: 450)
    }
}

extension Color {
    func toHex() -> String? {
        // macOS Color picker generates colors that need careful extraction
        let nsColor = NSColor(self)
        guard let converted = nsColor.usingColorSpace(.sRGB) else { return nil }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        converted.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format: "#%06x", rgb)
    }
}
