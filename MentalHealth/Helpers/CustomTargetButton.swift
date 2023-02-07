//
//  CustomTargetButton.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 07.02.2023.
//

import UIKit

class CustomTargetButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, title: String, systemImageName: String) {
        super.init(frame: .zero)
        
       
    }
    
    func configure() {
        layer.cornerRadius = 14
        titleLabel?.font = UIFont(name: "KyivTypeSans-VarGX", size: 20)
        setTitleColor(.white, for: .normal)
    }

}
