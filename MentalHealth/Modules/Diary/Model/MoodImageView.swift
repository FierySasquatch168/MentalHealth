//
//  MoodImageView.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 08.02.2023.
//

import UIKit

final class MoodImageView: UIView {
    static func create(icon: UIImage) -> MoodImageView {
        let imageView = MoodImageView()
        imageView.iconView.image = icon
        
        return imageView
    }
    
    private let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        addSubview(iconView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        iconView.contentMode = .scaleAspectFit
    }
}
