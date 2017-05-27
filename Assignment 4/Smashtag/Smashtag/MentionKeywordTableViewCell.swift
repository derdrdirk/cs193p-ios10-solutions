//
//  MentionKeywordTableViewCell.swift
//  Smashtag
//
//  Created by Dirk Hornung on 27/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionKeywordTableViewCell: UITableViewCell {
   
    @IBOutlet weak var keywordLabel: UILabel!

    var keyword: String? { didSet { updateUI() } }
    
    private func updateUI() {
      keywordLabel.text = keyword
    }

}
