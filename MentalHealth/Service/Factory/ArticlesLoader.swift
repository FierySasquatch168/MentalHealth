//
//  ArticlesLoader.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import Foundation

protocol ArticlesLoading {
    func loadArticles(url: URL, handler: @escaping (Result<[Article], Error>) -> Void)
}

struct ArticlesLoader: ArticlesLoading {
    
    func loadArticles(url: URL, handler: @escaping (Result<[Article], Error>) -> Void) {
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<APIResponse, Error>) in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let response):
                handler(.success(response.articles))
            }
        }
        task.resume()
    }
}
