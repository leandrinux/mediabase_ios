//
//  Networking.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

class Networking: NSObject {

    static let baseURL = "http://leandrim1.local:3000"

    func sendJsonRequest<T:Codable, U:Codable>(method: HTTPMethod, endpoint: String, arguments: T, completion: @escaping (Result<U, Error>) -> Void) async {
        
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
            let decodedResponse = try JSONDecoder().decode(U.self, from: data)
            if httpResponse.statusCode < 400 {
                completion(.success(decodedResponse))
            } else {
                completion(.failure(NSError(domain: "Server error", code: 0)))
            }
                
        } catch {
            completion(.failure(error))
        }
        
    }
        
}

extension Networking: URLSessionDelegate {
    
}

