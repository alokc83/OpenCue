import Foundation

struct ScriptDocument: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
    var segments: [ScriptSegment]
    var settings: PromptSettings

    init(id: UUID = UUID(),
         title: String = "New Script",
         body: String = "",
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         segments: [ScriptSegment] = [],
         settings: PromptSettings = PromptSettings()) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.segments = segments
        self.settings = settings
    }
}

struct ScriptSegment: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String?
    var startCharacterIndex: Int
    var cuePointName: String?
    
    init(id: UUID = UUID(), title: String? = nil, startCharacterIndex: Int, cuePointName: String? = nil) {
        self.id = id
        self.title = title
        self.startCharacterIndex = startCharacterIndex
        self.cuePointName = cuePointName
    }
}

struct PromptSettings: Codable, Hashable {
    var fontSize: Double
    var lineHeight: Double
    var textWidth: Double
    var textColorHex: String
    var backgroundColorHex: String
    var backgroundOpacity: Double
    var wordsPerMinute: Double
    var mirrorHorizontal: Bool
    var mirrorVertical: Bool
    var countdownSeconds: Int

    init(fontSize: Double = 64.0,
         lineHeight: Double = 1.4,
         textWidth: Double = 800.0,
         textColorHex: String = "#FFFFFF",
         backgroundColorHex: String = "#000000",
         backgroundOpacity: Double = 1.0,
         wordsPerMinute: Double = 150.0,
         mirrorHorizontal: Bool = false,
         mirrorVertical: Bool = false,
         countdownSeconds: Int = 3) {
        self.fontSize = fontSize
        self.lineHeight = lineHeight
        self.textWidth = textWidth
        self.textColorHex = textColorHex
        self.backgroundColorHex = backgroundColorHex
        self.backgroundOpacity = backgroundOpacity
        self.wordsPerMinute = wordsPerMinute
        self.mirrorHorizontal = mirrorHorizontal
        self.mirrorVertical = mirrorVertical
        self.countdownSeconds = countdownSeconds
    }
}
