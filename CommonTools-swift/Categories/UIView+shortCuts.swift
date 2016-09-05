//
//  UIView+shortCuts.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

import UIKit

extension UIView {
    
    public var viewWidth: CGFloat {
        set(newViewWidth) {
            var rect: CGRect = self.frame
            rect.size.width = newViewWidth
            self.frame = rect
        }
        get {
            return self.frame.size.width
        }
    }
    
    public var viewHeight: CGFloat {
        set(newViewHeight) {
            var rect: CGRect = self.frame
            rect.size.height = newViewHeight
            self.frame = rect
        }
        get {
            return self.frame.size.height
        }
    }
    
    public var top: CGFloat {
        set(newTop) {
            var rect: CGRect = self.frame
            rect.origin.y = newTop
            self.frame = rect
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var left: CGFloat {
        set(newLeft){
            var rect: CGRect = self.frame
            rect.origin.x = newLeft
            self.frame = rect
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var bottom: CGFloat {
        set(newBottom){
            var rect: CGRect = self.frame
            rect.origin.y = newBottom - rect.size.height
            self.frame = rect
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    public var right: CGFloat {
        set(newRight){
            var rect: CGRect = self.frame
            rect.origin.x = newRight - rect.size.width
            self.frame = rect
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    public var centerX: CGFloat {
        set(newCenterX) {
        }
        get {
            return self.frame.size.width / 2
        }
    }
    
    public var centerY: CGFloat {
        set(newCenterY) {
        }
        get {
            return self.frame.size.height / 2
        }
    }
}