//
//  MediaVC.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit
import SDWebImage

class MediaVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView?

    let viewModel = MediaViewModel()
    
    var media: Media?
    
    override func viewDidLoad() {
        guard let media = media else { return }
        let url = URL(string: "\(Networking.baseURL)/file?id=\(media.ID)")
        imageView?.sd_setImage(with: url)
    }
    
    static func create() -> MediaVC? {
        let storyboard = UIStoryboard(name: "MediaVC", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as? MediaVC
    }
    
}
