//
//  MainTabBarController.swift
//  ShowPass
//
//  Created by Lakshay Garg on 06/06/25.
//  Email: lakshay.511garg@gmail.com
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let searchNav = UINavigationController(rootViewController: searchVC)
        
        let bookmarksVC = BookmarksViewController()
        bookmarksVC.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), selectedImage: UIImage(systemName: "bookmark.fill"))
        let bookmarksNav = UINavigationController(rootViewController: bookmarksVC)
        
        viewControllers = [homeNav, searchNav, bookmarksNav]
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }
} 