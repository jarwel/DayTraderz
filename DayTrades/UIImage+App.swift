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
            UIColor.yellowColor(),
            UIColor.brownColor(),
            UIColor.yellowColor(),
            UIColor.whiteColor()])
    }
    
    func tintedWithSilverColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.grayColor(),
            UIColor.darkGrayColor(),
            UIColor.grayColor(),
            UIColor.whiteColor()])
    }
    
    func tintedWithBronzeColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.brownColor(),
            UIColor.orangeColor(),
            UIColor.brownColor(),
            UIColor.whiteColor()])
    }
    
    func tintedWithBlueColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.blueColor(),
            UIColor.blueColor()])
    }
    
    func tintedWithRedColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.redColor(),
            UIColor.redColor()])
    }
    
    func tintedWithWhiteColor() -> UIImage {
        return tintedWithLinearGradientColors([
            UIColor.lightGrayColor(),
            UIColor.whiteColor(),
            UIColor.whiteColor(),
            UIColor.whiteColor()])
    }
    
    func tintedWithLinearGradientColors(colors: Array<UIColor>) -> UIImage {
        let scale: CGFloat = self.scale
        UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale))
        let context: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        let rect: CGRect = CGRectMake(0, 0, self.size.width * scale, self.size.height * scale);
        CGContextDrawImage(context, rect, self.CGImage);
        var colorRefs: Array<CGColorRef> = Array()
        for color: UIColor in colors {
            colorRefs.append(color.CGColor)
        }
        let space: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let gradient: CGGradientRef = CGGradientCreateWithColors(space, colorRefs, nil)
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,self.size.height * scale), 0)
        let gradientImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
}
