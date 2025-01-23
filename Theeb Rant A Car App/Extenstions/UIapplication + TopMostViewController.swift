//
//  UIapplication + TopMostViewController.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 13/06/1443 AH.
//

import UIKit
extension UIApplication {
    
    static var keyWindow: UIWindow? {
//        return (UIApplication.shared.connectedScenes.first?.delegate as? AppDelegate)?.window
        return  UIApplication.shared.delegate?.window ?? UIWindow()
    }
    
    class func topMostController() -> UIViewController {
        guard var topController: UIViewController = UIApplication.keyWindow?.rootViewController else { return UIViewController() }
        while topController.presentedViewController != nil {
            topController = topController.presentedViewController!
        }
        return topController
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


