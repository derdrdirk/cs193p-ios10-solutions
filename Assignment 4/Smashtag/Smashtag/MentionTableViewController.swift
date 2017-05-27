//
//  DetailTableViewController.swift
//  Smashtag
//
//  Created by Dirk Hornung on 26/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {
    
    // MARK: Model
    
    private var mentions = [Mentions]()
    
    private struct Mentions: CustomStringConvertible {
        var title: String
        var data: [MentionItem]
        var description: String { return "\(data)" }
    }
    
    private enum MentionItem {
        case Keyword(String)
        case Image(URL, Double)
    }
    
    var tweet: Tweet? {
        didSet {
            if let images = tweet?.media, !tweet!.media.isEmpty {
                mentions.append(Mentions(title: "Images", data: images.map {MentionItem.Image($0.url, $0.aspectRatio) }))
            }
            if let hastags = tweet?.hashtags, !tweet!.hashtags.isEmpty {
                mentions.append(Mentions(title: "Hastags", data: hastags.map { MentionItem.Keyword($0.keyword) }))
            }
            if let urls = tweet?.urls, !tweet!.urls.isEmpty {
                mentions.append(Mentions(title: "Urls", data: urls.map { MentionItem.Keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions, !tweet!.userMentions.isEmpty {
                mentions.append(Mentions(title: "Users", data: users.map { MentionItem.Keyword($0.keyword) }))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordCell", for: indexPath)
            if let keywordCell = cell as? MentionKeywordTableViewCell {
                keywordCell.keyword = keyword
            }
            return cell
        case .Image(let (url, _)):
           let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
            if let imageCell = cell as? MentionImageTableViewCell {
                imageCell.url = url
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // make it a little clearer when each pull from Twitter
        // occurs in the table by setting section header titles
        return mentions[section].title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let aspectRatio):
            return tableView.bounds.size.width / CGFloat(aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "KeywordCell" {
            if let tweetTable = segue.destination as? TweetTableViewController,
                let mentionKeywordCell = sender as? MentionKeywordTableViewCell,
                let keyword = mentionKeywordCell.keyword {
                tweetTable.searchText = keyword
            }
        } else {
            if let imageView = segue.destination as? ImageViewController,
                let mentionImageCell = sender as? MentionImageTableViewCell,
                let url = mentionImageCell.url {
                        imageView.imageURL = url
            }
        }
    }
    
    // do not segue if clicked on URL
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let mentionKeywordCell = sender as? MentionKeywordTableViewCell,
            let keyword = mentionKeywordCell.keyword,
            let url = URL(string: keyword) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    

}
