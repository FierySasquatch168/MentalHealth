//
//  LibraryCustomPopularCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class LibraryCustomPopularCell: UICollectionViewCell {
    
    var articleImageView = UIImageView()
    var articleTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureArticleImageView()
        configureArticleTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI configuration
    
    func configureArticleImageView() {
        addSubview(articleImageView)
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        articleImageView.backgroundColor = .secondarySystemBackground
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.layer.cornerRadius = 8
        articleImageView.layer.masksToBounds = true
        articleImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 147),
            articleImageView.widthAnchor.constraint(equalToConstant: 142)
        ])
    }
    
    func configureArticleTitleLabel() {
        addSubview(articleTitleLabel)
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        articleTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        articleTitleLabel.numberOfLines = 2
        articleTitleLabel.backgroundColor = .white
        articleTitleLabel.layer.cornerRadius = 16
        articleTitleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor),
            articleTitleLabel.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor),
            articleTitleLabel.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor)
        ])
    }
}
