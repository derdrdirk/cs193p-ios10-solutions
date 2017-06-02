//
//  RecentQueryTableViewCell.swift
//  Smashtag
//
//  Created by Dirk Hornung on 27/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class RecentQueryTableViewCell: UITableViewCell {
    @IBOutlet weak var recentQueryLabel: UILabel!
    
    var recentQuery: String? { didSet { updateUI() }}
    
    private func updateUI() {
        recentQueryLabel.text = recentQuery!
    }
}
