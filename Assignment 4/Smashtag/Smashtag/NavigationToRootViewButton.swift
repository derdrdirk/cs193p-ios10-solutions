//
//  NavigationControllerBackButton.swift
//  Smashtag
//
//  Created by Dirk Hornung on 29/5/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

extension UIViewController {
    func addPopToRootButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .stop,
            target: self,
            action: #selector(segueToRootViewController(sender: )))
    }
    
    func segueToRootViewController(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
