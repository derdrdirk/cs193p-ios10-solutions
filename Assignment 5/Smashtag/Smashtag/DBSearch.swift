//
//  DBSearch.swift
//  Smashtag
//
//  Created by Dirk Hornung on 2/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class DBSearch: NSManagedObject {
    class func findOrCreateSearch(matching searchQuery: String, in context: NSManagedObjectContext) throws -> DBSearch {
        let request: NSFetchRequest<DBSearch> = DBSearch.fetchRequest()
        request.predicate = NSPredicate(format: "query = %@", searchQuery)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let search =  DBSearch(context: context)
        search.query = searchQuery
        return search
    }
}
