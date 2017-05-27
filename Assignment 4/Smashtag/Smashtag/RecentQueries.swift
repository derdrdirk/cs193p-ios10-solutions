//
//  RecentQueries.swift
//  Smashtag
//
//  Created by Dirk Hornung on 27/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

struct RecentQueries {
    private static let limit = 100
    private static let key = "recentQueries"
    private static let defaults = UserDefaults.standard
    
    public static func add(query: String) {
        var recentQueries = get()
        
        // unique + case insensitive
        let lowercaseQuery = query.lowercased()
        for recentQuery in recentQueries {
            if recentQuery == lowercaseQuery {
                return
            }
        }
        
        recentQueries.insert(query, at: 0)
        
        // if more than limit delete the last query
        if(recentQueries.count > limit) {
            recentQueries.removeLast()
        }
        defaults.set(recentQueries, forKey: key)
    }
    
    public static func get()->[String] {
        return defaults.stringArray(forKey: key) ?? [String]()
    }
}
