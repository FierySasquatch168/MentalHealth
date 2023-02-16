//
//  AnalyticsCustomHeaderForCV.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 16.02.2023.
//

import UIKit

class AnalyticsCustomHeaderForCV: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansBold2.rawValue, size: 20)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupMainView()
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        titleLabel.textAlignment = .center
    }
    
    private func setupMainView() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15)
        ])
        
    }
}
