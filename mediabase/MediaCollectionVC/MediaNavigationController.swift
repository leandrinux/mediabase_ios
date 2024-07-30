//
//  MediaNavigationController.swift
//  mediabase
//
//  Created by Leandro on 29/07/2024.
//

import UIKit

class MediaNavigationController: UINavigationController {

    override func viewDidLoad() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().backgroundColor = .clear
    }
    
}
