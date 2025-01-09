//
//  SettingsView.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//
import Foundation
import SwiftUI
import SwiftData

struct SettingsView: View
{
  // AppStorage variables to persist user preferences
  @AppStorage("apiKey") private var apiKey = "" // API key for accessing the news service
  @AppStorage("isDarkMode") private var isDarkMode = false // Toggle for dark mode
  @AppStorage("selectedCountry") private var selectedCountry = "us" // Default country for news
  @AppStorage("selectedCategory") private var selectedCategory = "general" // Default news category
  @AppStorage("isNewsTickerEnabled") private var isNewsTickerEnabled = false // Toggle for enabling/disabling news ticker
  
  @Environment(\.modelContext) private var context // Environment property for accessing the model context
  @State private var userCountries: [String] = [] // User-defined countries
  @State private var userCategories: [String] = [] // User-defined categories
  
  @State private var errorMessage: String? // Error message for displaying API key validation feedback
  @State private var showArchiveView = false // State for displaying the archive manager view
  @State private var databasePath = "" // State for showing/hiding the database location
  
  // Default countries and categories provided by the app
  let defaultCountries = ["us", "no", "fr", "de", "es"]
  let defaultCategories = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
  
  var body: some View
  {
    NavigationStack
    {
      Form
      {
        // Section for managing API key
        Section(header: Label("API Key", systemImage: "key"))
        {
          SecureField("Enter API Key", text: $apiKey) // Secure field for entering API key
          Button(action:
          {
            Task
            {
              if await validateApiKey(apiKey) { // Validate the API key
                errorMessage = "API key saved successfully!" // Success feedback
              }
              else
              {
                errorMessage = "Invalid API key. Please try again." // Error feedback
              }
            }
          })
          {
            Label("Save API Key", systemImage: "icloud.and.arrow.down.fill")
          }
          // Display error or success message
          if let message = errorMessage
          {
            Text(message)
              .foregroundColor(message.contains("successfully") ? .green : .red)
              .font(.caption)
          }
        }
        
        // Section for toggling dark mode
        Section(header: Label("Dark Mode", systemImage: "gearshape"))
        {
          Toggle(isOn: $isDarkMode)
          {
            Label("Activate Dark Mode", systemImage: isDarkMode ? "moon.zzz" : "moon.circle")
          }
        }
        
        // Section for managing news ticker settings
        Section(header: Text("News Ticker Settings"))
        {
          Toggle("Enable News Ticker", isOn: $isNewsTickerEnabled)
          
          // Picker for selecting country
          Picker("Country", selection: $selectedCountry)
          {
            ForEach(combinedCountries(), id: \.self)
            { country in
              Text(country.uppercased()).tag(country)
            }
          }
          
          // Picker for selecting category
          Picker("Category", selection: $selectedCategory)
          {
            ForEach(combinedCategories(), id: \.self)
            { category in
              Text(category.capitalized).tag(category)
            }
          }
        }
        
        // Section for adding new country or category
        Section(header: Label("Add New Country or Category", systemImage: "folder.badge.plus.fill"))
        {
          NavigationLink(destination: NewCountryCategory())
          {
            Label("New country or category", systemImage: "folder.badge.plus.fill")
          }
        }
        
        // Section for managing existing countries and categories
        Section(header: Label("Manage country and category", systemImage: "trash"))
        {
          NavigationLink(destination: ManageCountryCategoryView())
          {
            Label("Delete country or category", systemImage: "trash")
          }
        }
        
        // Section for managing archive
        Section(header: Label("Archive Management", systemImage: "archivebox.fill"))
        {
          Button(action:
          {
            showArchiveView.toggle() // Show or hide the archive manager
          })
          {
            Label("Open Archive Manager", systemImage: "archivebox.fill")
          }
          .fullScreenCover(isPresented: $showArchiveView)
          {
            ArchiveView()
              .environment(\.colorScheme, isDarkMode ? .dark : .light)
          }
        }
        
        // Section for showing the database location
        Section(header: Label("Database Location", systemImage: "square.stack.3d.up.fill"))
        {
          Button(action:
          {
            if databasePath.isEmpty
            { // Check if the path is empty
              guard let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
              let dbUrl = appSupportDir.appendingPathComponent("default.store")
              if FileManager.default.fileExists(atPath: dbUrl.path)
              { // Check if database exists
                databasePath = dbUrl.path
                print(databasePath)
              }
            }
            else
            {
              databasePath = "" // Clear the path
            }
          })
          {
            Label(databasePath.isEmpty ? "Show Database Location" : "Hide Database Location", systemImage: "square.stack.3d.up.fill")
          }
          // Display the database path if available
          if !databasePath.isEmpty
          {
            Text(databasePath)
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
      }
      .navigationTitle("Settings")
      .onAppear(perform: loadStoredData)
    }
  }
  
  // Fetch stored countries and categories from the database
  private func loadStoredData()
  {
    do
    {
      let storedCountries = try context.fetch(FetchDescriptor<Country>()) // Fetch user-defined countries
      userCountries = storedCountries.map { $0.name }
      
      let storedCategories = try context.fetch(FetchDescriptor<Category>()) // Fetch user-defined categories
      userCategories = storedCategories.map { $0.name }
      
    }
    catch
    {
      print("Error fetching stored data: \(error.localizedDescription)")
    }
  }
  
  // Combine default and user-defined countries into a single sorted list
  private func combinedCountries() -> [String]
  {
    Array(Set(defaultCountries + userCountries)).sorted()
  }
  
  // Combine default and user-defined categories into a single sorted list
  private func combinedCategories() -> [String]
  {
    Array(Set(defaultCategories + userCategories)).sorted()
  }
}

#Preview
{
  SettingsView()
}
