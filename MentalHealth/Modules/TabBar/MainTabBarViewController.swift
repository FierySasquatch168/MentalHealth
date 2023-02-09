//
//  MainTabBarViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .customCVBackground
        UITabBar.appearance().backgroundColor = .customDeepBlue
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().isHidden = false
        
        setupVC()
    }

    
    func setupVC() {
        viewControllers = [
            createNavController(for: DiaryViewController(), title: NSLocalizedString("Diary", comment: ""), tabbarTitle: "Menu", image: UIImage(named: "Menu")!),
            createNavController(for: AnalyticsViewController(), tabbarTitle: NSLocalizedString("Analytics", comment: ""), image: UIImage(named: "Bar Chart")!),
            createNavController(for: LibraryViewController(), tabbarTitle: NSLocalizedString("Library", comment: ""), image: UIImage(named: "Reading")!),
            createNavController(for: ProfileViewController(), tabbarTitle: NSLocalizedString("Profile", comment: ""), image: UIImage(named: "Confusion")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String? = nil,
                                         tabbarTitle: String,
                                         image: UIImage) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootViewController)
        navVC.tabBarItem.title = tabbarTitle
        navVC.tabBarItem.image = image
        navVC.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        
        let attrs = [NSAttributedString.Key.font : UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 40)!]
        navVC.navigationBar.largeTitleTextAttributes = attrs
        
        return navVC
    }

}
