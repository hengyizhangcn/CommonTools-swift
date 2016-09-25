//
//  CTNavigator.swift
//  Pods
//
//  Created by zhy on 9/8/16.
//
//

import Foundation

open class CTNavigator : NSObject {
    fileprivate var ct_rootNavigationController: UINavigationController?
    
    open var rootNavigationController: UINavigationController {
        set(newRootNavigationController) {
            ct_rootNavigationController = newRootNavigationController
            navigationControllerPool.removeAllObjects()
            navigationControllerPool.add(ct_rootNavigationController!)
        }
        get {
            return ct_rootNavigationController!
        }
    }
    
    open var currentNavigationController: UINavigationController {
        get {
            return self.navigationControllerPool.lastObject as! UINavigationController
        }
    }
    fileprivate var navigationControllerPool: NSMutableArray = NSMutableArray()
    
    open static let instance = CTNavigator()
    
    open func pushViewController(_ viewController: UIViewController, parameters dict: NSDictionary?, animated: Bool) -> Void {
        if viewController.validateParameter(dict) {
            pushViewController(viewController, animated: animated)
        }
    }
    
    open func popViewController(_ animated: Bool) -> UIViewController? {
        if self.navigationControllerPool.count == 0 {
            return nil
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        return nav.popViewController(animated: animated)!
    }
    
    open func presentNavigationViewController(_ viewController: UIViewController, parameters dict: NSDictionary?, animated: Bool, completion: (()->Void)?) -> Bool {
        return presentNavigationViewController(viewController, parameters: dict, animated: animated, completion: completion, gaussEffect: false)
    }
    
    open func presentNavigationViewController(_ viewController: UIViewController, animated: Bool, completion: (()->Void)?) -> Bool {
        return presentNavigationViewController(viewController, animated: animated, completion: completion, gaussEffect: false)
    }
    
    open func presentNavigationViewController(_ viewController: UIViewController, parameters dict: NSDictionary?, animated: Bool, completion: (()->Void)?, gaussEffect: Bool) -> Bool {
        if viewController.validateParameter(dict) {
            return presentNavigationViewController(viewController, animated: animated, completion: completion, gaussEffect: gaussEffect)
        }
        return false
    }
    
    open func presentNavigationViewController(_ viewController: UIViewController, animated: Bool, completion: (()->Void)?, gaussEffect: Bool) -> Bool {
        
        if self.navigationControllerPool.count == 0 {
            return false
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        var presentNavController: UINavigationController
        if viewController.isKind(of: UINavigationController.self) {
            presentNavController = viewController as! UINavigationController
        } else {
            presentNavController = UINavigationController.init(rootViewController: viewController)
        }
        
        if gaussEffect {
            presentNavController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        }
        nav.topVisibleViewController.present(presentNavController, animated: animated, completion: completion)
        self.navigationControllerPool.add(presentNavController)
        return true
    }
    
    open func dismissViewController(_ animated: Bool, completion: (()->Void)?) -> Bool {
        if self.navigationControllerPool.count < 2 {
            return false
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        let presentVC: UIViewController = nav.topVisibleViewController
        self.navigationControllerPool.remove(nav)
        presentVC.dismiss(animated: animated, completion: completion)
        return true
    }
    
    override init() {
    }
    fileprivate func pushViewController(_ viewController: UIViewController, animated: Bool) -> Void {
        if ct_rootNavigationController == nil {
            ct_rootNavigationController = UINavigationController.init(rootViewController: viewController)
            return
        }
        let nav: UINavigationController = self.navigationControllerPool.lastObject as! UINavigationController
        nav.pushViewController(viewController, animated: animated)
    }
}

extension UIViewController {
    open func validateParameter(_ dict: NSDictionary?) -> Bool {
        return true
    }
}

extension UINavigationController {
    open var topVisibleViewController: UIViewController {
        get {
            var visibleViewController: UIViewController = self.visibleViewController!
            while visibleViewController.presentedViewController != nil {
                visibleViewController = visibleViewController.presentedViewController!
            }
            return visibleViewController
        }
    }
}
