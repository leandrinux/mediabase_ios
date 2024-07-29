//
//  PhotoCollectionVC.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit

class PhotoCollectionVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?

    let viewModel = PhotoCollectionViewModel()
    
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

}

extension PhotoCollectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! PhotoCollectionThumbnailCell
        guard let media = viewModel.media?[indexPath.row] else {
            return cell
        }
        cell.delegate = self
        cell.media = media
        return cell
    }
    
}

extension PhotoCollectionVC: UICollectionViewDelegate {
    
}

extension PhotoCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = collectionView.frame.size.width / 2
        return CGSize(width: sideLength, height: sideLength)
    }
    
}

extension PhotoCollectionVC: PhotoCollectionThumbnailDelegate {
    
    func didTouchMedia(media: Media) {
        guard let photoVC = PhotoVC.create() else { return }
        photoVC.media = media
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
}
