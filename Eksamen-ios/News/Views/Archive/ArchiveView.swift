//
//  TrashView.swift
//  News
//
//  Created by Andreas Langedal on 26/11/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct ArchiveView: View
{
  @Environment(\.dismiss) private var dismiss // Environment property to dismiss the view
  @Environment(\.modelContext) private var context // Access the database context
  @Query(filter: #Predicate<Article> { $0.isArchived }) private var ArchivedArticles: [Article] // Fetch archived articles
  
  @State private var showToast = false // Controls the visibility of the toast notification
  @State private var toastMessage = "" // Message to be displayed in the toast
  @State private var toastColor: Color = .green // Background color of the toast
  @AppStorage("isDarkMode") private var isDarkMode = false // Store dark mode preference
  
  var body: some View
  {
    NavigationStack
    {
      VStack
      {
        // Show placeholder if there are no archived articles
        if ArchivedArticles.isEmpty
        {
          PlaceholderView("Archive is empty.", "You can swipe articles to the archive in the articles view.")
        }
        else
        {
          // Display a list of archived articles
          List {
            ForEach(ArchivedArticles)
            { article in
              VStack(alignment: .leading)
              {
                Text(article.title)
                  .font(.headline)
                Text(article.author ?? "Unknown Author")
                  .font(.subheadline)
                  .foregroundColor(.secondary)
              }
              .swipeActions
              {
                // Restore button to unarchive the article
                Button("Restore")
                {
                  handleRestore(article)
                }
                .tint(.green)
                
                // Delete button to permanently delete the article
                Button("Delete")
                {
                  handleDelete(article)
                }
                .tint(.red)
              }
            }
          }
        }
      }
      .toolbar
      {
        ToolbarItem(placement: .navigationBarLeading)
        {
          Button(action:
                  {
            dismiss()
          })
          {
            HStack
            {
              Image(systemName: "chevron.backward")
              Text("Back")
            }
          }
        }
      }
      .toast(message: toastMessage, color: toastColor, isShowing: $showToast)
    }
    .environment(\.colorScheme, isDarkMode ? .dark : .light)
  }
  
  // Handle restoring an archived article (unarchive it)
  private func handleRestore(_ article: Article)
  {
    article.isArchived = false
    do
    {
      try context.save()
      showToastMessage("Article restored successfully!", color: .green)
    }
    catch
    {
      showToastMessage("Failed to restore article: \(error.localizedDescription)", color: .red)
    }
  }
  
  // Handle deleting an article permanently
  private func handleDelete(_ article: Article)
  {
    context.delete(article)
    do
    {
      try context.save()
      showToastMessage("Article deleted successfully!", color: .green)
    }
    catch
    {
      showToastMessage("Failed to delete article: \(error.localizedDescription)", color: .red)
    }
  }
  
  // Show a toast message with a custom message and color
  private func showToastMessage(_ message: String, color: Color)
  {
    toastMessage = message
    toastColor = color
    showToast = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
    {
      showToast = false
    }
  }
}

#Preview
{
  ArchiveView()
}


