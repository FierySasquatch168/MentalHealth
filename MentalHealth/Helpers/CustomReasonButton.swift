//
//  CustomTargetButton.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class CustomReasonButton: UIButton {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = color
        widthAnchor.constraint(equalToConstant: 68).isActive = true
        heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
