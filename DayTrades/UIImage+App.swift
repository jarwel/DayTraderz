//
//  UIImage+App.swift
//  DayTrades
//
//  Created by Jason Wells on 7/20/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension UIImage {
    
    func tintedWithGoldColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.yellowColor().CGColor,
            UIColor.brownColor().CGColor,
            UIColor.yellowColor().CGColor,
            UIColor.whiteColor().CGColor])
    }
    
    func tintedWithSilverColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.grayColor().CGColor,
            UIColor.darkGrayColor().CGColor,
            UIColor.grayColor().CGColor,
            UIColor.whiteColor().CGColor])
    }
    
    func tintedWithBronzeColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.brownColor().CGColor,
            UIColor.orangeColor().CGColor,
            UIColor.brownColor().CGColor,
            UIColor.whiteColor().CGColor])
    }
    
    func tintedWithBlueColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.blueColor().CGColor,
            UIColor.blueColor().CGColor])
    }
    
    func tintedWithRedColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.redColor().CGColor,
            UIColor.redColor().CGColor])
    }
    
    func tintedWithWhiteColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.lightGrayColor().CGColor,
            UIColor.whiteColor().CGColor,
            UIColor.whiteColor().CGColor,
            UIColor.whiteColor().CGColor])
    }
    
    func tintedWithLinearGradientColors(colors: Array<CGColorRef>) -> UIImage {
        let scale: CGFloat = self.scale
        UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale))
        let context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        let rect: CGRect = CGRectMake(0, 0, self.size.width * scale, self.size.height * scale);
        CGContextDrawImage(context, rect, self.CGImage);
        let space: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let gradient: CGGradientRef = CGGradientCreateWithColors(space, colors, nil)
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,self.size.height * scale), 0)
        let gradientImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
}
