//
//  ArticlesViewModel.swift
//  News
//
//  Created by Andreas Langedal on 04/12/2024.
//

import Foundation
import SwiftUI
import SwiftData

// A struct to wrap error messages for displaying in the UI
struct ErrorWrapper: Identifiable
{
  let id = UUID()
  let message: String
}

@MainActor
// ViewModel for managing the state and logic related to favorite articles
class ArticlesViewModel: ObservableObject
{
  // Published properties allow the view to react to changes
  @Published var favoriteArticles: [Article] = [] // List of favorite articles
  @Published var archiveError: ErrorWrapper? = nil // Error message for any archive-related operations
  
  private let context: ModelContext // Database context for fetching and saving data
  
  // Initializer to inject the model context
  init(context: ModelContext)
  {
    self.context = context
  }
  
  // Loads favorite articles that are not archived
  func loadFavoriteArticles()
  {
    do
    {
      // Fetch descriptor to retrieve articles that are marked as favorites and not archived
      let fetchDescriptor = FetchDescriptor<Article>(
        predicate: #Predicate { !$0.isArchived && $0.isFavorite }
      )
      favoriteArticles = try context.fetch(fetchDescriptor) // Fetch matching articles from the context
    }
    catch
    {
      // Handle error if the fetch fails and provide an error message
      archiveError = ErrorWrapper(message: "Failed to load articles: \(error.localizedDescription)")
    }
  }
  
  // Moves an article to trash (marks it as archived)
  func moveToTrash(_ article: Article)
  {
    article.isArchived = true // Mark the article as archived
    saveChanges() // Save the changes to the database
  }
  
  // Saves any changes made to the context
  private func saveChanges()
  {
    do
    {
      try context.save() // Attempt to save the changes
    } catch
    {
      // Handle error if saving changes fails and provide an error message
      archiveError = ErrorWrapper(message: "Failed to save changes: \(error.localizedDescription)")
    }
  }
}


