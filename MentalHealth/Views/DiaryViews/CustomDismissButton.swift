//
//  CustomDismissButton.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 28.02.2023.
//

import UIKit

class CustomDismissButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(systemName: "xmark")
        image?.withRenderingMode(.alwaysOriginal)
        setImage(image, for: .normal)
        widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
