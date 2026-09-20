import SwiftUI

class Tray: NSPanel {
    public var isOpened = false

    init(contentView: some View) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 400),
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

        self.contentView = NSHostingView(rootView: contentView)
    }

    public func show() {
        orderFrontRegardless()
    }

    public func hide() {
        orderOut(nil)
    }
}
