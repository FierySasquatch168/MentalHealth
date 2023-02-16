//
//  TabItem.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 14.02.2023.
//

import UIKit

enum TabItem: String {
    case diary = "Diary"
    case analytics = "Analytics"
    case library = "Library"
    case profile = "Profile"
    
    var viewController: UIViewController {
        switch self {
        case .diary:
            return DiaryViewController()
        case .analytics:
            return AnalyticsViewController()
        case .library:
            return LibraryViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .diary:
            return UIImage(named: "Menu")
        case .analytics:
            return UIImage(named: "Bar Chart")
        case .library:
            return UIImage(named: "Reading")
        case .profile:
            return UIImage(named: "Confusion")
        }
    }
    
    var title: String {
        return self.rawValue
    }
}
