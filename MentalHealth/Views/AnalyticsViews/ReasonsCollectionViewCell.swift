//
//  ReasonsCollectionViewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 16.02.2023.
//

import UIKit

class ReasonsCollectionViewCell: UICollectionViewCell {
    private lazy var reasonButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customButtonPurple
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureReasonsButton(item: String) {
        reasonButton.setTitle(item, for: .normal)
        reasonButton.titleLabel?.textAlignment = .center
        reasonButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .light)
        reasonButton.layer.cornerRadius = 17
        reasonButton.layer.masksToBounds = true

    }
    
    private func setupButton() {
        addSubview(reasonButton)
        reasonButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reasonButton.heightAnchor.constraint(equalToConstant: 34),
            reasonButton.widthAnchor.constraint(equalToConstant: 104),
            reasonButton.topAnchor.constraint(equalTo: topAnchor),
            reasonButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
