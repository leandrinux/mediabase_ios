//
//  PhotoCollectionViewModel.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation

struct FetchPhotosRequest: Codable {
    
}

struct Photo: Hashable, Codable {
    let id: Int
    var latitude: Double?
    var longitude: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id = "photo_id"
        case latitude
        case longitude
    }
}

class PhotoCollectionViewModel {
    
    var photos: [Photo]?
    
    func fetchAll() async {
        let endpoint = "http://localhost:3000/photos"
        await Networking().sendRequest(method: .get, endpoint: endpoint, arguments: FetchPhotosRequest()) { (result: Result<[Photo], Error>) in
            switch result {
            case .success(let responseModel):
                self.photos = responseModel
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
}
