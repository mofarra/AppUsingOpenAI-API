//
//  Sentiments.swift
//  Using Open AI
//
//  Created by Mohamad Alfarra on 4/9/23.
//

import SwiftUI

struct CompletionResponse: Codable {
    let choices: [CompletionChoice]
}

struct CompletionChoice: Codable {
    let text: String
}

struct Sentiments: View {
    @State private var text: String = ""
    @State private var sentiment: String = ""
    
    private let apiKey = "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"
    
    var body: some View {
        VStack {
            TextField("Enter your text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Analyze Sentiment") {
                analyzeSentiment()
            }
            
            if !sentiment.isEmpty {
                Text("The sentiment of the text is \(sentiment)")
                    .padding()
            }
        }
        .padding()
    }
    
    private func analyzeSentiment() {
        let url = URL(string: "https://api.openai.com/v1/engines/davinci-codex/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "text-davinci-002",
            "prompt": "Analyze the sentiment of the following text:\"\(text)\"",
            "temperature": 0.5,
            "max_tokens": 1,
            "n": 1,
            "stop": [".", "?", "!"]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            guard let data = data else {
                print(error ?? "Unknown error")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let completionResponse = try! jsonDecoder.decode(CompletionResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.sentiment = completionResponse.choices.first!.text
            }
        }.resume()
    }
}
struct Sentiments_Previews: PreviewProvider {
    static var previews: some View {
        Sentiments()
    }
}

