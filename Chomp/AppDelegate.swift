import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    private let idleFrames = ["cat_idle_1", "cat_idle_2"]
    private let openMouthFrames = ["cat_open_mouth_1", "cat_open_mouth_2"]
    private let fullFrames = ["cat_full_1", "cat_full_2"]

    private var timer: Timer?
    private var currentFrames: [String]?

    func applicationDidFinishLaunching(_ notification: Notification) {
        var frameIndex = 0
        currentFrames = idleFrames

        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) {
            [weak self] _ in
            guard let self, let frames = currentFrames else { return }
            frameIndex = (frameIndex + 1) % frames.count
            updateDockTile(frames[frameIndex])
        }

    }

    func applicationWillTerminate(_ notification: Notification) {
        timer?.invalidate()
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
