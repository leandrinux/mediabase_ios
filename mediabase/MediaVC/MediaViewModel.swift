//
//  MediaViewModel.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation
import Alamofire

class MediaViewModel {
 
    var media: Media?

    func deleteMedia(completion: @escaping (Result<Bool, Error>) -> Void) async {
        guard let media = media else {
            completion(.failure(NSError(domain: "No media specified", code: 0)))
            return
        }
        let endpoint = "\(Networking.baseURL)/media"

        AF.request(endpoint,
                   method: .delete,
                   parameters: DeleteMediaRequest(id: media.ID),
                   encoder: URLEncodedFormParameterEncoder.default).response { result in
            guard let response = result.response else { return }
            if response.statusCode < 400 {
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "Server error", code: 0)))
            }
        }

    }
}

struct DeleteMediaRequest: Encodable {
    let id: Int
}
