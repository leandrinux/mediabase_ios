//
//  MediaCollectionViewModel.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation

class MediaCollectionViewModel {
    
    weak var delegate: MediaCollectionViewModelDelegate?
    
    var media: [Media]?
    
    func getAllMedia(_ completion: @escaping () -> Void) {
        Task {
            await MediabaseAPI.shared.getAllMedia { result in
                switch result {
                case .success( let media ):
                    self.media = media
                case .failure( let error ):
                    debugPrint(error)
                }
                completion()
            }
        }
    }

    func uploadMedia(_ imageData: Data, completion: @escaping () -> Void) {
        Task {
        }
    }

}

protocol MediaCollectionViewModelDelegate: AnyObject {
    func reloadMedia()
}

