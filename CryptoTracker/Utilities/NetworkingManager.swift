//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Anish Hazra on 17/06/25.
//

import Foundation
import Combine


class NetworkingManager {
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if response.statusCode == 429 {
            print("🚦 Rate limited by API. Check 'Retry-After' header.")
            throw URLError(.badServerResponse, userInfo: ["statusCode": response.statusCode])
        }

        guard response.statusCode >= 200 && response.statusCode < 300 else {
            print("⚠️ Non-2xx HTTP response: \(response.statusCode)")
            throw URLError(.badServerResponse, userInfo: ["statusCode": response.statusCode])
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
                break
            case .failure(let error):
                print("❌ Error: \(error)")
                if let urlError = error as? URLError {
                    print("🌐 URLError code: \(urlError.code)")
                }
        }
    }
    
}
