import SwiftUI

struct FilePanelContentView: View {
    let content: FilePanelContent

    var body: some View {
        print(content.files)
        return
            VStack {
                ForEach(content.files, id: \.self) {
                    file in Text(file.lastPathComponent)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
