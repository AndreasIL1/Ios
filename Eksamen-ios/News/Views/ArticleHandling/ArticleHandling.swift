//
//  ArticleHandling.swift
//  News
//
//  Created by Andreas Langedal on 26/11/2024.
//

import Foundation
import SwiftData

// Function to restore an archived article
// - Parameters:
//   - article: The article to restore
//   - context: The ModelContext for interacting with the database
func restoreArticle(_ article: Article, context: ModelContext)
{
  // Mark the article as not archived
  article.isArchived = false
  do
  {
    // Save the changes to the database
    try context.save()
    print("Article restored successfully.") // Log success
  }
  catch
  {
    // Log an error if the restore operation fails
    print("Error restoring article: \(error.localizedDescription)")
  }
}

// Function to delete an article from the database
// - Parameters:
//   - article: The article to delete
//   - context: The ModelContext for interacting with the database
func deleteArticle(_ article: Article, context: ModelContext)
{
  // Remove the article from the database context
  context.delete(article)
  do
  {
    // Save the changes to the database
    try context.save()
    print("Article deleted successfully.") // Log success
  }
  catch
  {
    // Log an error if the delete operation fails
    print("Error deleting article: \(error.localizedDescription)")
  }
}
