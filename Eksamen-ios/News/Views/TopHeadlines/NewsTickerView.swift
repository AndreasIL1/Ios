//
//  NewsTickerView.swift
//  News
//
//  Created by Andreas Langedal on 04/12/2024.
//

import Foundation
import SwiftUI

struct NewsTickerView: View
{
  @State private var headlines: [String] = [] // List of headlines to display
  @State private var offset: CGFloat = 0 // Controls the horizontal scrolling offset
  @State private var tickerTimer: Timer? // Timer for automatic scrolling
  
  let country: String // The selected country for filtering headlines
  let category: String // The selected category for filtering headlines
  let onHeadlineTap: (String) -> Void // Callback function triggered when a headline is tapped
  let newsAPI = NewsAPI() // Instance of NewsAPI for fetching top headlines
  
  var body: some View
  {
    GeometryReader { geometry in
      ZStack
      {
        // Background for the ticker
        Color.gray.opacity(0.2)
          .cornerRadius(10)
          .frame(height: 50)
        
        HStack(spacing: 20)
        {
          // Display each headline
          ForEach(headlines.indices, id: \.self)
          { index in
            Text(headlines[index])
              .font(.headline)
              .foregroundColor(.white)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background(Color.blue.cornerRadius(10))
              .frame(minWidth: 200)
              .onTapGesture
            {
              onHeadlineTap(headlines[index])
            }
          }
          ForEach(headlines.indices, id: \.self)
          { index in
            Text(headlines[index])
              .font(.headline)
              .foregroundColor(.white)
              .padding(.horizontal, 16)
              .padding(.vertical, 8)
              .background(Color.blue.cornerRadius(10))
              .frame(minWidth: 200)
              .onTapGesture
            {
              onHeadlineTap(headlines[index])
            }
          }
        }
        .offset(x: offset)
        .onAppear
        {
          loadHeadlines() // Load headlines when the view appears
          startTicker(withWidth: geometry.size.width) // Start the scrolling ticker
        }
        .onChange(of: country)
        {
          loadHeadlines() // Reload headlines when the selected country changes
        }
        .onChange(of: category)
        {
          loadHeadlines() // Reload headlines when the selected category changes
        }
      }
    }
    .frame(height: 50)
  }
  
  // Fetches top headlines based on the selected country and category
  func loadHeadlines()
  {
    Task
    {
      do
      {
        // Fetch top headlines from the API
        let articles = try await newsAPI.fetchTopHeadlines(
          country: country,
          category: category
        )
        headlines = articles.map { $0.title } // Extract titles from articles
      } catch {
        print("Error fetching headlines: \(error.localizedDescription)") // Log errors
      }
    }
  }
  
  // Starts the automatic scrolling ticker
  // - Parameter width: The width of the ticker container
  func startTicker(withWidth width: CGFloat)
  {
    tickerTimer?.invalidate()
    tickerTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true)
    { _ in
      offset -= 1
      let headlineWidth = 220.0
      if offset <= -headlineWidth * CGFloat(headlines.count)
      {
        offset += headlineWidth * CGFloat(headlines.count) // Reset to the start for seamless scrolling
      }
    }
  }
}

