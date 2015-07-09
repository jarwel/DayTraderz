//
//  PickCell.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation
import UIKit

class PickCell: UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func clear() {
        self.symbolLabel.text = nil
        self.dateLabel.text = nil
        self.openLabel.text = nil
        self.closeLabel.text = nil
        self.buyLabel.text = nil
        self.sellLabel.text = nil
        self.changeLabel.text = nil
        self.valueLabel.text = nil
    }
    
}