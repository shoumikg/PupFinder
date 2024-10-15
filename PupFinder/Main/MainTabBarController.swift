//
//  MainTabBarController.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listNavController = UINavigationController(rootViewController: BreedsListViewController(nibName: "BreedsListViewController", bundle: nil))
        let feedNavController = UINavigationController(rootViewController: FeedViewController())
        
        listNavController.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 0)
        feedNavController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet.below.rectangle"), tag: 1)
        
        viewControllers = [listNavController, feedNavController]
    }
}
