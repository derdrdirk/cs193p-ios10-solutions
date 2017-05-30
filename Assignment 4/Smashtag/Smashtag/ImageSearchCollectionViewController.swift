//
//  ImageSearchCollectionViewController.swift
//  Smashtag
//
//  Created by Dirk Hornung on 29/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "Cell"

class ImageSearchCollectionViewController: UICollectionViewController {
   
    // MARK: - Model
    public var tweets: [Array<Twitter.Tweet>]?
    
    private var tweetsWithImage:[Tweet]? {
        var tweetsWithImage = [Tweet]()
        for tweetsArray in tweets! {
            for tweet in tweetsArray {
                if tweet.media.count > 0 {
                    tweetsWithImage.append(tweet)
                }
            }
        }
        return tweetsWithImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (tweetsWithImage?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.imageURL = tweetsWithImage?[indexPath.row].media[0].url
            imageCell.tweet = tweetsWithImage?[indexPath.row]
        }
    
        // Configure the cell
    
        return cell
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tweetTable = segue.destination as? TweetTableViewController {
            if let imageCell = sender as? ImageCollectionViewCell {
                tweetTable.searchText = "\"\(imageCell.tweet!.text)\""
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
