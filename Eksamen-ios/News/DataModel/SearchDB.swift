//
//  SearchDB.swift
//  News
//
//  Created by Andreas Langedal on 19/11/2024.
//

import Foundation
import SwiftData

@Model final class Search
{
  var id: UUID = UUID()
  var keyword: String
  var createdAt: Date = Date()
  
  init(keyword: String)
  {
    self.keyword = keyword
  }
}



