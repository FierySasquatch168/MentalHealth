//
//  LibraryCustomInspirationCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class LibraryCustomInspirationCell: UICollectionViewCell {
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupArticleImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupArticleImageView() {
        contentView.addSubview(articleImageView)
        articleImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: topAnchor),
            articleImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
