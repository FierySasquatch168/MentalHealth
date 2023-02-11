//
//  LibraryCustomHeaderForCellReusableView.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class LibraryCustomHeaderForCellReusableView: UICollectionReusableView {
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.kyivTypeSansBold2.rawValue, size: 20)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private func setupMainView() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15)
        ])
    }
    
}
