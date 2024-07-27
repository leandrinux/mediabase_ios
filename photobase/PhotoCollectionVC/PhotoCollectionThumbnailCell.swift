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
    
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            let url = URL(string: "http://localhost:3000/photo?id=\(photo.id)")
            imageView?.sd_setImage(with: url)
        }
    }
    
}
