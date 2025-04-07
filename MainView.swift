import SwiftUI

struct MainView: View {
    @State private var modelDirectory: URL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    @State private var selectedModel: String?
    @State private var models: [String] = []

    var body: some View {
        VStack {
            Button("Pick Model Directory") {
                let panel = NSOpenPanel()
                panel.canChooseDirectories = true
                panel.canCreateDirectories = true
                panel.allowsMultipleSelection = false
                if panel.runModal() == .OK {
                    modelDirectory = panel.url!
                }
            }
            Text("Directory: \(modelDirectory.path)")
            Picker("Select Model", selection: $selectedModel) {
                ForEach(models, id: \.self) { model in
                    Text(model)
                }
            }
            Button("Generate Music") {
                // Trigger music generation with selected model
            }
        }
        .onAppear {
            Task {
                do {
                    let downloader = ModelDownloader()
                    models = try await downloader.fetchMusicModels()
                } catch {
                    print("Failed to fetch models: \(error)")
                }
            }
        }
    }
}
