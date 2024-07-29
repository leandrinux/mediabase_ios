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
        guard let media = media else { return }
        delegate?.didTouchMedia(media: media)
    }
    
    var media: Media? {
        didSet {
            guard let media = media else { return }
            let url = URL(string: "\(Networking.baseURL)/thumb?id=\(media.ID)")
            imageView?.sd_setImage(with: url)
        }
    }
    
}

protocol PhotoCollectionThumbnailDelegate: AnyObject {
    func didTouchMedia(media: Media)
}
