//
//  NewsApi.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//

import Foundation
import SwiftUI


// Response model for decoding the API response
struct NewsResponse: Decodable
{
  let articles: [NewsArticle]
}

// Model representing an article fetched from the API
struct NewsArticle: Decodable
{
  let title: String
  let author: String?
  let news_description: String?
  let content: String?
  let url: String
  let urlToImage: String?
}

// Extension to convert `NewsArticle` to the local `Article` model
extension NewsArticle
{
  // Converts `NewsArticle` to the local `Article` model
  func toArticle() -> Article
  {
    return Article(
      title: self.title,
      author: self.author,
      news_description: self.news_description ?? "",
      content: self.content ?? "",
      url: self.url,
      imageUrl: self.urlToImage
    )
  }
}

// Utility function for making API requests and decoding the response
// - Parameters:
//   - url: The URL for the API request
//   - type: The expected `Decodable` type of the response
// - Returns: The decoded response of the specified type
// - Throws: Errors related to network or decoding issues
func fetchData<T: Decodable>(from url: URL, decodeTo type: T.Type) async throws -> T
{
  let (data, _) = try await URLSession.shared.data(from: url)
  return try JSONDecoder().decode(T.self, from: data)
}

// A service for fetching news articles using the NewsAPI
struct NewsAPI
{
  static let baseUrl = "https://newsapi.org/v2/"
  @AppStorage("apiKey") private var apiKey: String = "" // Stored API key
  
  // Performs an API request using the given endpoint
  // - Parameter endpoint: The specific API endpoint to call
  // - Returns: An array of `NewsArticle` objects
  private func performRequest(_ endpoint: String) async throws -> [NewsArticle]
  {
    // Ensure API key is available
    guard !apiKey.isEmpty else
    {
      throw URLError(.userAuthenticationRequired, userInfo: [NSLocalizedDescriptionKey: "API key is missing."])
    }
    
    // Build the full API URL
    guard let url = URL(string: "\(NewsAPI.baseUrl)\(endpoint)&apiKey=\(apiKey)") else
    {
      throw URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL."])
    }
    
    // Use the shared `fetchData` utility to decode the response
    return try await fetchData(from: url, decodeTo: NewsResponse.self).articles
  }
  
  // Fetches news articles for a given keyword and optional language
  func fetchNews(for keyword: String, language: String = "all") async throws -> [Article]
  {
    // Build the API endpoint
    var endpoint = "everything?q=\(keyword)&pageSize=100"
    if language != "all"
    {
      endpoint += "&language=\(language)"
    }
    
    print("Fetching news for keyword: \(keyword), language: \(language)")
    
    // Fetch and map articles
    let newsArticles = try await performRequest(endpoint)
    return newsArticles
      .filter { $0.title != "[Removed]" } // Exclude invalid articles
      .map { $0.toArticle() } // Convert to local `Article` model
  }
  
  // Fetches top headlines for a specific country and optional category
  func fetchTopHeadlines(country: String = "us", category: String? = nil) async throws -> [Article]
  {
    // Build the API endpoint
    var endpoint = "top-headlines?country=\(country)&pageSize=10"
    if let category = category, !category.isEmpty
    {
      endpoint += "&category=\(category)"
    }
    
    print("Fetching top headlines for country: \(country), category: \(category ?? "None")")
    
    // Fetch and map articles
    let newsArticles = try await performRequest(endpoint)
    return newsArticles
      .filter { $0.title != "[Removed]" } // Exclude invalid articles
      .prefix(4) // Limit to the top 4 articles
      .map { $0.toArticle() } // Convert to local `Article` model
  }
}



