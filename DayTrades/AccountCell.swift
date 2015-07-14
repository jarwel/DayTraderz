//
//  AccountCell.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picksBarView: DoubleBarView!
    
    override func awakeFromNib() {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.blueColor()
        selectedBackgroundView = view
        backgroundColor = UIColor.translucentColor()
    }
    
    func resetView() {
        nameLabel.text = nil
        valueLabel.text = nil
        picksBarView.resetView()
    }
    
}

