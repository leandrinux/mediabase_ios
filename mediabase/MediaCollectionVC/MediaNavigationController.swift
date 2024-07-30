//
//  MediaNavigationController.swift
//  mediabase
//
//  Created by Leandro on 29/07/2024.
//

import UIKit

class MediaNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().shadowImage = UIImage()
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationBarAppearance.backgroundColor = UIColor.clear
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
/*
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.clear
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
*/
    }
    
}
