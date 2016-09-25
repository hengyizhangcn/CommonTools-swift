//
//  UIImage+extends.swift
//  Pods
//
//  Created by zhy on 9/9/16.
//
//

import UIKit

extension UIImage {
    static public func imageWithColor(_ color: UIColor, andHeight height: CGFloat) -> UIImage? {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
