import QuickLookThumbnailing
import SwiftUI

struct FileThumbnailView: View {

    @Environment(\.displayScale) private var displayScale

    @State private var thumbnail: NSImage? = nil
    let fileUrl: URL

    var body: some View {
        let image = thumbnail ?? NSWorkspace.shared.icon(forFile: fileUrl.path)
        Image(nsImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)
            .task(id: fileUrl) {
                let request = QLThumbnailGenerator.Request(
                    fileAt: fileUrl, size: CGSize(width: 28, height: 28), scale: displayScale,
                    representationTypes: .thumbnail)

                do {
                    let repr = try await QLThumbnailGenerator.shared.generateBestRepresentation(
                        for: request)
                    thumbnail = repr.nsImage
                } catch {
                    print(error)
                }
            }
    }
}
