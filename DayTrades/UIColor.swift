//
//  UIColor.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat) {
        var hex: CUnsignedInt = 0
        let scanner: NSScanner = NSScanner(string: hexString)
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        scanner.scanHexInt(&hex)
        let red: CGFloat = CGFloat((hex >> 16) & 0xFF) / 255;
        let green: CGFloat = CGFloat((hex >> 8) & 0xFF) / 255;
        let blue: CGFloat = CGFloat((hex) & 0xFF) / 255;
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

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