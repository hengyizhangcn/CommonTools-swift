//
//  UIImage+extends.swift
//  Pods
//
//  Created by zhy on 9/9/16.
//
//

import UIKit

extension UIImage {
    static public func imageWithColor(color: UIColor, andHeight height: CGFloat) -> UIImage? {
        let rect: CGRect = CGRectMake(0, 0, 1, height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContextRef? = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}