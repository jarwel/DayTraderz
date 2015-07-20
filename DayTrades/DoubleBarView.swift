//
//  DoubleBarView.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class DoubleBarView: UIView {
    
    let subview: UIView = UIView()
    let leftLabel: UILabel = UILabel()
    let rightLabel: UILabel = UILabel()
    
    var value: UInt = 0
    var total: UInt = 0
    
    override func awakeFromNib() {
        resetView()
        addSubview(subview)
        addSubview(leftLabel)
        addSubview(rightLabel)
    }
    
    func resetView() {
        hidden = true
        backgroundColor = UIColor.redColor()
        subview.frame = CGRectMake(0, 0, frame.width / 2, frame.height)
        subview.backgroundColor = UIColor.greenColor();
        leftLabel.frame = CGRectMake(4, 0, self.frame.width - 4, self.frame.height)
        leftLabel.textAlignment = NSTextAlignment.Left
        leftLabel.font = UIFont.boldSystemFontOfSize(15.0)
        leftLabel.textColor = UIColor.blackColor()
        leftLabel.text = nil
        rightLabel.frame = CGRectMake(0, 0, self.frame.width - 4, self.frame.height)
        rightLabel.textAlignment = NSTextAlignment.Right
        rightLabel.font = UIFont.boldSystemFontOfSize(15.0)
        rightLabel.textColor = UIColor.blackColor()
        rightLabel.text = nil
    }
    
    func animate(duration: Double) {
        resetView()
        if total > 0 && total >= value {
            hidden = false
            let percent: CGFloat = CGFloat(value) / CGFloat(total)
            let width: CGFloat = frame.width * percent
            leftLabel.text = "\(value)"
            rightLabel.text = "\(total - value)"
            UIView.animateWithDuration(duration, delay: 0, options: nil, animations: {
                self.subview.frame = CGRectMake(0, 0, width, self.frame.height)
            },
            completion: { finished in
                self.rightLabel.hidden = false;
                self.leftLabel.hidden = false;
            })
        }
    }
    
}
