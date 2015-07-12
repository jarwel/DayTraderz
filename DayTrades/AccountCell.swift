//
//  AccountCell.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation
import UIKit

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var winnersLabel: UILabel!
    @IBOutlet weak var losersLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func resetView() {
        self.nameLabel.text = nil
        self.winnersLabel.text = nil
        self.losersLabel.text = nil
        self.valueLabel.text = nil
    }
    
}

