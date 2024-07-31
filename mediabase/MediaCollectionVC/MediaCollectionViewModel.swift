//
//  MediaCollectionViewModel.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation
import Alamofire

struct FetchMediaRequest: Codable {
    
}

struct Media: Hashable, Codable {
    let ID: Int
    var latitude: Double?
    var longitude: Double?
    
    private enum CodingKeys: String, CodingKey {
        case ID = "media_id"
        case latitude
        case longitude
    }
}

struct UploadMediaResponse: Codable {
    let ID: Int
    let message: String
    private enum CodingKeys: String, CodingKey {
        case ID = "media_id"
        case message
    }
}

class MediaCollectionViewModel {
    
    var media: [Media]? {
        didSet {
            guard let media = media else { return }
            print("Retrieved \(media.count) media")
        }
    }
    
    func fetchAll() async {
        print("Fetching all media")
        let endpoint = "\(Networking.baseURL)/media"
        await Networking().sendJsonRequest(method: .get, endpoint: endpoint, arguments: FetchMediaRequest()) { (result: Result<[Media], Error>) in
            switch result {
            case .success(let responseModel):
                self.media = responseModel
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func uploadMedia(_ imageData: Data) async {
        let endpoint = "\(Networking.baseURL)/media"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "media", fileName: "file.png", mimeType: "image/jpeg")
        }, to: endpoint)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .response { data in
            print(data)
        }

    }
    
}
