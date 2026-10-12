import SwiftUI

struct FilePanelContentView: View {

    @Environment(\.displayScale) private var displayScale

    let content: FilePanelContent
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Chomp's belly")
                    .font(.headline)
                Spacer()
                Text(content.files.count, format: .number)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("\(content.files.count) files")
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .semibold))
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .help("Close panel")
                .accessibilityLabel("Close panel")
            }

            Divider()

            if content.files.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Text("No files yet")
                        .font(.headline)
                    Text("Open files with Chomp to keep them here.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(content.files.enumerated()), id: \.offset) { _, file in
                            FileRowView(file: file)
                                .onDrag(
                                    {
                                        let provider =
                                            NSItemProvider(contentsOf: file.url) ?? NSItemProvider()
                                        provider.suggestedName =
                                            file.url.deletingPathExtension().lastPathComponent
                                        return provider
                                    },
                                    preview: {
                                        FileRowView(file: file).foregroundStyle(.black)
                                    }
                                )
                                .onDragSessionUpdated({ session in
                                    if session.phase == .ended(.copy)
                                        || session.phase == .ended(.move)
                                    {
                                        content.files.removeAll(where: { $0.url == file.url })
                                    }
                                }).task(id: file.url) {
                                    await content.loadThumbnail(for: file.url, scale: displayScale)
                                }
                        }
                    }
                    .padding(.vertical, 2)
                    .accessibilityElement(children: .contain)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
