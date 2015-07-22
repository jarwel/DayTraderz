//
//  UIColor+App.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension UIColor {

    class func translucentColor() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    class func selectedColor() -> UIColor {
        return UIColor(red: 0, green: 0, blue: 60, alpha: 0.3)
    }
    
    class func increaseColor() -> UIColor {
        return UIColor.greenColor()
    }
    
    class func decreaseColor() -> UIColor {
        return UIColor.redColor()
    }
    
    class func colorForChange(change: Double) -> UIColor {
        if change > 0 {
            return self.increaseColor()
        }
        if change < 0 {
            return self.decreaseColor()
        }
        return self.grayColor()
    }
    
}