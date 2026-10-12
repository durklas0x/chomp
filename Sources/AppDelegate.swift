import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    private let frameInterval = 0.6
    private let idleFrames = ["cat_idle_1", "cat_idle_2"]
    private let fullFrames = ["cat_full_1", "cat_full_2"]

    private var statusItem: NSStatusItem?
    private var filePanel: FilePanel?
    private var timer: Timer?
    private var currentState: CatState?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem = statusItem

        let statusItemButton = statusItem.button!
        statusItemButton.image = NSImage(
            systemSymbolName: "pet.carrier", accessibilityDescription: nil)
        statusItemButton.target = self
        statusItemButton.action = #selector(statusItemClicked)

        self.filePanel = FilePanel()
        updateState(.idle)
    }

    @objc func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let panel = self.filePanel, let buttonFrame = self.statusItem?.button?.window?.frame
        else { return }

        panel.toggle(buttonPoint: NSPoint(x: buttonFrame.midX, y: buttonFrame.minY))
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        guard !urls.isEmpty else { return }
        guard let panel = self.filePanel else { return }
        // check for uniqueness later on (don't know if we're going to actually end up storing URLs)
        panel.addFiles(urls)
        updateState(.full)
    }

    func applicationWillTerminate(_ notification: Notification) {
        self.timer?.invalidate()
    }

    private func updateState(_ state: CatState) {
        guard self.currentState != state else { return }

        self.currentState = state
        let frames =
            switch state {
            case .idle:
                self.idleFrames
            case .full:
                self.fullFrames
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
