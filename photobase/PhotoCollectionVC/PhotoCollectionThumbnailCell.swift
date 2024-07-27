//
//  PhotoCollectionThumbnailCell.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit
import SDWebImage

class PhotoCollectionThumbnailCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView?
    weak var delegate: PhotoCollectionThumbnailDelegate?
    
    @IBAction func doTouch() {
        guard let photo = photo else { return }
        delegate?.didTouchPhoto(photo: photo)
    }
    
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            let url = URL(string: "\(Networking.baseURL)/thumb?id=\(photo.id)")
            imageView?.sd_setImage(with: url)
        }
    }
    
}

protocol PhotoCollectionThumbnailDelegate: AnyObject {
    func didTouchPhoto(photo: Photo)
}
