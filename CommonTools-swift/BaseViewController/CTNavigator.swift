//
//  CTNavigator.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import Foundation

public class CTNavigator : NSObject {
    private var ct_rootNavigationController: UINavigationController?
    
    public var rootNavigationController: UINavigationController {
        set(newRootNavigationController) {
            ct_rootNavigationController = newRootNavigationController
            navigationControllerPool.removeAllObjects()
            navigationControllerPool.addObject(ct_rootNavigationController!)
        }
        get {
            return ct_rootNavigationController!
        }
    }
    
    public var currentNavigationController: UINavigationController {
        get {
            return self.navigationControllerPool.lastObject as! UINavigationController
        }
    }
    private var navigationControllerPool: NSMutableArray = NSMutableArray()
    
    public static let instance = CTNavigator()
    
    public func pushViewController(viewController: UIViewController, parameters dict: NSDictionary?, animated: Bool) -> Void {
        if viewController.validateParameter(dict) {
            pushViewController(viewController, animated: animated)
        }
    }
    
    public func popViewController(viewController: UIViewController, animated: Bool) -> UIViewController? {
        if self.navigationControllerPool.count == 0 {
            return nil
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        return nav.popViewControllerAnimated(animated)!
    }
    
    public func presentNavigationViewController(viewController: UIViewController, parameters dict: NSDictionary?, animated: Bool, completion: (()->Void)?) -> Bool {
        return presentNavigationViewController(viewController, parameters: dict, animated: animated, completion: completion, gaussEffect: false)
    }
    
    public func presentNavigationViewController(viewController: UIViewController, animated: Bool, completion: (()->Void)?) -> Bool {
        return presentNavigationViewController(viewController, animated: animated, completion: completion, gaussEffect: false)
    }
    
    public func presentNavigationViewController(viewController: UIViewController, parameters dict: NSDictionary?, animated: Bool, completion: (()->Void)?, gaussEffect: Bool) -> Bool {
        if viewController.validateParameter(dict) {
            return presentNavigationViewController(viewController, animated: animated, completion: completion, gaussEffect: gaussEffect)
        }
        return false
    }
    
    public func presentNavigationViewController(viewController: UIViewController, animated: Bool, completion: (()->Void)?, gaussEffect: Bool) -> Bool {
        
        if self.navigationControllerPool.count == 0 {
            return false
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        var presentNavController: UINavigationController
        if viewController.isKindOfClass(UINavigationController.self) {
            presentNavController = viewController as! UINavigationController
        } else {
            presentNavController = UINavigationController.init(rootViewController: viewController)
        }
        
        if gaussEffect {
            presentNavController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }
        nav.topVisibleViewController.presentViewController(viewController, animated: animated, completion: completion)
        self.navigationControllerPool.addObject(presentNavController)
        return true
    }
    
    public func dismissViewController(animated: Bool, completion: (()->Void)?) -> Bool {
        if self.navigationControllerPool.count < 2 {
            return false
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        let presentVC: UIViewController = nav.topVisibleViewController
        self.navigationControllerPool.removeObject(nav)
        presentVC.dismissViewControllerAnimated(animated, completion: completion)
        return true
    }
    
    override init() {
    }
    private func pushViewController(viewController: UIViewController, animated: Bool) -> Void {
        if ct_rootNavigationController == nil {
            ct_rootNavigationController = UINavigationController.init(rootViewController: viewController)
            return
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        nav.pushViewController(viewController, animated: animated)
    }
}

extension UIViewController {
    public func validateParameter(dict: NSDictionary?) -> Bool {
        return true
    }
}

extension UINavigationController {
    public var topVisibleViewController: UIViewController {
        get {
            var visibleViewController: UIViewController = self.visibleViewController!
            while visibleViewController.presentedViewController != nil {
                visibleViewController = visibleViewController.presentedViewController!
            }
            return visibleViewController
        }
    }
}
