//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by Dirk Hornung on 29/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    var tweet: Tweet?
    
    // MARK: Private Implementation
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
