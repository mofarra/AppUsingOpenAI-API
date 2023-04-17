//
//  Images.swift
//  Using Open AI
//
//  Created by Mohamad Alfarra on 4/9/23.
//

import SwiftUI

struct Images: View {
    @State private var text: String = ""
    @State private var generatedImage: Image?
    
    private let apiKey = "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"
    
    var body: some View {
        VStack {
            TextField("Enter your text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Generate Image") {
                generateImage()
            }
            if let image = generatedImage {
                image
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding()
    }
    
    private func generateImage() {
        let url = URL(string: "https://api.openai.com/v1/images/generations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "image-alpha-001",
            "prompt": text,
            "num_images": 1
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            guard let data = data else {
                print(error ?? "Unknown error")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let imageGenerationResponse = try jsonDecoder.decode(ImageGenerationResponse.self, from: data)
                DispatchQueue.main.async {
                    self.generatedImage = Image(uiImage: UIImage(data: imageGenerationResponse.data.first!.imageData)!)
                }
            } catch let error {
                print("Error decoding response: \(error)")
            }

        }.resume()
    }
}

struct ImageGenerationResponse: Codable {
    let data: [ImageData]
}

struct ImageData: Codable {
    let imageData: Data
    
    enum CodingKeys: String, CodingKey {
        case imageData = "data"
    }
}

struct Images_Previews: PreviewProvider {
    static var previews: some View {
        Images()
    }
}

