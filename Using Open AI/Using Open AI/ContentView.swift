//
//  ContentView.swift
//  Using Open AI
//
//  Created by Mohamad Alfarra on 4/9/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                    
                Spacer()
                
                Text("Choose one of the following options:")
                
Spacer ()
                
                NavigationLink(destination: Images()) {
                    Text("Generate Images")
                }
                .padding()
                
                NavigationLink(destination: SentenceCompleter()) {
                    Text("Sentence Completer")
                }
                .padding()
                
                NavigationLink(destination: Sentiments()) {
                    Text("Find Sentiment of Text")
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("OpenAI App")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

