//
//  ArticleFactoryDelegate.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import Foundation

protocol ArticleFactoryDelegate: AnyObject {
    func didReceiveArticle(articles: [Article], popularArticles: [Article], newArticle: [Article]) 
}
