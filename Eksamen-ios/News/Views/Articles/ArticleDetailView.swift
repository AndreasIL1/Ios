//
//  ArticleDetailView.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct ArticleDetailView: View
{
  let article: Article // The article to display
  @Environment(\.modelContext) private var context // Access the database context
  @State private var showToast = false // Controls the visibility of toast notifications
  @State private var toastMessage = "" // Message to display in the toast
  @State private var toastColor: Color = .green // Background color of the toast
  let isAlreadySaved: Bool // Indicates whether the article is already saved as a favorite
  
  var body: some View
  {
    ScrollView
    {
      VStack(alignment: .leading)
      {
        // Display the article's image if available
        if let imageUrl = article.imageUrl, let url = URL(string: imageUrl)
        {
          AsyncImage(url: url)
          { phase in
            if let image = phase.image
            {
              image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            }
            else
            {
              // Placeholder for missing images
              Color.gray
                .frame(maxWidth: .infinity, maxHeight: 200)
            }
          }
        }
        
        // Article title
        Text(article.title)
          .font(.largeTitle) // Large font for emphasis
          .bold()
          .padding(.bottom, 8)
        
        // Article author or placeholder if unknown
        Text(article.author ?? "Unknown Author")
          .font(.subheadline)
          .foregroundColor(.secondary)
        
        // Article description
        Text(article.news_description)
          .font(.body)
          .padding(.top, 8)
        
        // Article content
        Text(article.content)
          .font(.body)
          .padding(.top, 8)
        
        // Link to read the full article
        if let url = URL(string: article.url)
        {
          Link("Read more", destination: url)
            .font(.headline)
            .padding(.top, 8)
        }
      }
      .padding()
    }
    .toolbar
    {
      // Display a save button if the article is not already saved
      if !isAlreadySaved
      {
        ToolbarItem(placement: .navigationBarTrailing)
        {
          Button("Save")
          {
            saveArticleWithFeedback(article)
          }
        }
      }
    }
    .toast(message: toastMessage, color: toastColor, isShowing: $showToast)
    .navigationTitle("Article Details")
  }
  
  // Save the article to the database with user feedback
  private func saveArticleWithFeedback(_ article: Article)
  {
    do
    {
      article.isFavorite = true
      context.insert(article)
      try context.save()
      showToastMessage("Article saved successfully!", color: .green)
    }
    catch
    {
      showToastMessage("Failed to save article: \(error.localizedDescription)", color: .red)
    }
  }
  
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

