import SwiftUI
import AVFoundation

struct MainView: View {
    @State private var modelDirectory: URL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    @State private var selectedModel: String?
    @State private var models: [String] = []
    @State private var isDownloading: Bool = false
    @State private var downloadProgress: Double = 0.0
    @State private var errorMessage: String?
    @State private var tempo: Double = 120.0
    @State private var style: String = "Classical"
    @State private var generatedMusic: Data?
    @State private var isPreviewing: Bool = false
    @State private var batchCount: Int = 1

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
            HStack {
                Text("Tempo:")
                Slider(value: $tempo, in: 60...180, step: 1)
                Text("\(Int(tempo)) BPM")
            }
            HStack {
                Text("Style:")
                TextField("Style", text: $style)
            }
            HStack {
                Text("Batch Count:")
                Stepper(value: $batchCount, in: 1...10) {
                    Text("\(batchCount)")
                }
            }
            if isDownloading {
                ProgressView(value: downloadProgress)
            }
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red)
            }
            Button("Generate Music") {
                // Trigger music generation with selected model
            }
            Button("Preview Music") {
                // Preview generated music
            }
            Button("Delete Model") {
                // Delete selected model
            }
        }
        .onAppear {
            Task {
                do {
                    let downloader = ModelDownloader()
                    models = try await downloader.fetchMusicModels()
                } catch {
                    errorMessage = "Failed to fetch models: \(error)"
                }
            }
        }
    }
}
