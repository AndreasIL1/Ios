//
//  ToastLogic.swift
//  News
//
//  Created by Andreas Langedal on 09/12/2024.
//

import Foundation
import SwiftUI

// A custom view modifier for displaying toast messages
struct ToastModifier: ViewModifier
{
  var message: String // The message to display in the toast
  var color: Color // The background color of the toast
  @Binding var isShowing: Bool // Binding to control the visibility of the toast
  
  func body(content: Content) -> some View
  {
    ZStack
    {
      content
      
      // Show the toast if `isShowing` is true
      if isShowing
      {
        VStack
        {
          Spacer()
          ToastView(message: message, color: color)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: isShowing)
      }
    }
  }
}

// Extension on `View` to simplify the usage of the `ToastModifier`
extension View
{
  // Adds the toast functionality to any view
  // - Parameters:
  //   - message: The message to display in the toast
  //   - color: The background color of the toast
  //   - isShowing: A binding to control the visibility of the toast
  func toast(message: String, color: Color, isShowing: Binding<Bool>) -> some View
  {
    self.modifier(ToastModifier(message: message, color: color, isShowing: isShowing)) // Apply the modifier
  }
}

