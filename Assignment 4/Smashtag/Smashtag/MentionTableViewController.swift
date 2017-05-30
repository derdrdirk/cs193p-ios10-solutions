//
//  DetailTableViewController.swift
//  Smashtag
//
//  Created by Dirk Hornung on 26/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import SafariServices

class MentionTableViewController: UITableViewController {
    
    // MARK: Model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPopToRootButton()
    }
    
    
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
                mentions.append(Mentions(title: "Hashtags", data: hastags.map { MentionItem.Keyword($0.keyword) }))
            }
            if let urls = tweet?.urls, !tweet!.urls.isEmpty {
                mentions.append(Mentions(title: "Urls", data: urls.map { MentionItem.Keyword($0.keyword) }))
            }
            
            if let userScreenName = tweet?.user.screenName {
                // append Tweet owner itself
                var userMentionItems: [MentionItem] = [MentionItem.Keyword("@\(userScreenName)")]
                if let users = tweet?.userMentions, !tweet!.userMentions.isEmpty {
                    userMentionItems.append(contentsOf: users.map { MentionItem.Keyword($0.keyword) })
                    mentions.append(Mentions(title: "Users", data: userMentionItems))
                }
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = mentions[indexPath.section]
        let sectionTitle = section.title
        let mention = section.data[indexPath.row]

        let cell = tableView.cellForRow(at: indexPath)
        
        switch sectionTitle {
        case "Images":
            performSegue(withIdentifier: "ImageCell", sender: indexPath)
        case "Hashtags":
            performSegue(withIdentifier: "KeywordCell", sender: indexPath)
        case "Users":
            performSegue(withIdentifier: "KeywordCell", sender: indexPath)
        case "Urls":
            if case .Keyword(let url) = mention {
                if let url = URL(string: url) {
                    let svc = SFSafariViewController(url: url)
                    self.present(svc, animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }

    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            let mention = mentions[indexPath.section].data[indexPath.row]
            if segue.identifier! == "KeywordCell" {
                if let tweetTable = segue.destination as? TweetTableViewController {
                    if case .Keyword(let keyword) = mention {
                        tweetTable.searchText = keyword
                    }
                }
            } else {
                if let imageView = segue.destination as? ImageViewController {
                    if case .Image(let url, _) = mention {
                        imageView.imageURL = url
                    }
                }
            }
        }
    }
}
