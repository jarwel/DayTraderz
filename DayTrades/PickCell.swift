//
//  PickCell.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class PickCell: UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.translucentColor()
        let view: UIView = UIView()
        view.backgroundColor = UIColor.selectedColor()
        selectedBackgroundView = view
    }
    
    func resetView() {
        symbolLabel.text = nil
        dateLabel.text = nil
        openLabel.text = nil
        closeLabel.text = nil
        buyLabel.text = nil
        sellLabel.text = nil
        changeLabel.text = nil
        valueLabel.text = nil
    }
    
}