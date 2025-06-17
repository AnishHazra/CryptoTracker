//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 17/06/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image
        ) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager
                    .handleCompletion,
                receiveValue: { [weak self] (returnedCoins) in
                    self?.image = returnedCoins
                    self?.imageSubscription?.cancel()
                }
            )
    }
}
