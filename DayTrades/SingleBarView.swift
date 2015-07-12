//
//  SingleBarView.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation
import UIKit

class SingleBarView: UIView {
    
    let subview: UIView = UIView()
    let label: UILabel = UILabel()
    
    var barColor: UIColor = UIColor.clearColor()
    var picks: UInt = 0
    var total: UInt = 0

    override func awakeFromNib() {
        backgroundColor = UIColor.clearColor()
        addSubview(subview)
        addSubview(label)
        subview.backgroundColor = UIColor.redColor();
        label.frame = CGRectMake(0, 0, self.frame.width - 4, self.frame.height)
        label.textAlignment = NSTextAlignment.Right
        label.font = UIFont.boldSystemFontOfSize(16.0)
        label.textColor = UIColor.blackColor()
        resetView()
    }
    
    func resetView() {
        subview.frame = CGRectMake(frame.width, 0, 0, frame.height)
        label.hidden = true
    }
    
    func animate() {
        resetView()
        if total > 0 {
            let percent: CGFloat = CGFloat(picks) / CGFloat(total)
            let width: CGFloat = frame.width * percent
            let x: CGFloat = frame.width - width
            subview.backgroundColor = barColor
            label.text = "\(picks)"
            UIView.animateWithDuration(1.0, delay: 0.5, options: nil, animations: {
                self.subview.frame = CGRectMake(x, 0, width, self.frame.height)
                }, completion: { finished in
                    self.label.hidden = false;
            })
        }
    }
    
}
