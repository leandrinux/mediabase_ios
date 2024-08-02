//
//  MediaCollectionVC.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit
import PhotosUI
import SnapKit
import SDWebImage

class MediaCollectionVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var emptyView: UIView?

    let viewModel = MediaCollectionViewModel()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SDImageCache.shared.config.maxDiskAge = 30
        SDImageCache.shared.deleteOldFiles()
        viewModel.delegate = self
        
        // Pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)

        // Empty view
        if let emptyView = emptyView {
            emptyView.isHidden = true
            view.addSubview(emptyView)
            emptyView.snp.makeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview().offset(100)
                maker.width.equalTo(300)
                maker.height.equalTo(300)
            }
        }
        
        // Load data into collection view
        collectionView?.delegate = self
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        viewModel.getAllMedia {
            DispatchQueue.main.async {
                self.emptyView?.isHidden = (self.viewModel.media?.count ?? 0) > 0
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
   
    @IBAction func doAddMedia() {
        var config = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.navigationController?.present(picker, animated: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       reloadCollectionView()
    }

}

extension MediaCollectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! MediaCollectionThumbnailCell
        guard let media = viewModel.media?[indexPath.row] else {
            return cell
        }
        cell.delegate = self
        cell.media = media
        return cell
    }
    
}

extension MediaCollectionVC: UICollectionViewDelegate {
    
}

extension MediaCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = (collectionView.frame.size.width - 2) / 3
        return CGSize(width: sideLength, height: sideLength)
    }
    
}

extension MediaCollectionVC: MediaCollectionThumbnailDelegate {
    
    func didTouchMedia(media: Media) {
        guard let vc = MediaVC.create(media) else { return }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MediaCollectionVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                guard
                    let image = object as? UIImage,
                    let imageData = image.jpegData(compressionQuality: 1)
                else { return }
                self.viewModel.uploadMedia(imageData) {
                    self.reloadCollectionView()
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
}

extension MediaCollectionVC: MediaCollectionViewModelDelegate {
    func reloadMedia() {
        reloadCollectionView()
    }
}

extension MediaCollectionVC: MediaVCDelegate {
    func mediaDismissedAfterDelete() {
        reloadCollectionView()
    }
}
