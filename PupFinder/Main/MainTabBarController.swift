//
//  MainTabBarController.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listNavController = UINavigationController(rootViewController: BreedsListViewController(nibName: "BreedsListViewController", bundle: nil))
        
        listNavController.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        viewControllers = [listNavController]
    }
}
