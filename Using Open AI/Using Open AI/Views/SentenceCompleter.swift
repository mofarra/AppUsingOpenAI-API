//
//  SentenceCompleter.swift
//  Using Open AI
//
//  Created by Mohamad Alfarra on 4/9/23.
//

import SwiftUI

struct CompletionResponse2: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let text: String
    let index: Int
    let logprobs: Logprobs
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case index = "index"
        case logprobs
        case finishReason = "finish_reason"
    }
}

struct Logprobs: Codable {
    let tokenLogprobs: [TokenLogprobs]
    let topLogprobs: [[String: Double]]
    let textOffset: [Int]
    let generationTime: Double
    
    enum CodingKeys: String, CodingKey {
        case tokenLogprobs = "token_logprobs"
        case topLogprobs
        case textOffset = "text_offset"
        case generationTime = "generation_time"
    }
}

struct TokenLogprobs: Codable {
    let token: String
    let logprob: Double
    let tokenId: Int
    let tokenRank: Int
}

struct SentenceCompleter: View {
    @State private var incompleteSentence: String = ""
    @State private var completedSentence: String = ""
    
    private let apiKey = "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"

    
    var body: some View {
          VStack {
              TextField("Enter your incomplete sentence", text: $incompleteSentence)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding()

              Button("Complete Sentence") {
                  completeSentence()
              }

              if !completedSentence.isEmpty {
                  Text(completedSentence)
                      .padding()
              }
          }
          .padding()
      }

      private func completeSentence() {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "text-davinci-002",
            "prompt": incompleteSentence,
            "max_tokens": 50,
            "n": 1,
            "stop": ["."]
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
                self.completedSentence = completionResponse.choices.first!.text
            }
        }
    }
}
struct SentenceCompleter_Previews: PreviewProvider {
    static var previews: some View {
        SentenceCompleter()
    }
}
