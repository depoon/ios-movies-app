//
//  MovieCollectionDto.swift
//  ios-movies-app
//
//  Created by mkamhawi on 8/22/17.
//  Copyright © 2017 Mohamed Elkamhawi. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

class MovieCollectionDto: Mappable {
    var page: Int!
    var totalPages: Int!
    var totalResults: Int!
    var results: [MovieDto]?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        results <- map["results"]
    }
    
    func insert(into categoryName: String) {
        AppDelegate.persistentContainer.performBackgroundTask { context in
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", argumentArray: [categoryName])
            
            do{
                let matches = try context.fetch(request)
                var category: Category
                if matches.count > 0 {
                    assert(matches.count == 1, "MovieCollectionDto -- insert: database inconsistency")
                    category = matches[0]
                } else {
                    category = Category(context: context)
                    category.name = categoryName
                }
                
                for movie in self.results! {
                    MovieDto.insert(movie: movie, into: category, within: context)
                }
                do {
                    try context.save()
                } catch {
                    fatalError("Error: MovieCollectionDto.insert(): \(error)")
                }
            } catch {
                fatalError("Error: MovieCollectionDto.insert(): \(error)")
            }
        }
    }
}
