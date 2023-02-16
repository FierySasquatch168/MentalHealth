//
//  BottomActionButton.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class BottomActionButton: UIButton {
    
    init(color: UIColor, title: String) {
        super.init(frame: .zero)
        
        backgroundColor = color
        setTitle(title, for: .normal)
        layer.cornerRadius = 14
        titleLabel?.font = UIFont(name: CustomFont.kyivTypeSansRegular.rawValue, size: 20)
        setTitleColor(.white, for: .normal)
        titleLabel?.textAlignment = .center
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
