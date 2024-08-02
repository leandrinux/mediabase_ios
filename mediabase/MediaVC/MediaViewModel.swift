//
//  MediaViewModel.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import Foundation


class MediaViewModel {
 
    var media: Media?

    func deleteMedia(completion: @escaping (Result<Bool, Error>) -> Void) async {
        guard let media = media else { return }
        await MediabaseAPI.shared.deleteMedia(media) { result in
            completion(result)
        }
    }
    
    func getMedia(_ completion: @escaping () -> Void) {
        Task {
            guard let id = self.media?.id else { return }
            await MediabaseAPI.shared.getMedia(id) { result in
                switch result {
                    
                case .success( let media ):
                    self.media = media
                    
                case .failure( let error ):
                    debugPrint(error)
                }
            }
        }
    }
    
}
