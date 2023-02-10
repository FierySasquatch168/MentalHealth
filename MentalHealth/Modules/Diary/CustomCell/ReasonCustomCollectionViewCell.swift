//
//  ReasonCustomCollectionViewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 08.02.2023.
//

import UIKit

class ReasonCustomCollectionViewCell: UICollectionViewCell {
    
    var buttonIsSelected: Bool = false
    
    lazy var reasonButton: CustomReasonButton = {
        let button = CustomReasonButton(color: .customButtonPurple!)
        button.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
        return button
    }()
    
     lazy var buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: CustomFont.InterMedium.rawValue, size: 16)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellWithValuesOf(item: ReasonButtonModel) {
        self.backgroundColor = .clear
        reasonButton.setImage(UIImage(named: item.imageName), for: .normal)
        buttonTitleLabel.text = item.buttonTitle
        
    }
    
    @objc func selectButton() {
        buttonIsSelected.toggle()
        
        switch buttonIsSelected {
        case true:
            reasonButton.backgroundColor = .customPurple
            
        case false:
            reasonButton.backgroundColor = .customButtonPurple
            
        }
    }
    
    // MARK: UI configuration
    
    private func setupUI() {
        setupButton()
        setupButtonTitleLabel()
    }
    
    private func setupButton() {
        contentView.addSubview(reasonButton)
        reasonButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            reasonButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            reasonButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    private func setupButtonTitleLabel() {
        contentView.addSubview(buttonTitleLabel)
        buttonTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonTitleLabel.topAnchor.constraint(equalTo: reasonButton.bottomAnchor, constant: 5),
            buttonTitleLabel.leadingAnchor.constraint(equalTo: reasonButton.leadingAnchor),
            buttonTitleLabel.trailingAnchor.constraint(equalTo: reasonButton.trailingAnchor)
        ])
    }
}
