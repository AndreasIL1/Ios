//
//  MainView.swift
//  News
//

import SwiftUI

struct MainView: View
{
  @AppStorage("isDarkMode") private var darkMode = false // Tracks dark mode preference
  @AppStorage("isNewsTickerEnabled") private var isNewsTickerEnabled = false // Enables/disables the news ticker
  @AppStorage("selectedCountry") private var selectedCountry = "us" // Selected country for news filtering
  @AppStorage("selectedCategory") private var selectedCategory = "general" // Selected news category
  @State private var selectedHeadline: String = "" // Stores the headline currently selected in the ticker
  @Environment(\.modelContext) private var context // Accesses the ModelContext from the environment
  
  var body: some View
  {
    ZStack
    {
      NavigationStack
      {
        VStack(spacing: 0)
        {
          // Display the news ticker if enabled
          if isNewsTickerEnabled
          {
            NewsTickerView(
              country: selectedCountry,
              category: selectedCategory
            )
            { headline in
              // Handle headline tap
              withAnimation {
                selectedHeadline = headline // Show the tapped headline
              }
              
              // Hide the headline after 1 second
              DispatchQueue.main.asyncAfter(deadline: .now() + 1)
              {
                withAnimation
                {
                  selectedHeadline = ""
                }
              }
            }
          }
          
          // Tab view for navigating between major app sections
          TabView
          {
            // Tab for viewing articles
            ArticlesView(context: context)
              .tabItem
            {
              Label("Articles", systemImage: "doc.text")
            }
            
            // Tab for searching news
            SearchView()
              .tabItem
            {
              Label("Search", systemImage: "magnifyingglass")
            }
            
            // Tab for accessing settings
            SettingsView()
              .tabItem
            {
              Label("Settings", systemImage: "gearshape")
            }
          }
        }
        .environment(\.colorScheme, darkMode ? .dark : .light)
      }
      
      // Popup overlay to display the selected headline
      if !selectedHeadline.isEmpty
      {
        Color.black.opacity(0.4)
          .edgesIgnoringSafeArea(.all)
        
        Text(selectedHeadline)
          .font(.title)
          .bold()
          .foregroundColor(.white)
          .padding()
          .background(Color.blue.cornerRadius(10))
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      }
    }
  }
}

#Preview
{
  MainView()
}
