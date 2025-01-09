//
//  NewsApp.swift
//  News
//
//  Created by Andreas Langedal on 19/11/2024.
//

import SwiftUI
import SwiftData

@main
struct NewsApp: App
{
  @State private var isSplash = true
  
  var body: some Scene
  {
    WindowGroup
    {
      if isSplash
      {
        // Show the splash screen
        SplashView(splash: $isSplash)
      }
      else
      {
        // Show the main app content (MainView) after the splash screen is dismissed
        MainView()
      }
    }
    // Model container for the Core Data entities (Article, Country, Category, Search)
    .modelContainer(for: [Article.self, Country.self, Category.self, Search.self])
  }
}
