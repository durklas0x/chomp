import SwiftUI

class FilePanel: NSPanel {
    private let size = 128
    private var isOpened = false
    private let content = FilePanelContent()

    init() {
        super.init(
            contentRect: NSRect(
                x: 0, y: 0, width: size, height: size),
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        isFloatingPanel = true
        level = .floating
        hidesOnDeactivate = false
        isMovableByWindowBackground = true
        becomesKeyOnlyIfNeeded = true
        animationBehavior = .utilityWindow
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        self.contentView = NSHostingView(rootView: FilePanelContentView(content: content))
    }

    func toggle(buttonPoint: NSPoint) {
        if self.isOpened {
            orderOut(nil)
        } else {
            setFrameOrigin(NSPoint(x: Int(buttonPoint.x) - size / 2, y: Int(buttonPoint.y) - size))
            orderFrontRegardless()
        }
        self.isOpened = !self.isOpened
    }

    func addFiles(_ files: [URL]) {
        self.content.files.append(contentsOf: files)
    }
}
