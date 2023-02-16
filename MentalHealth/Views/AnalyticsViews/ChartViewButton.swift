//
//  ChartViewButton.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 16.02.2023.
//

import UIKit

class ChartViewButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        
        let string = title
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: CustomFont.kyivTypeSansBold.rawValue, size: 20) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black as Any
        ]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        setAttributedTitle(attributedString, for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
