//
//  FeelingsCollectionViewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 16.02.2023.
//

import UIKit

class FeelingsCollectionViewCell: UICollectionViewCell {
    private lazy var feelingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFeelingsButton(item: String) {
        feelingButton.setTitle(item, for: .normal)
        feelingButton.setTitleColor(.black, for: .normal)
        feelingButton.titleLabel?.textAlignment = .center
        feelingButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        feelingButton.layer.cornerRadius = 17
        feelingButton.layer.borderWidth = 1
        feelingButton.layer.borderColor = UIColor.customButtonPurple?.cgColor
        feelingButton.layer.masksToBounds = true

    }
    
    private func setupButton() {
        addSubview(feelingButton)
        feelingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feelingButton.heightAnchor.constraint(equalToConstant: 34),
            feelingButton.widthAnchor.constraint(equalToConstant: 104),
            feelingButton.topAnchor.constraint(equalTo: topAnchor),
            feelingButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
