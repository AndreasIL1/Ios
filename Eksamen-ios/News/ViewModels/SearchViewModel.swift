//
//  SearchViewModel.swift
//  News
//
//  Created by Andreas Langedal on 04/12/2024.
//

import Foundation
import SwiftData

@MainActor
// ViewModel for managing search functionality, fetching articles, and storing search history
class SearchViewModel: ObservableObject
{
  // Published properties trigger UI updates when they change
  @Published var articles: [Article] = [] // Holds the fetched articles
  @Published var searchError: String? = nil // Holds any error message from search
  @Published var isSearching: Bool = false // Indicates whether the search is in progress
  
  private let newsAPI = NewsAPI() // API instance to fetch news articles
  
  // Perform a search based on the keyword and language
  // - Parameters:
  //   - keyword: The search keyword to filter articles
  //   - language: The language of the articles (default: "all")
  //   - context: The ModelContext for interacting with the database
  func performSearch(keyword: String, language: String, context: ModelContext) async
  {
    // If no keyword is provided, do not perform the search
    guard !keyword.isEmpty else { return }
    
    isSearching = true // Set searching state to true
    searchError = nil // Reset any previous error message
    articles = [] // Clear previously fetched articles
    
    do
    {
      // Save the search keyword to the database
      saveSearchKeyword(keyword, context: context)
      
      // Fetch articles using the API
      let fetchedArticles = try await newsAPI.fetchNews(for: keyword, language: language)
      if fetchedArticles.isEmpty
      {
        // If no articles are found, set an error message
        searchError = "No articles found for the given keyword and language."
      }
      else
      {
        // If articles are found, assign them to the articles property
        articles = fetchedArticles
      }
    }
    catch
    {
      // If an error occurs during the fetch, store the error message
      searchError = "An error occurred: \(error.localizedDescription)"
    }
    
    // Set searching state to false when the search is complete
    isSearching = false
  }
  
  // Save the search keyword into the database
  // - Parameters:
  //   - keyword: The search keyword to save
  //   - context: The ModelContext for interacting with the database
  private func saveSearchKeyword(_ keyword: String, context: ModelContext)
  {
    // Create a new Search object with the keyword
    let search = Search(keyword: keyword)
    do
    {
      // Insert the search keyword into the context
      context.insert(search)
      try context.save() // Save the changes to the database
    }
    catch
    {
      // Handle any errors when saving the search keyword
      print("Failed to save search keyword: \(error.localizedDescription)")
    }
  }
}



