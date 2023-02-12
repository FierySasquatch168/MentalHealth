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
        imageView.layer.cornerRadius = 36
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupArticleImageView()
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
