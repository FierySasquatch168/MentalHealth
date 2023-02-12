//
//  LibraryCustomNewCell.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

class LibraryCustomNewCell: UICollectionViewCell {
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.InterLight.rawValue, size: 10)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        
        stackView.addArrangedSubview(articleImageView)
        stackView.addArrangedSubview(articleTitleLabel)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       configureStackView()
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
    
    func configureStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27)
        ])
    }
    
}
