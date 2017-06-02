//
//  SearchMentionCounterTableViewController.swift
//  Smashtag
//
//  Created by Dirk Hornung on 2/6/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class SearchMentionCounterTableViewController: FetchedResultsTableViewController {
    
    var searchQuery: String? { didSet { updateUI() } }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        {didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<DBMention>?
    
    private func updateUI() {
        if let context = container?.viewContext, searchQuery != nil {
            let request:NSFetchRequest<DBMention> = DBMention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "keyword", ascending: true)]
            request.predicate = NSPredicate(format: "any query = %@ AND count > 1", searchQuery!)
            fetchedResultsController = NSFetchedResultsController<DBMention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionCount Cell", for: indexPath)
        
        if let dbMention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = dbMention.keyword
            cell.detailTextLabel?.text = String(dbMention.count)
        }
        
        
        return cell
    }
}
