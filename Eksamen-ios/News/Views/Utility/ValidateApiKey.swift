//
//  ValidateApiKey.swift
//  News
//
//  Created by Andreas Langedal on 04/12/2024.
//

import Foundation

// Function to validate the NewsAPI API key by making a test request
// - Parameter key: The API key to validate
// - Returns: A boolean indicating whether the key is valid
func validateApiKey(_ key: String) async -> Bool
{
  // Construct the URL for the API validation request
  let url = "https://newsapi.org/v2/top-headlines?apiKey=\(key)&country=us&pageSize=1"
  
  // Ensure the URL is valid
  guard let requestUrl = URL(string: url) else
  {
    return false // Return false if the URL is invalid
  }
  
  do
  {
    // Make a network request to validate the API key
    let (_, response) = try await URLSession.shared.data(from: requestUrl)
    
    // Check if the response is an HTTP response and the status code is 200 (success)
    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
    {
      return true // API key is valid
    }
  }
  catch
  {
    // Print error details if the request fails
    print("Error validating API key: \(error.localizedDescription)")
    return false // Return false if an error occurs
  }
  
  return false // Default return value if the key is invalid
}


