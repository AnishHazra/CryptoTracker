//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 30/06/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDetailService.$coinDetails
            .sink{ (returnedCoinDetails) in
                print("Received coin details data")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
    
}
