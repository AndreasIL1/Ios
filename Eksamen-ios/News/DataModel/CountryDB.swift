//
//  CountryDB.swift
//  News
//
//  Created by Andreas Langedal on 19/11/2024.
//

import Foundation
import SwiftData

@Model final class Country
{
  var id: UUID = UUID()
  var name: String
  
  init(name: String)
  {
    self.name = name
  }
}




