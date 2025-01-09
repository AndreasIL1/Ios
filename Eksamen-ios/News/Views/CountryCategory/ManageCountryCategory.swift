//
//  ManageCountryCategory.swift
//  News
//
//  Created by Andreas Langedal on 05/12/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct ManageCountryCategoryView: View
{
  @Environment(\.modelContext) private var context // Access the database context
  @State private var userCountries: [Country] = [] // Stores the list of user-defined countries
  @State private var userCategories: [Category] = [] // Stores the list of user-defined categories
  
  @State private var showToast = false // State to control toast visibility
  @State private var toastMessage = "" // Message to display in the toast
  @State private var toastColor: Color = .green // Background color of the toast
  @AppStorage("isDarkMode") private var isDarkMode = false // Tracks the user's dark mode preference
  
  var body: some View
  {
    ZStack
    {
      Color(.systemBackground)
        .ignoresSafeArea()
      
      NavigationStack
      {
        VStack
        {
          // Section for managing user-defined countries
          if !userCountries.isEmpty {
            Section(header: Text("User-Defined Countries"))
            {
              List
              {
                ForEach(userCountries)
                { country in
                  HStack
                  {
                    Text(country.name)
                    Spacer()
                    Button(role: .destructive)
                    {
                      deleteCountry(country)
                    }
                  label:
                    {
                      Label("Delete", systemImage: "trash")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                  }
                }
              }
            }
          }
          
          // Section for managing user-defined categories
          if !userCategories.isEmpty
          {
            Section(header: Text("User-Defined Categories"))
            {
              List
              {
                ForEach(userCategories)
                { category in
                  HStack
                  {
                    Text(category.name)
                    Spacer()
                    Button(role: .destructive)
                    {
                      deleteCategory(category)
                    }
                  label:
                    {
                      Label("Delete", systemImage: "trash")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                  }
                }
              }
            }
          }
          
          Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar
        {
          ToolbarItem(placement: .principal)
          {
            Text("Manage Countries and Categories")
              .font(.headline)
              .foregroundColor(Color.primary)
          }
        }
        .onAppear(perform: loadStoredData)
        .toast(message: toastMessage, color: toastColor, isShowing: $showToast)
      }
    }
    .environment(\.colorScheme, isDarkMode ? .dark : .light)
  }
  
  // Load user-defined countries and categories from the database
  private func loadStoredData()
  {
    do
    {
      // Fetch all stored countries and assign them to `userCountries`
      let storedCountries = try context.fetch(FetchDescriptor<Country>())
      userCountries = storedCountries
      
      // Fetch all stored categories and assign them to `userCategories`
      let storedCategories = try context.fetch(FetchDescriptor<Category>())
      userCategories = storedCategories
      
    } catch {
      showToastMessage("Error fetching data: \(error.localizedDescription)", color: .red)
    }
  }
  
  // Delete a specific country from the database
  private func deleteCountry(_ country: Country)
  {
    context.delete(country)
    do
    {
      try context.save()
      loadStoredData()
      showToastMessage("Country deleted successfully!", color: .green)
    }
    catch
    {
      showToastMessage("Error deleting country: \(error.localizedDescription)", color: .red)
    }
  }
  
  // Delete a specific category from the database
  private func deleteCategory(_ category: Category)
  {
    context.delete(category)
    do
    {
      try context.save()
      loadStoredData()
      showToastMessage("Category deleted successfully!", color: .green)
    }
    catch
    {
      // Display an error message if deletion fails
      showToastMessage("Error deleting category: \(error.localizedDescription)", color: .red)
    }
  }
  
  // Display a toast notification with a message and color
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
  ManageCountryCategoryView()
}

