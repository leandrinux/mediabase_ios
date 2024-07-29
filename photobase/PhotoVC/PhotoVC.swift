//
//  PhotoVC.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit
import SDWebImage

class PhotoVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?

    let viewModel = PhotoViewModel()
    
    var media: Media?
    
    override func viewDidLoad() {
        guard let media = media else { return }
        let url = URL(string: "\(Networking.baseURL)/file?id=\(media.ID)")
        imageView?.sd_setImage(with: url)
    }
    
    static func create() -> PhotoVC? {
        let storyboard = UIStoryboard(name: "PhotoVC", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as? PhotoVC
    }
    
}
