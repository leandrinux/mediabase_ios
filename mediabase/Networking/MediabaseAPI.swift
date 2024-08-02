//
//  MediabaseAPI.swift
//  mediabase
//
//  Created by Leandro on 01/08/2024.
//

import Foundation
import Alamofire

class MediabaseAPI: NSObject {

    static let shared = MediabaseAPI()
    static let baseURL = "http://leandrim1.local:3000"
 
    func getAllMedia(_ completion: @escaping (Result<[Media], Error>) -> Void) async  {
        let endpoint = "\(MediabaseAPI.baseURL)/media"
        await sendJsonRequest(method: .get, endpoint: endpoint, arguments: EmptyRequest()) { (result: Result<[Media], Error>) in
            completion(result)
        }
    }

    func deleteMedia(_ media: Media, completion: @escaping (Result<Bool, Error>) -> Void) async {

        let endpoint = "\(MediabaseAPI.baseURL)/media"
        AF.request(endpoint,
                   method: .delete,
                   parameters: SimpleRequest(id: media.id),
                   encoder: URLEncodedFormParameterEncoder.default).response { result in
            guard let response = result.response else { return }
            if response.statusCode < 400 {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "Server error", code: 0)))
            }
        }
    }
    
    func uploadMedia(_ imageData: Data, completion: @escaping () -> Void) async {
        let endpoint = "\(MediabaseAPI.baseURL)/media"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "media", fileName: "file.png", mimeType: "image/jpeg")
        }, to: endpoint)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .response { data in
            completion()
        }
    }

    fileprivate func sendJsonRequest<T:Codable, U:Codable>(method: HTTPMethod, endpoint: String, arguments: T, completion: @escaping (Result<U, Error>) -> Void) async {
        
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

fileprivate enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

extension MediabaseAPI: URLSessionDelegate { }

// MARK: Model entities

struct Media: Hashable, Codable {
    let id: UUID
    var latitude: Double?
    var longitude: Double?
}

// MARK: Request and response struct

struct EmptyRequest: Codable { }

struct SimpleRequest: Encodable {
    let id: UUID
}

struct UploadMediaResponse: Codable {
    let id: UUID
    let message: String
}
