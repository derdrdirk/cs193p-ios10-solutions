//
//  RecentQueriesTableViewController.swift
//  Smashtag
//
//  Created by Dirk Hornung on 27/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class RecentQueriesTableViewController: UITableViewController {

    var recentQueries = { RecentQueries.get() }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentQueries().count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentQueryCell", for: indexPath)
        if let recentQueryCell = cell as? RecentQueryTableViewCell {
            recentQueryCell.recentQuery = recentQueries()[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath)
            if let recentQueryCell = cell as? RecentQueryTableViewCell,
                let query = recentQueryCell.recentQuery {
                tableView.beginUpdates()
                RecentQueries.remove(query: query)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    // MARK: - Livecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tweetTable = segue.destination as? TweetTableViewController,
            let recentQueryCell = sender as? RecentQueryTableViewCell,
                let recentQuery = recentQueryCell.recentQuery {
                    tweetTable.searchText = recentQuery
        }
    }

}
