//
//  MediaCollectionThumbnailCell.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit
import SDWebImage

class MediaCollectionThumbnailCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var icon: UIImageView?
    
    weak var delegate: MediaCollectionThumbnailDelegate?
    
    @IBAction func doTouch() {
        guard let media = media else { return }
        delegate?.didTouchMedia(media: media)
    }
    
    var media: Media? {
        didSet {
            guard let media = media else { return }
            let url = URL(string: "\(MediabaseAPI.baseURL)/media/\(media.id)/preview")
            imageView?.sd_setImage(with: url)
            icon?.isHidden = media.type != "video"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.sd_cancelCurrentImageLoad()
        self.imageView?.image = UIImage()
    }
    
}

protocol MediaCollectionThumbnailDelegate: AnyObject {
    func didTouchMedia(media: Media)
}
