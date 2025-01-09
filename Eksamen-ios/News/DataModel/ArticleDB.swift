//
//  ArticleDB.swift
//  News
//
//  Created by Andreas Langedal on 19/11/2024.
//

import Foundation
import SwiftData

@Model final class Article
{
  var id: UUID = UUID()
  var title: String
  var author: String?
  var news_description: String
  var content: String
  var url: String
  var imageUrl: String?
  var isFavorite: Bool = false
  var isArchived: Bool = false
  var createdAt: Date = Date()
  
  init(
    title: String,
    author: String?,
    news_description: String,
    content: String,
    url: String,
    imageUrl: String?
  )
  {
    self.title = title
    self.author = author
    self.news_description = news_description
    self.content = content
    self.url = url
    self.imageUrl = imageUrl
  }
}




