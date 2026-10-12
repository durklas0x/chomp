import AppKit
import QuickLookThumbnailing

@Observable
class FilePanelContent {
    var files: [FileItem] = [] {
        didSet {
            if oldValue.isEmpty != files.isEmpty {
                onEmptyChanged(files.isEmpty)
            }
        }
    }
    let onEmptyChanged: ((Bool) -> Void)

    init(onEmptyChanged: @escaping ((Bool) -> Void)) {
        self.onEmptyChanged = onEmptyChanged
    }

    func loadThumbnail(for url: URL, scale: CGFloat) async {
        let request = QLThumbnailGenerator.Request(
            fileAt: url, size: CGSize(width: 28, height: 28), scale: scale,
            representationTypes: .thumbnail)

        do {
            let repr = try await QLThumbnailGenerator.shared.generateBestRepresentation(
                for: request)
            if let index = files.firstIndex(where: { $0.url == url }) {
                files[index].thumbnail = repr.nsImage
            }
        } catch {
            print(error)
        }
    }
}
