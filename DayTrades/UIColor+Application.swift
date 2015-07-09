//
//  UIColor+Application.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    class func translucentColor() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    class func changeColor(change: Double) -> UIColor {
        if change > 0 {
            return self.greenColor()
        }
        if change < 0 {
            return self.redColor()
        }
        return self.grayColor()
    }
    
}