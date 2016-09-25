//
//  UIColor+shortCuts.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import UIKit

extension UIColor {
    static public func colorWithHex(_ hexValue: NSInteger) -> UIColor {
        return self.colorWithHex(hexValue, alpha: 1.0)
    }
    
    static public func colorWithHex(_ hexValue: NSInteger, alpha: CGFloat) -> UIColor {
        let red = CGFloat((hexValue & 0xFF0000) >> 16)
        let green = CGFloat((hexValue & 0xFF00) >> 8)
        let blue = CGFloat(hexValue & 0xFF)
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
