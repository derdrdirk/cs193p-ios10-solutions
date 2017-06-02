//
//  DBTweet.swift
//  Smashtag
//
//  Created by Dirk Hornung on 2/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class DBTweet: NSManagedObject {
    class func findOrCreateTweet(searchQuery query: String, matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> DBTweet {
        let request: NSFetchRequest<DBTweet> = DBTweet.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = DBTweet(context: context)
        tweet.identifier = twitterInfo.identifier
        if let search = try? DBSearch.findOrCreateSearch(matching: query, in: context) {
            tweet.addToSearches(search)
        }
        for mention in twitterInfo.userMentions {
            if let dbMention = try? DBMention.findOrCreateMention(searchQuery: query, matching: mention, in: context) {
                tweet.addToMentions(dbMention)
            }
        }

        return tweet
    }
}
