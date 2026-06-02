import XCTest
import SwiftUI
@testable import OpenCue

final class ColorExtensionTests: XCTestCase {

    // MARK: - Color(hex:) 6-character

    func testHexWhite() {
        let color = Color(hex: "#FFFFFF")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 1.0, accuracy: 0.01)
    }

    func testHexBlack() {
        let color = Color(hex: "#000000")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    func testHexRed() {
        let color = Color(hex: "#FF0000")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    func testHexGreen() {
        let color = Color(hex: "#00FF00")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    func testHexBlue() {
        let color = Color(hex: "#0000FF")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 1.0, accuracy: 0.01)
    }

    func testHexArbitraryColor() {
        let color = Color(hex: "#4A90D9")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 74.0 / 255.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 144.0 / 255.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 217.0 / 255.0, accuracy: 0.01)
    }

    // MARK: - Color(hex:) without # prefix

    func testHexWithoutHash() {
        let color = Color(hex: "FF0000")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    // MARK: - Color(hex:) lowercase

    func testHexLowercase() {
        let color = Color(hex: "#ff8800")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 136.0 / 255.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    // MARK: - Color(hex:) 3-character shorthand

    func testHex3CharWhite() {
        let color = Color(hex: "#FFF")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 1.0, accuracy: 0.01)
    }

    func testHex3CharBlack() {
        let color = Color(hex: "#000")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    func testHex3CharExpands() {
        // #F80 should expand to #FF8800
        let color = Color(hex: "#F80")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 136.0 / 255.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    // MARK: - Color(hex:) 8-character (ARGB)

    func testHex8CharFullOpacity() {
        let color = Color(hex: "#FFFF0000")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.alpha, 1.0, accuracy: 0.01)
    }

    func testHex8CharHalfOpacity() {
        let color = Color(hex: "#80FF0000")
        let components = color.cgColorComponents
        XCTAssertEqual(components.alpha, 128.0 / 255.0, accuracy: 0.01)
    }

    // MARK: - Color(hex:) invalid input

    func testHexInvalidFallsToBlack() {
        let color = Color(hex: "#XYZ")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    func testHexEmptyStringFallsToBlack() {
        let color = Color(hex: "")
        let components = color.cgColorComponents
        XCTAssertEqual(components.red, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.green, 0.0, accuracy: 0.01)
        XCTAssertEqual(components.blue, 0.0, accuracy: 0.01)
    }

    // MARK: - Color.toHex()

    func testToHexRed() {
        let color = Color(red: 1.0, green: 0.0, blue: 0.0)
        let hex = color.toHex()
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex?.lowercased(), "#ff0000")
    }

    func testToHexWhite() {
        let color = Color(red: 1.0, green: 1.0, blue: 1.0)
        let hex = color.toHex()
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex?.lowercased(), "#ffffff")
    }

    func testToHexBlack() {
        let color = Color(red: 0.0, green: 0.0, blue: 0.0)
        let hex = color.toHex()
        XCTAssertNotNil(hex)
        XCTAssertEqual(hex?.lowercased(), "#000000")
    }

    // MARK: - Round Trip

    func testHexRoundTrip() {
        let originalHex = "#4A90D9"
        let color = Color(hex: originalHex)
        let resultHex = color.toHex()
        XCTAssertNotNil(resultHex)

        let reconstructed = Color(hex: resultHex!)
        let origComponents = color.cgColorComponents
        let reconComponents = reconstructed.cgColorComponents
        XCTAssertEqual(origComponents.red, reconComponents.red, accuracy: 0.02)
        XCTAssertEqual(origComponents.green, reconComponents.green, accuracy: 0.02)
        XCTAssertEqual(origComponents.blue, reconComponents.blue, accuracy: 0.02)
    }

    func testDefaultSettingsColorsRoundTrip() {
        let settings = PromptSettings()

        let textColor = Color(hex: settings.textColorHex)
        let textHex = textColor.toHex()
        XCTAssertNotNil(textHex)

        let bgColor = Color(hex: settings.backgroundColorHex)
        let bgHex = bgColor.toHex()
        XCTAssertNotNil(bgHex)
    }
}

// MARK: - Test Helper

private struct RGBAComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

private extension Color {
    var cgColorComponents: RGBAComponents {
        let nsColor = NSColor(self)
        guard let converted = nsColor.usingColorSpace(.sRGB) else {
            return RGBAComponents(red: 0, green: 0, blue: 0, alpha: 0)
        }
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        converted.getRed(&r, green: &g, blue: &b, alpha: &a)
        return RGBAComponents(red: r, green: g, blue: b, alpha: a)
    }
}
