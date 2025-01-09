//
//  SaveArticle.swift
//  News
//
//  Created by Andreas Langedal on 26/11/2024.
//
import Foundation
import SwiftData

// A function to save an article to the database
// - Parameters:
//   - article: The article to save
//   - context: The ModelContext for interacting with the database
// - Returns: A message indicating success or failure
func saveArticle(_ article: Article, context: ModelContext) -> String {
  // Mark the article as a favorite before saving
  article.isFavorite = true
  
  // Insert the article into the database context
  context.insert(article)
  do {
    // Save the changes to the database
    try context.save()
    print("Saved article: \(article.title)") // Log success
    return "Article saved successfully!" // Return a success message
  } catch {
    // Log and return an error message if saving fails
    print("Error saving article: \(error)")
    return "Failed to save article."
  }
}



