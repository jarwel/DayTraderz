//
//  AccountCell.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var awardImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var picksBarView: DoubleBarView!

    override func awakeFromNib() {
        backgroundColor = UIColor.translucentColor()
        let view: UIView = UIView()
        view.backgroundColor = UIColor.selectedColor()
        selectedBackgroundView = view
    }
    
    func resetView() {
        awardImageView.image = nil
        nameLabel.text = nil
        valueLabel.text = nil
        picksBarView.resetView()
    }
    
}

