//
//  ToastView.swift
//  News
//
//  Created by Andreas Langedal on 04/12/2024.
//

import Foundation
import SwiftUI

// A reusable view for displaying toast messages
struct ToastView: View
{
  var message: String // The text message to display in the toast
  var color: Color // The background color of the toast
  
  var body: some View
  {
    Text(message)
      .font(.caption)
      .foregroundColor(.white)
      .padding()
      .background(color.cornerRadius(8))
      .padding(.bottom, 20)
      .shadow(radius: 4)
  }
}

