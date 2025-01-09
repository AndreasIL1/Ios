//
//  SplashView.swift
//  News
//
//  Created by Andreas Langedal on 20/11/2024.
//

import Foundation
import SwiftUI

struct SplashView: View
{
  @Binding var splash: Bool
  @State private var rotation = 0.0 // Tracks the rotation angle of the logo
  
  var body: some View
  {
    ZStack
    {
      // Black background that covers the entire screen
      Color.black.ignoresSafeArea()
      
      // Animated newspaper logo
      Image("newspaper") // The image file for the logo
        .resizable() // Make the image resizable
        .scaledToFit() // Maintain aspect ratio while fitting within the frame
        .frame(width: 100, height: 100) // Set the size of the image
        .rotationEffect(.degrees(rotation)) // Apply rotation effect based on `rotation` state
        .onAppear
      {
        // Start the animation when the view appears
        withAnimation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: false))
        {
          rotation = 360 // Rotate the image 360 degrees indefinitely
        }
        // Dismiss the splash screen after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          splash = false // Set `splash` to false to hide the splash screen
        }
      }
    }
  }
}

