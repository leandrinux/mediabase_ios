//
//  PhotoCollectionViewModel.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation

struct FetchPhotosRequest: Codable {
    
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

class PhotoCollectionViewModel {
    
    var media: [Media]? {
        didSet {
            guard let media = media else { return }
            print("Retrieved \(media.count) photos")
        }
    }
    
    func fetchAll() async {
        print("Fetching all photos")
        let endpoint = "\(Networking.baseURL)/media"
        await Networking().sendRequest(method: .get, endpoint: endpoint, arguments: FetchPhotosRequest()) { (result: Result<[Media], Error>) in
            switch result {
            case .success(let responseModel):
                self.media = responseModel
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
}
