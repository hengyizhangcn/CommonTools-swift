//
//  CTPageControl.swift
//  Pods
//
//  Created by zhy on 9/27/16.
//
//

import UIKit

open class CTPageControl : UIView {
    //总页数
    open var numberOfPages: NSInteger {
        set {
            var lastView: UIView?
            indicatorsMutableArray.removeAllObjects()
            self.removeAllSubViews()
            for i in 0..<newValue {
                var view = UIView.init(frame: CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorWidth))
                if i == 0 {
                    view.backgroundColor = currentPageIndicatorTintColor
                    view.left = (self.viewWidth/2 - (CGFloat(newValue) * indicatorWidth + CGFloat(newValue - 1) * gap) / 2)
                } else {
                    view.left = lastView!.right + gap
                    view.backgroundColor = pageIndicatorTintColor
                    view.layer.borderWidth = 1.0
                    view.layer.borderColor = pageIndicatorLayerColor.cgColor
                }
                view.layer.cornerRadius = indicatorWidth/2
                view.centerY = self.centerY
                lastView = view
                self.addSubview(view)
                indicatorsMutableArray.add(view)
            }
        }
        get {
            return 0
        }
    }
    //当前页
    open var currentPage: NSInteger {
        get {
            return 0
        }
        set {
            for i in 0..<indicatorsMutableArray.count {
                var view: UIView = indicatorsMutableArray[i] as! UIView
                if i == newValue {
                    view.backgroundColor = currentPageIndicatorTintColor
                    view.layer.borderWidth = 0
                } else {
                    view.backgroundColor = pageIndicatorTintColor
                    view.layer.borderWidth = 0
                    view.layer.borderColor = pageIndicatorLayerColor.cgColor
                }
            }
        }
    }
    //未选中选框颜色，默认0xe6e6e6
    open var pageIndicatorLayerColor = UIColor.colorWithHex(0xe6e6e6)
    //未选中颜色，默认白色
    open var pageIndicatorTintColor = UIColor.white
    //选中颜色，默认0xcccccc
    open var currentPageIndicatorTintColor = UIColor.colorWithHex(0xcccccc)
    //小点宽度，默认7
    open var indicatorWidth: CGFloat = 7.0
    //间隔，默认7
    open var gap: CGFloat = 7.0
    
    fileprivate var indicatorsMutableArray = NSMutableArray()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
