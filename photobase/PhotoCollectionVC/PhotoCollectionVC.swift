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
        Task {
            await viewModel.fetchAll()
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }

    func updateCollectionView() {
        collectionView?.reloadData()
    }

}

extension PhotoCollectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! PhotoCollectionThumbnailCell
        guard let photo = viewModel.photos?[indexPath.row] else {
            return cell
        }
        cell.photo = photo
        return cell
    }
    
}
