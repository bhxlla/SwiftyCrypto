//
//  NetworkManager.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 31/12/22.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NwError: LocalizedError {
        case badResponse(String)
        case unknown
        case rateLimit
        case networkError
        
        var errorDescription: String? {
            switch self {
            case .badResponse(let errString): return "🫤 Bad response from url: [\(errString)] "
            case .unknown: return "😵‍💫 Unknown Error Occured."
            case .rateLimit: return "😬 API limit reached. Try again after some time."
            case .networkError: return "Network Connection Error. Try again after some time."
            }
        }
        
    }
    
    static func download(for url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in NwError.networkError }
//            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap{ try Self.handleUrl(response: $0, for: url) }
//            .receive(on: DispatchQueue.main)
            .retry(3)
            .eraseToAnyPublisher()
    }

    static func handleUrl(response: URLSession.DataTaskPublisher.Output, for url: URL) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw NwError.badResponse(url.absoluteString)
        }
        if httpResponse.statusCode == 429 {
            throw NwError.rateLimit
        } else if !(200..<300).contains(httpResponse.statusCode) {
            throw NwError.badResponse(url.absoluteString)
        }
        return response.data
    }
    
}
