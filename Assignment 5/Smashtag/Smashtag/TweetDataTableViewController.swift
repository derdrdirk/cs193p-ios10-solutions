//
//  TweetDataTableViewController.swift
//  Smashtag
//
//  Created by Dirk Hornung on 1/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetDataTableViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets);
        
        updateDatabase(with: newTweets)
    }
  
    private func updateDatabase(with newTweets: [Twitter.Tweet]) {
        container?.performBackgroundTask  { [weak self] context in
            for twitterInfo in newTweets {
                if let query = self?.searchText {
                    _ = try? DBTweet.findOrCreateTweet(searchQuery: query, matching: twitterInfo, in: context)
                }
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<DBTweet> = DBTweet.fetchRequest()
                if let tweetCount = (try? context.count(for: request)) {
                    print ("\(tweetCount) tweets")
                }
                if let searchCount = (try? context.count(for: DBSearch.fetchRequest())) {
                    print ("\(searchCount) searches")
                }
                if let mentionCount = (try? context.count(for: DBMention.fetchRequest())) {
                    print ("\(mentionCount) mentions")
                }
            }
        }
    }
}
