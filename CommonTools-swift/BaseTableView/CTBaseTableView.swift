//
//  CTBaseTableView.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//
//http://c.biancheng.net/cpp/html/2268.html
//http://stackoverflow.com/questions/24103169/swift-compiler-error-non-modular-header-inside-framework-module
//http://stackoverflow.com/questions/28815487/building-a-swift-framework-with-references-to-objective-c-code

import UIKit

class CTBaseTableView: UIView {
    
    func viewWillAppear() -> Void {
//        UITableViewDataSource
    }
}

@objc
public protocol CTBaseTableViewDelegate : NSObjectProtocol {
    optional func requestFirstPage() -> Void
    optional func requestNextPage() -> Void
}