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
        
        var errorDescription: String? {
            switch self {
            case .badResponse(let errString): return "🫤 Bad response from url: [\(errString)] "
            case .unknown: return "😵‍💫 Unknown Error Occured. "
            }
        }
        
    }
    
    static func download(for url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap{ try Self.handleUrl(response: $0, for: url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleUrl(response: URLSession.DataTaskPublisher.Output, for url: URL) throws -> Data{
        guard let httpResponse = response.response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NwError.badResponse(url.absoluteString)
        }
        return response.data
    }
    
}
