//
//  CTNavigationBar.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import UIKit
open class CTNavigationBar : UIView {
    fileprivate var leftBar: UIView?
    fileprivate var rightBar: UIView?
    fileprivate var ct_TitleView: UIView?
    
    open var leftBarItem: UIView? {
        get{
            return leftBar!
        }
        set(newLeftBarItem){
            leftBar?.removeFromSuperview()
            if newLeftBarItem != nil {
                leftBar = newLeftBarItem
                leftBar?.centerY = self.viewHeight / 2
                self.addSubview(leftBar!)
            }
        }
    }
    open var rightBarItem: UIView? {
        get {
            return rightBar!
        }
        set (newRightBarItem) {
            rightBar?.removeFromSuperview()
            if newRightBarItem != nil {
                rightBar = newRightBarItem
                rightBar?.centerY = self.viewHeight / 2
                self.addSubview(rightBar!)
            }
        }
    }
    open var titleView: UIView? {
        get {
            return ct_TitleView!
        }
        set(newTitleView) {
            ct_TitleView?.removeFromSuperview()
            if newTitleView != nil {
                ct_TitleView = newTitleView
                ct_TitleView?.center = self.viewCenter
                self.addSubview(ct_TitleView!)
            }
        }
    }
    
    fileprivate var line: UIView?
    
    open func hideLine() -> Void {
        self.line?.isHidden = true
    }
    
    open func showLine() -> Void {
        self.line?.isHidden = false
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUI() -> Void {
        self.backgroundColor = UIColor.white
        line = UIView.init(frame: CGRect(x: 0, y: self.viewHeight - 0.5, width: self.viewWidth, height: 0.5))
        line?.backgroundColor = UIColor.lightGray
        self.addSubview(line!)
    }
}
