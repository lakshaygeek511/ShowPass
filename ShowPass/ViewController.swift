//
//  ViewController.swift
//  ShowPass
//
//  Created by Lakshay Garg on 06/06/25.
//  Email: lakshay.511garg@gmail.com
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureViewControllers()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemRed
        tabBar.backgroundColor = .systemBackground
    }
    
    private func configureViewControllers() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.tabBarItem.title = "Home"
        
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.tabBarItem.title = "Search"
        
        let bookmarksVC = UINavigationController(rootViewController: BookmarksViewController())
        bookmarksVC.tabBarItem.image = UIImage(systemName: "bookmark")
        bookmarksVC.tabBarItem.title = "Bookmarks"
        
        viewControllers = [homeVC, searchVC, bookmarksVC]
    }
}

