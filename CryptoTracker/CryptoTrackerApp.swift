//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 16/05/25.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
