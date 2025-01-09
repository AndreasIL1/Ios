//
//  UploadCountryCategory.swift
//  News
//
//  Created by Andreas Langedal on 05/12/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct NewCountryCategory: View
{
  @State private var countryInput: String = "" // Holds the user input for a new country
  @State private var categoryInput: String = "" // Holds the user input for a new category
  @Environment(\.modelContext) private var context // Access the model context for database operations
  @AppStorage("isDarkMode") private var isDarkMode = false // Track dark mode preference
  @State private var showToast = false // State to control toast visibility
  @State private var toastMessage = "" // Message to display in the toast
  @State private var toastColor: Color = .green // Background color of the toast
  
  var body: some View
  {
    ZStack
    {
      // Background color adapting to light or dark mode
      Color(.systemBackground)
        .ignoresSafeArea()
      
      NavigationStack
      {
        VStack(spacing: 20)
        {
          // TextField for entering a new country
          TextField("Enter country...", text: $countryInput)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
          
          // TextField for entering a new category
          TextField("Enter category...", text: $categoryInput)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
          
          // Save Button for storing the entered data
          Button(action: saveData)
          {
            Text("Save")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(10)
          }
          .padding(.horizontal)
          
          Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar
        {
          ToolbarItem(placement: .principal)
          {
            Text("Add Country or Category")
              .font(.headline)
              .foregroundColor(Color.primary)
          }
        }
        .padding(.top)
        .toast(message: toastMessage, color: toastColor, isShowing: $showToast)
      }
    }
    .environment(\.colorScheme, isDarkMode ? .dark : .light)
  }
  
  // Function to save the entered country and/or category to the database
  private func saveData()
  {
    var successMessages = [String]()
    
    // Save country if input is not empty
    if !countryInput.isEmpty
    {
      let country = Country(name: countryInput)
      context.insert(country)
      successMessages.append("Country '\(countryInput)' saved successfully!")
      countryInput = ""
    }
    
    // Save category if input is not empty
    if !categoryInput.isEmpty
    {
      let category = Category(name: categoryInput)
      context.insert(category)
      successMessages.append("Category '\(categoryInput)' saved successfully!")
      categoryInput = ""
    }
    
    // Display appropriate toast message based on input
    if successMessages.isEmpty
    {
      showToastMessage("Please fill in at least one field.", color: .red)
    }
    else
    {
      do
      {
        try context.save() // Save changes to the database
        showToastMessage(successMessages.joined(separator: "\n"), color: .green)
      }
      catch
      {
        showToastMessage("Failed to save data: \(error.localizedDescription)", color: .red)
      }
    }
  }
  
  // Function to display a toast message
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
  NewCountryCategory()
}



