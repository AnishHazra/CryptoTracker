//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 30/06/25.
//

import Foundation
import Combine


class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailSubscriptions: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinsDetails()
    }
    
    func getCoinsDetails(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        ) else {return}
        
        coinDetailSubscriptions = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedCoins) in
                    self?.coinDetails = returnedCoins
                    self?.coinDetailSubscriptions?.cancel()
                }
            )
        
    }
}
