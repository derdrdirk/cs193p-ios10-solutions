//
//  DBMention.swift
//  Smashtag
//
//  Created by Dirk Hornung on 2/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class DBMention: NSManagedObject {
    class func findOrCreateMention(searchQuery query: String, matching mentionInfo: Twitter.Mention, in context: NSManagedObjectContext) throws -> DBMention {
        let request: NSFetchRequest<DBMention> = DBMention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@ AND query = %@", mentionInfo.keyword, query)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                matches[0].count = matches[0].count + 1;
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let mention = DBMention(context: context)
        mention.keyword = mentionInfo.keyword
        mention.query = query
        mention.count = 1
        return mention
    }
 
}
