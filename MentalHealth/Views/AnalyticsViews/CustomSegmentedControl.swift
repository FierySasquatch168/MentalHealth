//
//  CustomSegmentedControl.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 16.02.2023.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    lazy var radius = self.bounds.height / 2
    
    private var segmentInset: CGFloat = 0.1 {
        didSet {
            if segmentInset == 0 {
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.selectedSegmentTintColor = .customButtonPurple
        self.backgroundColor = .clear
        let selectedImageViewIndex = numberOfSegments
        
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selectedImageView.image = UIImage(named: "Rectangle 16")
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
        }
    }
}
