//
//  SingleBarView.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class SingleBarView: UIView {
    
    let subview: UIView = UIView()
    let label: UILabel = UILabel()
    
    var barColor: UIColor = UIColor.clearColor()
    var value: UInt = 0
    var total: UInt = 0

    override func awakeFromNib() {
        resetView()
        addSubview(subview)
        addSubview(label)
    }
    
    func resetView() {
        backgroundColor = UIColor.clearColor()
        subview.frame = CGRectMake(frame.width, 0, 0, frame.height)
        label.frame = CGRectMake(0, 0, self.frame.width - 4, self.frame.height)
        label.textAlignment = NSTextAlignment.Right
        label.font = UIFont.boldSystemFontOfSize(15)
        if value == 0 {
            label.textColor = self.barColor
        }
        else {
            label.textColor = UIColor.blackColor()
        }
        label.text = nil
    }
    
    func animate(duration: Double) {
        resetView()
        if total > 0 && total >= value {
            let percent: CGFloat = CGFloat(value) / CGFloat(total)
            let width: CGFloat = frame.width * percent
            let x: CGFloat = frame.width - width
            subview.backgroundColor = barColor
            UIView.animateWithDuration(duration, delay: 0, options: [], animations: {
                self.subview.frame = CGRectMake(x, 0, width, self.frame.height)
            }, completion: { finished in
                self.label.text = "\(self.value)"
            })
        }
    }
    
}
