import SwiftUI

class FilePanel: NSPanel {
    private let panelSize = NSSize(width: 320, height: 240)
    private let content = FilePanelContent()

    init() {
        super.init(
            contentRect: NSRect(origin: .zero, size: panelSize),
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        title = "Chomp Files"
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        isFloatingPanel = true
        level = .floating
        hidesOnDeactivate = false
        isMovableByWindowBackground = true
        becomesKeyOnlyIfNeeded = true
        animationBehavior = .utilityWindow
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true

        let hostingView = NSHostingView(rootView: FilePanelContentView(content: content))
        hostingView.sizingOptions = []
        hostingView.autoresizingMask = [.width, .height]

        let glassView = NSGlassEffectView(frame: NSRect(origin: .zero, size: panelSize))
        glassView.style = .regular
        glassView.cornerRadius = 20
        glassView.contentView = hostingView
        self.contentView = glassView
    }

    func toggle(buttonPoint: NSPoint) {
        if isVisible {
            orderOut(nil)
        } else {
            var origin = NSPoint(
                x: buttonPoint.x - panelSize.width / 2,
                y: buttonPoint.y - panelSize.height - 8
            )
            if let screen = NSScreen.screens.first(where: { $0.frame.contains(buttonPoint) }) {
                let bounds = screen.visibleFrame.insetBy(dx: 8, dy: 8)
                origin.x = min(max(origin.x, bounds.minX), bounds.maxX - panelSize.width)
                origin.y = min(max(origin.y, bounds.minY), bounds.maxY - panelSize.height)
            }
            setFrameOrigin(origin)
            orderFrontRegardless()
        }
    }

    func addFiles(_ files: [URL]) {
        content.files.append(contentsOf: files)
    }
}
