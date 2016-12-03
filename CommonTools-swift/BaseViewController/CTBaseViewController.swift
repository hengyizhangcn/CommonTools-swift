//
//  CTBaseViewController.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import UIKit
//import YAUIKit

open class CTBaseViewController: UIViewController {
    open var forbiddenPanBack: Bool = false
    open var tableView: CTBaseTableView?
    open lazy var navigationBar: CTNavigationBar = {
        let tempNavigationBar:CTNavigationBar = CTNavigationBar.init(frame: CGRect(x: 0, y: 20, width: self.view.viewWidth, height: 44))
        self.view.addSubview(tempNavigationBar)
        return tempNavigationBar
    }()
    open lazy var statusBar: UIView = {
        let tempStatusBar: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.viewWidth, height: 20))
        self.view.addSubview(tempStatusBar)
        return tempStatusBar
    }()
    
//    private var panBackController: YAPanBackController?
    
    
    open func backBtnControlEventAction() -> Void {
        CTNavigator.instance.popViewController(true)
    }
    
    open func pushViewController(_ viewController: UIViewController, animated: Bool) -> Bool {
        return true
    }
    
    open func popViewControllerAnimated(_ animated: Bool) -> Bool {
        return true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if self.navigationController != nil {
            self.navigationController!.setNavigationBarHidden(true, animated: false)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        navigationBar.isHidden = false
        statusBar.isHidden = false
        
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.text = "no title"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.white
        navigationBar.titleView = titleLabel
        
        let backBtn: UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        backBtn.setImage(UIImage.init(named: "back_arrow_black"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(CTBaseViewController.backBtnControlEventAction), for: .touchUpInside)
        navigationBar.leftBarItem = backBtn
        
//        panBackController = YAPanBackController.init(currentViewController: self)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if self.tableView != nil, self.tableView!.tableView != nil {
            let rowsCount: NSInteger = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
            if self.tableView!.hasNextPage && self.tableView!.modelArray.count > 0 && indexPath.row == rowsCount - 1 && (indexPath.section + 1) == self.tableView!.tableView!.numberOfSections && !self.tableView!.loading {
                if self.tableView!.delegate == nil {
                    self.tableView!.requestNextPage()
                } else {
                    self.tableView!.delegate?.requestNextPage!()
                }
            }
        }
        
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
