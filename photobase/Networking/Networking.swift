//
//  Networking.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class Networking: NSObject {
    
    func sendRequest<T:Codable, U:Codable>(method: HTTPMethod, endpoint: String, arguments: T, completion: @escaping (Result<U, Error>) -> Void) async {
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method != .get {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let body = try encoder.encode(arguments)
                request.httpBody = body
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0)))
                return
            }
            if httpResponse.statusCode < 400 {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedResponse))
            }
        } catch {
            completion(.failure(error))
        }
        
    }
    
}

extension Networking: URLSessionDelegate {
    
}

