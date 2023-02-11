//
//  ArticleFactory.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import Foundation

class ArticleFactory: ArticleFactoryProtocol {
    
    weak var delegate: ArticleFactoryDelegate?
    private var articlesLoader: ArticlesLoading
    
    private var articles: [Article] = []
    
    init(delegate: ArticleFactoryDelegate, articlesLoader: ArticlesLoading) {
        self.delegate = delegate
        self.articlesLoader = articlesLoader
    }
    
    private var dateNow: String = {
        let dayNow = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        let day = dayFormatter.string(from: dayNow)
        return day
    }()
    
    // MARK: rewrite according to documentation
    
    private var stringURLPrimary = "https://newsapi.org/v2/everything?q=psychology&from=2022-12-20&to=2022-12-20&sortBy=popularity&apiKey=0fba902da82a49ba8b86aed88de33146"
    private var theme = "psychology"
    
    // MARK: URL
    private var articlesURL: URL {
        let stringURL = "https://newsapi.org/v2/everything?q=" + "\(theme)" + "&from=" + "\(dateNow)" + "&to=" + "\(dateNow)" + "&sortBy=popularity&apiKey=0fba902da82a49ba8b86aed88de33146"
        guard let url = URL(string: stringURL) else {
            preconditionFailure("Unable to construct articlesURL")
        }
        return url
    }
    
    func loadData() {
        articlesLoader.loadArticles(url: articlesURL) { [weak self] (result: Result<[Article], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles
                var randomPopularArticles: [Article] = []
                var randomNewArticle: [Article] = []
                
                if !articles.isEmpty {
                    for _ in 0..<2 {
                        guard let randomArticle = articles.randomElement() else { return }
                        randomPopularArticles.append(randomArticle)
                        self.articles.makeUnique(from: &self.articles, getRidOf: randomPopularArticles)
                    }
                    guard let randomArticle = articles.randomElement() else { return }
                    randomNewArticle.append(randomArticle)
                    self.articles.makeUnique(from: &self.articles, getRidOf: randomNewArticle)
                }
                
                self.delegate?.didReceiveArticle(articles: self.articles, popularArticles: randomPopularArticles, newArticle: randomNewArticle)
            case .failure(let error):
                // MARK: take care of the error
                print(error)
            }
        }
    }
    
}
