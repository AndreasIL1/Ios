//
//  SearchSheet.swift
//  News
//
//  Created by Andreas Langedal on 25/11/2024.
//


import SwiftUI
import SwiftData

struct SearchSheet: View
{
  @Binding var isPresented: Bool // Binding to control the visibility of the sheet
  @Binding var keyword: String // Binding to hold the current search keyword
  @Binding var selectedLanguage: String // Binding to hold the selected language
  let performSearch: () -> Void // Closure to trigger the search functionality
  
  @Environment(\.modelContext) private var context // Environment property to access the model context
  @State private var searchHistory: [Search] = [] // State variable to hold the search history
  
  @AppStorage("isDarkMode") private var isDarkMode = false // Track dark mode setting using AppStorage
  
  let languages: [String] = ["all", "en", "es", "fr", "de", "it", "no"] // List of available languages
  
  var body: some View
  {
    NavigationStack
    {
      VStack(spacing: 20)
      {
        // Title for the search options
        Text("Search Options")
          .font(.headline)
          .padding(.top)
        
        // Input fields for search keyword and language
        VStack(spacing: 16)
        {
          // Keyword input
          HStack
          {
            Text("Keyword")
              .font(.subheadline)
              .foregroundColor(.secondary)
            Spacer()
          }
          TextField("Enter a keyword", text: $keyword)
            .textFieldStyle(RoundedBorderTextFieldStyle())
          
          // Language picker
          HStack
          {
            Text("Language")
              .font(.subheadline)
              .foregroundColor(.secondary)
            Spacer()
          }
          Picker("Language", selection: $selectedLanguage)
          {
            ForEach(languages, id: \.self)
            {
              Text($0.uppercased()).tag($0)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.horizontal)
        
        // Search button
        Button(action:
                {
          isPresented = false 
          performSearch()
        })
        {
          Text("Search")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.horizontal)
        
        Divider()
        
        // Display the search history if available
        if !searchHistory.isEmpty
        {
          Text("Search History")
            .font(.headline)
            .padding(.top)
          
          // List of previous searches
          List
          {
            ForEach(searchHistory, id: \.id)
            { search in
              Button(action:
                      {
                keyword = search.keyword
                selectedLanguage = "all"
                isPresented = false
                performSearch()
              })
              {
                VStack(alignment: .leading)
                {
                  Text(search.keyword)
                    .foregroundColor(.primary)
                  Text(search.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
              }
            }
            .onDelete(perform: deleteSearch) // Allow deleting individual searches
          }
          .frame(maxHeight: 200)
          
          // "Delete All" button to clear all search history
          Button(action: deleteAllSearchHistory)
          {
            Text("Delete All")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.red)
              .foregroundColor(.white)
              .cornerRadius(10)
          }
          .padding(.horizontal)
        }
        
        Spacer()
      }
      .navigationBarTitle("Search Options", displayMode: .inline)
      .onAppear(perform: fetchSearchHistory)
    }
    .environment(\.colorScheme, isDarkMode ? .dark : .light)
  }
  
  // Fetch search history from the database
  private func fetchSearchHistory()
  {
    do
    {
      searchHistory = try context.fetch(FetchDescriptor<Search>())
        .sorted(by: { $0.createdAt > $1.createdAt }) // Sort by most recent
    }
    catch
    {
      print("Failed to fetch search history: \(error.localizedDescription)")
    }
  }
  
  // Delete specific searches from the history
  private func deleteSearch(at offsets: IndexSet)
  {
    for index in offsets
    {
      let search = searchHistory[index]
      context.delete(search)
    }
    do
    {
      try context.save()
      searchHistory.remove(atOffsets: offsets)
    }
    catch
    {
      print("Failed to delete search: \(error.localizedDescription)")
    }
  }
  
  // Delete all searches from the history
  private func deleteAllSearchHistory()
  {
    for search in searchHistory
    {
      context.delete(search)
    }
    do
    {
      try context.save()
      searchHistory.removeAll()
    }
    catch
    {
      print("Failed to delete all search history: \(error.localizedDescription)")
    }
  }
}








