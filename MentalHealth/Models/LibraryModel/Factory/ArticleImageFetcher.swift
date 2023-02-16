//
//  ArticleImageFetcher.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import UIKit

struct ArticleImageFetcher {
    static let shared = ArticleImageFetcher()
    func getImageDataFrom(stringURL: String?) -> UIImage? {
        var image = UIImage()
        guard let stringURL = stringURL,
              let url = URL(string: stringURL)
        else {
            return UIImage(named: "noImageAvailable")!
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DataTask error: \(error)")
                return
            }
            
            guard let data = data else {
                // Handle empty data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let fetchedImage = UIImage(data: data) {
                    image = fetchedImage
                } else {
                    image = UIImage(named: "noImageAvailable")!
                }
            }
        }
        task.resume()
        return image
    }
}
