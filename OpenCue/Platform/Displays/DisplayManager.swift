import AppKit

class DisplayManager: ObservableObject {
    @Published var availableDisplays: [NSScreen] = []
    
    init() {
        refreshDisplays()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDisplays), name: NSApplication.didChangeScreenParametersNotification, object: nil)
    }
    
    @objc func refreshDisplays() {
        self.availableDisplays = NSScreen.screens
    }
}
