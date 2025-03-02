//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct BasketballGame: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [BasketballGame]()
    
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                HStack {
                    // left: team+date
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text(game.date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    
                    // right side: score+location
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.body)
                            .fontWeight(.medium)
                        
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([BasketballGame].self, from: data)
            games = decodedResponse
            
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
