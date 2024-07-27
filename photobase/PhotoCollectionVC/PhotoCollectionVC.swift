//
//  PhotoCollectionVC.swift
//  photobase
//
//  Created by Leandro on 26/07/2024.
//

import UIKit

class PhotoCollectionVC: UIViewController {

    let viewModel = PhotoCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel.fetchAll()
            guard let photos = viewModel.photos else { return }
            debugPrint(photos)
        }
    }


}
