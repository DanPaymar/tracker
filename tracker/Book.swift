//
//  Book.swift
//  tracker
//
//  Created by Daniel Paymar on 6/18/24.
//

import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var author: String
    var publishdedYear: Int
    
    init(title: String, author: String, publishdedYear: Int) {
        self.title = title
        self.author = author
        self.publishdedYear = publishdedYear
    }
}
