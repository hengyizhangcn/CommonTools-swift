//
//  CTNavigationBar.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import UIKit
public class CTNavigationBar : UIView {
    private var leftBar: UIView?
    private var rightBar: UIView?
    private var ct_TitleView: UIView?
    
    public var leftBarItem: UIView? {
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
    public var rightBarItem: UIView? {
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
    public var titleView: UIView? {
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
    
    private var line: UIView?
    
    public func hideLine() -> Void {
        self.line?.hidden = true
    }
    
    public func showLine() -> Void {
        self.line?.hidden = false
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() -> Void {
        self.backgroundColor = UIColor.whiteColor()
        line = UIView.init(frame: CGRectMake(0, self.viewHeight - 0.5, self.viewWidth, 0.5))
        line?.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(line!)
    }
}
