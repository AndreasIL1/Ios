//
//  PlaceholderView.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//
import Foundation
import SwiftUI

// A simple reusable view for displaying a placeholder message
struct PlaceholderView: View
{
  var label: String
  var description: String
  
  init(_ label: String, _ description: String)
  {
    self.label = label
    self.description = description
  }
  
  var body: some View
  {
    ContentUnavailableView(
      label, // Main text
      systemImage: "square.stack.3d.up.slash",
      description: Text(description)
    )
  }
}

#Preview
{
  PlaceholderView("", "")
}


