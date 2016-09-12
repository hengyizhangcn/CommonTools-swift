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

public class CTBaseTableView: UIView {
    public var tableView: UITableView?
    public var currentPage: NSInteger = 0
    public var totalPage: NSInteger = 0
    public var currentSection: NSInteger = 0
    public var loading: Bool = false
    public var hasNextPage: Bool = false
    public var modelArray: NSMutableArray = NSMutableArray()
    public weak var delegate: CTBaseTableViewDelegate?
    
    public var scrollBlock: (() -> Void)?
    
    private lazy var footerView: UIView = {
        let tmpView: UIView = UIView.init(frame: CGRectMake(0, 0, self.viewWidth
            , 44))
        let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingIndicatorView.frame = CGRectMake(0, 0, 30, 30)
        loadingIndicatorView.center = tmpView.viewCenter
        tmpView.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
        
        let topLine: UIView = UIView.init(frame: CGRectMake(0, 0, self.viewWidth, 0.5))
        topLine.backgroundColor = UIColor.grayColor()
        topLine.alpha = 0.8
        tmpView.addSubview(topLine)
        return tmpView
    }()
    private var loadingIndicatorView: UIActivityIndicatorView?
    
    override public convenience init(frame: CGRect) {
        self.init(frame: frame, style: UITableViewStyle.Plain)
    }
    
    public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame)
        self.initUI(style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func viewWillAppear() -> Void {
        tableView?.scrollsToTop = true
    }
    
    public func viewWillDisappear() -> Void {
        tableView?.scrollsToTop = false
    }
    
    public func requestFirstPage() -> Void {
        
    }
    
    public func requestNextPage() -> Void {
        
    }
    
    public func showLoadingIndicatorView() -> Void {
        tableView?.hidden = true
        loadingIndicatorView?.hidden = false
        loadingIndicatorView?.startAnimating()
    }
    
    public func finishedLoadData(currentPage: NSInteger, dataSource: NSArray, totalPage: NSInteger, needReloadData: Bool) -> Void {
        loading = false
        if currentPage == 1 {
            modelArray.removeAllObjects()
        }
        if dataSource.count > 0 && dataSource.isKindOfClass(NSArray.self) {
            modelArray.addObjectsFromArray(dataSource as [AnyObject])
        }
        self.currentPage = currentPage
        
        hasNextPage = totalPage > currentPage && dataSource.count > 0
        
        if needReloadData {
            tableView?.reloadData()
        }
        
        tableView?.tableFooterView = hasNextPage ? footerView : nil
        
        tableView?.hidden = false
        loadingIndicatorView?.hidden = true
        loadingIndicatorView?.stopAnimating()
    }
    
    public func failLoadData() -> Void {
        loadingIndicatorView?.stopAnimating()
        loadingIndicatorView?.hidden = true
        loading = false
    }
    
    
    
    func initUI(style: UITableViewStyle) -> Void {
        currentPage = 1
        currentSection = 0
        self.backgroundColor = UIColor.whiteColor()
        modelArray = NSMutableArray()
        
        tableView = UITableView.init(frame: CGRectMake(0, 0, self.viewWidth, self.viewHeight), style: style)
        tableView?.scrollsToTop = false
        tableView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(tableView!)
        tableView?.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        
        loadingIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        loadingIndicatorView?.hidden = true
        self.addSubview(loadingIndicatorView!)
        loadingIndicatorView?.frame = (tableView?.frame)!
    }

    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let rowsCount: NSInteger = self.tableView(tableView, numberOfRowsInSection: currentSection)
        if currentSection == indexPath.section && hasNextPage && self.modelArray.count > 0 && (indexPath.row == rowsCount - 1) && !loading {
            if delegate == nil {
                self.requestNextPage()
            } else {
                delegate?.requestNextPage!()
            }
        }
    }
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    public func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollBlock?()
    }
    
}

@objc
public protocol CTBaseTableViewDelegate : NSObjectProtocol {
    optional func requestFirstPage() -> Void
    optional func requestNextPage() -> Void
}