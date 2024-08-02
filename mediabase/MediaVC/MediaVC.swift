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
    @IBOutlet weak var tagsCollectionView: UICollectionView?
    
    let viewModel = MediaViewModel()
    
    weak var delegate: MediaVCDelegate?

    var media: Media? {
        set { viewModel.media = newValue }
        get { return viewModel.media }
    }
       
    static func create(_ media: Media) -> MediaVC? {
        let storyboard = UIStoryboard(name: "MediaVC", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as? MediaVC
        vc?.media = media
        return vc
    }

    override func viewDidLoad() {
        viewModel.getMedia {
            self.tagsCollectionView?.dataSource = self
            self.tagsCollectionView?.reloadData()
        }
        guard let media = media else { return }
        let url = URL(string: "\(MediabaseAPI.baseURL)/file?id=\(media.id)")
        imageView?.sd_setImage(with: url)
    }
    
    @IBAction func deleteMedia() {
        Task {
            await self.viewModel.deleteMedia { success in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.mediaDismissedAfterDelete()
                }
            }
        }
    }
    
}

protocol MediaVCDelegate: AnyObject {
    func mediaDismissedAfterDelete()
}

extension MediaVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.media?.tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! MediaTagCollectionViewCell
        cell.tagName?.text = self.media?.tags?[indexPath.row] ?? ""
        return cell
    }
    
    
}
