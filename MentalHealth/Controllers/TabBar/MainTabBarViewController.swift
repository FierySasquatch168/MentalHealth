//
//  MainTabBarViewController.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private var items: [TabItem] = [.diary, .analytics, .library, .profile]
    
    private lazy var selectionImage: UIImage = {
        let image = UIImage(named: "SelectedTab")!
        image.withRenderingMode(.alwaysOriginal)
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        viewControllers = setupViewControllers(with: items)
        setupTabBarAppearance()
    }

    private func setupViewControllers(with items: [TabItem]) -> [UIViewController] {
        var customViewControllers: [UIViewController] = []
        for i in 0..<items.count {
            let viewController = createViewControllers(with: items[i])
            customViewControllers.append(viewController)
        }
        return customViewControllers
    }
    
    private func createViewControllers(with item: TabItem) -> UIViewController {
        let rootViewController = item.viewController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = item.title
        navigationController.tabBarItem.image = item.tabImage
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = item.title
        
        let attrs = [NSAttributedString.Key.font : UIFont(name: CustomFont.kyivTypeSansRegular2.rawValue, size: 40)!]
        navigationController.navigationBar.largeTitleTextAttributes = attrs
        
        return navigationController
    }
    
    private func setupTabBarAppearance() {
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().selectionIndicatorImage = selectionImage
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().backgroundColor = .customDeepBlue
    }
}
