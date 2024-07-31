//
//  MediaCollectionVC.swift
//  Mediabase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit
import PhotosUI

class MediaCollectionVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?

    let viewModel = MediaCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        Task {
            await viewModel.fetchAll()
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }

    func updateCollectionView() {
        print("Updating collection view")
        collectionView?.reloadData()
    }
    
    @IBAction func doAddMedia() {
        var config = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.navigationController?.present(picker, animated: true)
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
        guard let MediaVC = MediaVC.create() else { return }
        MediaVC.media = media
        navigationController?.pushViewController(MediaVC, animated: true)
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
                Task {
                    await self.viewModel.uploadMedia(imageData)
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
}
