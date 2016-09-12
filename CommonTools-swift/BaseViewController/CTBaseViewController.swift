//
//  CTBaseViewController.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import UIKit
//import YAUIKit

public class CTBaseViewController: UIViewController {
    public var forbiddenPanBack: Bool = false
    public var tableView: CTBaseTableView?
    public lazy var navigationBar: CTNavigationBar = {
        let tempNavigationBar:CTNavigationBar = CTNavigationBar.init(frame: CGRectMake(0, 20, self.view.viewWidth, 44))
        self.view.addSubview(tempNavigationBar)
        return tempNavigationBar
    }()
    public lazy var statusBar: UIView = {
        let tempStatusBar: UIView = UIView.init(frame: CGRectMake(0, 0, self.view.viewWidth, 20))
        self.view.addSubview(tempStatusBar)
        return tempStatusBar
    }()
    
//    private var panBackController: YAPanBackController?
    
    
    public func backBtnControlEventAction() -> Void {
        CTNavigator.instance.popViewController(self, animated: true)
    }
    
    public func pushViewController(viewController: UIViewController, animated: Bool) -> Bool {
        return true
    }
    
    public func popViewControllerAnimated(animated: Bool) -> Bool {
        return true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        if self.navigationController != nil {
            self.navigationController!.setNavigationBarHidden(true, animated: false)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        navigationBar.hidden = false
        statusBar.hidden = false
        
        let titleLabel = UILabel.init(frame: CGRectMake(0, 0, 100, 30))
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.text = "no title"
        titleLabel.textAlignment = NSTextAlignment.Center
        navigationBar.titleView = titleLabel
        
        let backBtn: UIButton = UIButton.init(frame: CGRectMake(0, 0, 44, 44))
        backBtn.setImage(UIImage.init(named: "back_arrow_black"), forState: .Normal)
        backBtn.addTarget(self, action: "backBtnControlEventAction", forControlEvents: .TouchUpInside)
        navigationBar.leftBarItem = backBtn
        
//        panBackController = YAPanBackController.init(currentViewController: self)
    }
}
