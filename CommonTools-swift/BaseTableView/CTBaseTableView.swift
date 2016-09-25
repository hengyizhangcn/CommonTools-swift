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

open class CTBaseTableView: UIView {
    open var tableView: UITableView?
    open var currentPage: NSInteger = 0
    open var totalPage: NSInteger = 0
    open var currentSection: NSInteger = 0
    open var loading: Bool = false
    open var hasNextPage: Bool = false
    open var modelArray: NSMutableArray = NSMutableArray()
    open weak var delegate: CTBaseTableViewDelegate?
    
    open var scrollBlock: (() -> Void)?
    
    fileprivate lazy var footerView: UIView = {
        let tmpView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.viewWidth
            , height: 44))
        let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        loadingIndicatorView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        loadingIndicatorView.center = tmpView.viewCenter
        tmpView.addSubview(loadingIndicatorView)
        loadingIndicatorView.startAnimating()
        
        let topLine: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.viewWidth, height: 0.5))
        topLine.backgroundColor = UIColor.gray
        topLine.alpha = 0.8
        tmpView.addSubview(topLine)
        return tmpView
    }()
    fileprivate var loadingIndicatorView: UIActivityIndicatorView?
    
    override public convenience init(frame: CGRect) {
        self.init(frame: frame, style: UITableViewStyle.plain)
    }
    
    public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame)
        self.initUI(style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func viewWillAppear() -> Void {
        tableView?.scrollsToTop = true
    }
    
    open func viewWillDisappear() -> Void {
        tableView?.scrollsToTop = false
    }
    
    open func requestFirstPage() -> Void {
        
    }
    
    open func requestNextPage() -> Void {
        failLoadData()
    }
    
    open func showLoadingIndicatorView() -> Void {
        tableView?.isHidden = true
        loadingIndicatorView?.isHidden = false
        loadingIndicatorView?.startAnimating()
    }
    
    open func finishedLoadData(_ currentPage: NSInteger, dataSource: NSArray, totalPage: NSInteger, needReloadData: Bool) -> Void {
        loading = false
        if currentPage == 1 {
            modelArray.removeAllObjects()
        }
        if dataSource.count > 0 && dataSource.isKind(of: NSArray.self) {
            modelArray.addObjects(from: dataSource as [AnyObject])
        }
        self.currentPage = currentPage
        
        hasNextPage = totalPage > currentPage && dataSource.count > 0
        
        if needReloadData {
            tableView?.reloadData()
        }
        
        tableView?.tableFooterView = hasNextPage ? footerView : nil
        
        tableView?.isHidden = false
        loadingIndicatorView?.isHidden = true
        loadingIndicatorView?.stopAnimating()
    }
    
    open func failLoadData() -> Void {
        loadingIndicatorView?.stopAnimating()
        loadingIndicatorView?.isHidden = true
        loading = false
    }
    
    
    
    func initUI(_ style: UITableViewStyle) -> Void {
        currentPage = 1
        currentSection = 0
        self.backgroundColor = UIColor.white
        modelArray = NSMutableArray()
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight), style: style)
        tableView?.scrollsToTop = false
        tableView?.backgroundColor = UIColor.white
        self.addSubview(tableView!)
        tableView?.frame = CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        
        loadingIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        loadingIndicatorView?.isHidden = true
        self.addSubview(loadingIndicatorView!)
        loadingIndicatorView?.frame = (tableView?.frame)!
    }

    open func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let rowsCount: NSInteger = self.tableView(tableView, numberOfRowsInSection: currentSection)
        if currentSection == (indexPath as NSIndexPath).section && hasNextPage && self.modelArray.count > 0 && ((indexPath as NSIndexPath).row == rowsCount - 1) && !loading {
            if delegate == nil {
                self.requestNextPage()
            } else {
                delegate?.requestNextPage!()
            }
        }
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollBlock?()
    }
    
}

@objc
public protocol CTBaseTableViewDelegate : NSObjectProtocol {
    @objc optional func requestFirstPage() -> Void
    @objc optional func requestNextPage() -> Void
}
