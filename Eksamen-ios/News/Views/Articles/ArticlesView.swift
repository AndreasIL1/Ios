//
//  ArticlesView.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct ArticlesView: View
{
  @StateObject private var viewModel: ArticlesViewModel // ViewModel for managing article data
  @Environment(\.modelContext) private var context // Access the database context
  
  @State private var showToast = false // Controls the visibility of toast notifications
  @State private var toastMessage = "" // Message to display in the toast
  @State private var toastColor: Color = .green // Background color of the toast
  
  // Custom initializer to pass the context into the ViewModel
  init(context: ModelContext)
  {
    _viewModel = StateObject(wrappedValue: ArticlesViewModel(context: context))
  }
  
  var body: some View
  {
    VStack
    {
      // Display a placeholder if there are no favorite articles
      if viewModel.favoriteArticles.isEmpty
      {
        PlaceholderView("No articles found.", "Go to search and save articles to see them here.")
      }
      else
      {
        // List of favorite articles
        List
        {
          ForEach(viewModel.favoriteArticles)
          { article in
            NavigationLink
            {
              ArticleDetailView(article: article, isAlreadySaved: true)
            }
          label:
            {
              Text(article.title)
            }
          }
          .onDelete
          { indexSet in
            handleDelete(at: indexSet)
          }
        }
      }
    }
    .navigationTitle("Saved Articles")
    .onAppear
    {
      viewModel.loadFavoriteArticles()
    }
    .toast(message: toastMessage, color: toastColor, isShowing: $showToast)
    .alert(item: $viewModel.archiveError)
    { errorWrapper in
      Alert(
        title: Text("Error"),
        message: Text(errorWrapper.message),
        dismissButton: .default(Text("OK"))
      )
    }
  }
  
  // Handle deletion of articles from the list
  private func handleDelete(at offsets: IndexSet)
  {
    offsets.forEach
    { index in
      let article = viewModel.favoriteArticles[index]
      viewModel.moveToTrash(article)
    }
    showToastMessage("Article moved to Trash", color: .green)
    viewModel.loadFavoriteArticles()
  }
  
  // Display a toast notification with a custom message and color
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

