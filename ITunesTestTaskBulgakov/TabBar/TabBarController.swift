//
//  ViewController.swift
//  ITunesTestTaskBulgakov
//
//  Created by Dima on 21.11.2023.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    // MARK: - Methods
    private func setupControllers() {
        let mainVC = createControllers(inputVC: MainViewController(),
                                       image: UIImage(systemName: "house") ?? UIImage(),
                                       selectedImage: UIImage(systemName: "house.fill") ?? UIImage(),
                                       title: "Main")
        
        let favoriteVC = createControllers(inputVC: FavoriteViewController(),
                                           image: UIImage(systemName: "star") ?? UIImage(),
                                           selectedImage: UIImage(systemName: "star.fill") ?? UIImage(),
                                           title: "Favorite")
        
        let profileVC = createControllers(inputVC: ProfileViewController(),
                                          image: UIImage(systemName: "person") ?? UIImage(),
                                          selectedImage: UIImage(systemName: "person.fill") ?? UIImage(),
                                          title: "Profile")
        
        viewControllers = [mainVC, favoriteVC, profileVC]
    }
    
    private func createControllers(inputVC: UIViewController, image: UIImage, selectedImage: UIImage, title: String) -> UIViewController {
        let iconVC = UINavigationController(rootViewController: inputVC)
        iconVC.tabBarItem.image = image
        iconVC.tabBarItem.selectedImage = selectedImage
        iconVC.tabBarItem.title = title
        tabBar.tintColor = .gray
        tabBar.unselectedItemTintColor = .gray
        return iconVC
    }
}
