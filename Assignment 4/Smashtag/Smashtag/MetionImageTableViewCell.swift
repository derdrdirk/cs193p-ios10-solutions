//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Dirk Hornung on 26/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionImageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    var url: URL? { didSet{ updateUI() }}
    var aspectRatio: Double?
    
    private func updateUI() {
        if let url = url {
            DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
                if let data = try? Data(contentsOf: url), url == self?.url {
                    DispatchQueue.main.async {
                        self?.tweetImage?.image = UIImage(data: data)
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
