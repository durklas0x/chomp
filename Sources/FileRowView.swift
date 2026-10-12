import SwiftUI

struct FileRowView: View {
    let file: FileItem

    var body: some View {
        HStack(spacing: 10) {
            FileThumbnailView(thumbnail: file.thumbnail, fileUrl: file.url)
            VStack(alignment: .leading, spacing: 2) {
                Text(file.url.lastPathComponent)
                    .font(.body)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(file.url.deletingLastPathComponent().lastPathComponent)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(file.url.lastPathComponent)
        .accessibilityValue(
            file.url.deletingLastPathComponent().lastPathComponent)
    }
}
