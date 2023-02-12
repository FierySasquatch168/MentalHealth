//
//  LibraryCustomNewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class LibraryCustomNewCell: UICollectionViewCell {
    
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
    
    // Setup articles values
    func setCellWithValuesOf(_ article: Article) {
        updateUI(title: article.title, urlToImage: article.urlToImage)
    }
    
    private func updateUI(title: String?, urlToImage: String?) {
        
        self.backgroundColor = .clear
        self.articleTitleLabel.text = title
        
        guard let urlToImage = urlToImage, let url = URL(string: urlToImage) else {
            self.articleImageView.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we download the image we clear out the old one
        self.articleImageView.image = nil
        
        getImageDataFrom(url: url)
        
    }
    
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.articleImageView.image = image
                }
            }
        }.resume()
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
            articleImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            articleImageView.heightAnchor.constraint(equalToConstant: 147),
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
    
    func configureArticleTitleLabel() {
        addSubview(articleTitleLabel)
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        articleTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        articleTitleLabel.numberOfLines = 2
        articleTitleLabel.backgroundColor = .white
        articleTitleLabel.textAlignment = .center
        articleTitleLabel.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor),
            articleTitleLabel.leadingAnchor.constraint(equalTo: articleImageView.leadingAnchor),
            articleTitleLabel.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor)
        ])
    }
    
}
