import SwiftUI

struct FilePanelContentView: View {
    let content: FilePanelContent

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Files")
                    .font(.headline)
                Spacer()
                Text(content.files.count, format: .number)
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("\(content.files.count) files")
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
                            HStack(spacing: 10) {
                                Image(nsImage: NSWorkspace.shared.icon(forFile: file.path))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .accessibilityHidden(true)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(file.lastPathComponent)
                                        .font(.body)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    Text(file.deletingLastPathComponent().lastPathComponent)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(file.lastPathComponent)
                            .accessibilityValue(file.deletingLastPathComponent().lastPathComponent)
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
