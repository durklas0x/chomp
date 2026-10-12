import QuickLookThumbnailing
import SwiftUI

struct FileThumbnailView: View {

    let thumbnail: NSImage?
    let fileUrl: URL

    var body: some View {
        let image = thumbnail ?? NSWorkspace.shared.icon(forFile: fileUrl.path)
        Image(nsImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)
    }
}
