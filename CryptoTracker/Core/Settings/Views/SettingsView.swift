//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 03/07/25.
//

import SwiftUI

struct SettingsView: View {
    
    let instagramURL = URL(string: "https://www.instagram.com/anish_codes/")!
    let linkedInURL = URL(string: "https://www.linkedin.com/in/anish-hazra-667396176/")!
    let githubURL = URL(string: "https://github.com/AnishHazra")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com/en/api")!
    
    var body: some View {
        NavigationView{
            List{
                myProfilesSection
                coinGeckoSection
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    
    private var myProfilesSection: some View {
        Section(header: Text("Anish Codes")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @swiftfulThinking course on YouTube. It uses MVVM Architecture, Combine, and CoreData!")
            }
            .padding(.vertical)
            Link("Follow me on Instagram 🥳", destination: instagramURL)
            Link("Connect with me on LinkedIn 😇",destination: linkedInURL)
            Link("Github Link 🔗", destination: githubURL)
        }
    }
    
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
            }
            .padding(.vertical)
            Link("Visit CoinGecko 🐸", destination: coinGeckoURL)
        }
    }
}
