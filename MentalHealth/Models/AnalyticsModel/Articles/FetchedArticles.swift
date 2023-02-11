//
//  FetchedArticles.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import Foundation

struct APIResponse: Decodable, Hashable {
    let articles: [Article]
}

struct Article: Decodable, Hashable {
    var id = UUID()
    let title: String?
    let url: String?
    let urlToImage: String?
}

struct HeadersForSections: Hashable {
    let inspirationSection: String = "Inspiration"
    let popularSection: String = "Popular"
    let newSection: String = "New"
}
