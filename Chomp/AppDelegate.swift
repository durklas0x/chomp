import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    private let frameInterval = 0.6
    private let idleFrames = ["cat_idle_1", "cat_idle_2"]
    private let holdFrames = ["cat_hold_1", "cat_hold_2"]
    private let presentFrames = ["cat_present_1", "cat_present_2"]
    lazy var tray = Tray(contentView: EmptyView())

    private var timer: Timer?
    private var currentState: State?
    private var currentFile: URL?

    func applicationDidFinishLaunching(_ notification: Notification) {
        updateState(.idle)
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        guard self.currentFile == nil, let file = urls.first else { return }

        self.currentFile = file
        updateState(.hold)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
        if self.currentFile != nil {
            updateState(.present)
            self.tray.show()
        }
        return false
    }

    func applicationWillTerminate(_ notification: Notification) {
        self.timer?.invalidate()
    }

    private func updateState(_ state: State) {
        guard self.currentState != state else { return }

        self.currentState = state
        let frames =
            switch state {
            case .idle:
                self.idleFrames
            case .hold:
                self.holdFrames
            case .present:
                self.presentFrames
            }
        self.timer?.invalidate()

        var frameIndex = 0
        updateDockTile(frames[frameIndex])
        self.timer = Timer.scheduledTimer(withTimeInterval: self.frameInterval, repeats: true) {
            [unowned self] _ in
            frameIndex = (frameIndex + 1) % frames.count
            updateDockTile(frames[frameIndex])
        }
    }

    private func updateDockTile(_ frame: String) {
        let dockTile = NSApp.dockTile
        guard let image = NSImage(named: frame) else { return }
        dockTile.contentView = NSImageView(
            image: image
        )
        dockTile.display()
    }
}
