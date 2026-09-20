import Cocoa

class MouseLocator {
    init(_ onMouseMoved: @escaping (_ location: NSPoint) -> Void) {
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            onMouseMoved(NSEvent.mouseLocation)
        }
    }
}
