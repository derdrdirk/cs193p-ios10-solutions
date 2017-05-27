//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    // outlets to the UI components in our Custom UITableViewCell
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    // public API of this UITableViewCell subclass
    // each row in the table has its own instance of this class
    // and each instance will have its own tweet to show
    // as set by this var
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
        if let tweet = tweet {
            tweetTextLabel?.attributedText = getColorizedTextLabel(tweet: tweet)
        }
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
            
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    private struct Colors {
        static let hastag = UIColor.blue
        static let user = UIColor.green
        static let url = UIColor.brown
    }
    
    private func getColorizedTextLabel(tweet: Tweet) -> NSAttributedString {
        let text = NSMutableAttributedString(string: tweet.text)
        text.setMentionColor(mentions: tweet.hashtags, color: Colors.hastag)
        text.setMentionColor(mentions: tweet.userMentions, color: Colors.user)
        text.setMentionColor(mentions: tweet.urls, color: Colors.url)
        return text
    }
}

private extension NSMutableAttributedString {
    func setMentionColor(mentions: [Mention], color: UIColor) {
        for mention in mentions {
            self.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
