//
//  SearchView.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//

import Foundation
import SwiftUI

struct SearchView: View
{
  @Environment(\.modelContext) private var context // Access the model context from the environment
  @StateObject private var viewModel = SearchViewModel() // ViewModel to manage the search logic
  @State private var keyword: String = "" // State variable for the search keyword
  @State private var selectedLanguage: String = "all" // State variable for the selected language
  @State private var showSheet: Bool = false // State to control the visibility of the search sheet
  @State private var showToast = false // State to control the visibility of the toast message
  @State private var toastMessage = "" // The message displayed in the toast
  @State private var toastColor: Color = .red // The color of the toast message (e.g., red for errors)
  
  var body: some View
  {
    NavigationStack
    {
      VStack
      {
        // Button to open search options sheet
        Button("Search Options")
        {
          showSheet.toggle() // Toggle the sheet visibility
        }
        .buttonStyle(.borderedProminent) // Prominent button style
        .padding()
        
        // Show progress indicator while searching
        if viewModel.isSearching
        {
          ProgressView("Searching...") // Loading indicator with a message
            .padding()
        }
        // Display error message if there's an issue with the search
        else if let error = viewModel.searchError
        {
          Text(error)
            .foregroundColor(.red) // Error text in red
            .multilineTextAlignment(.center)
            .padding()
        }
        // Display a placeholder if no articles are found
        else if viewModel.articles.isEmpty
        {
          PlaceholderView("No results found.", "Try searching for a different keyword.")
        }
        // Display the list of articles if they are available
        else
        {
          List(viewModel.articles, id: \.id)
          { article in
            NavigationLink(destination: ArticleDetailView(article: article, isAlreadySaved: false))
            {
              HStack(spacing: 12)
              {
                // Display article image
                if let url = article.imageUrl, let imageURL = URL(string: url)
                {
                  AsyncImage(url: imageURL)
                  { phase in
                    if let image = phase.image
                    {
                      image.resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                    }
                    else
                    {
                      Color.gray
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    }
                  }
                }
                // Display article title and author
                VStack(alignment: .leading, spacing: 6)
                {
                  Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                  Text(article.author ?? "Unknown Author")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
              }
            }
          }
        }
      }
      .navigationTitle("Search News")
      
      // Display the search options sheet
      .sheet(isPresented: $showSheet)
      {
        SearchSheet(
          isPresented: $showSheet,
          keyword: $keyword,
          selectedLanguage: $selectedLanguage,
          performSearch:
            {
              Task
              {
                // Perform the search using the ViewModel
                await viewModel.performSearch(keyword: keyword, language: selectedLanguage, context: context)
                if viewModel.articles.isEmpty
                {
                  // Show a toast if no articles are found
                  showToastMessage("No articles found!", color: .red)
                }
              }
            }
        )
      }
      
      // Add a toast message to show feedback to the user
      .toast(message: toastMessage, color: toastColor, isShowing: $showToast)
    }
  }
  
  // Display a toast message with the given message and color
  private func showToastMessage(_ message: String, color: Color)
  {
    toastMessage = message
    toastColor = color
    showToast = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
    {
      showToast = false // Hide the toast after 2 seconds
    }
  }
}

