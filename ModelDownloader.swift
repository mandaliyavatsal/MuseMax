import Foundation

class ModelDownloader {
    func fetchMusicModels() async throws -> [String] {
        let url = URL(string: "https://api.huggingface.co/models?filter=music-generation")!
        var request = URLRequest(url: url)
        request.setValue("Bearer YOUR_HUGGING_FACE_API_TOKEN", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let models = try JSONDecoder().decode([String].self, from: data)
        return models
    }

    func downloadModel(modelName: String, to directory: URL) async throws {
        let url = URL(string: "https://huggingface.co/\(modelName)/resolve/main/model.pt")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let fileURL = directory.appendingPathComponent("\(modelName).pt")
        try data.write(to: fileURL)
    }
    
    func updateModel(modelName: String, in directory: URL) async throws {
        let fileURL = directory.appendingPathComponent("\(modelName).pt")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
        try await downloadModel(modelName: modelName, to: directory)
    }
}
