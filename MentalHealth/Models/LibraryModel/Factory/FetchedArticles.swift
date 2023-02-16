//
//  FetchedArticles.swift
//  MentalHealth
//
//  Created by Aleksandr Eliseev on 11.02.2023.
//

import Foundation

struct APIResponse: Decodable, Hashable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Decodable, Hashable, Identifiable {
    let id = UUID()
    let title: String?
    let url: String?
    let urlToImage: String?
}

struct HeadersForSections: Hashable {
    let inspirationSection: String = "Inspiration"
    let popularSection: String = "Popular"
    let newSection: String = "New"
}
