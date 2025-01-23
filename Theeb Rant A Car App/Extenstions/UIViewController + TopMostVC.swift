//
//  UIViewController + TopMostVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import UIKit

extension UIViewController {
    
    
    func constructTimeView(onView:UIView,val:CGFloat = 0.33)->(UIView,NSLayoutConstraint?){
         let timeParentView = UIView()
         var timePArentHeightConstraint:NSLayoutConstraint?
         onView.addSubview(timeParentView)
         timeParentView.anchor(nil, left: onView.leftAnchor, bottom: onView.bottomAnchor, right: onView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -onView.frame.height*val, rightConstant: 0, widthConstant: 0, heightConstant: onView.frame.height*val)
         if let btmConst = onView.constraints.first(where: { $0.identifier == "btmConst" }) {
            timePArentHeightConstraint = btmConst
         }
         return (timeParentView,timePArentHeightConstraint)
     }
    
    func animateConstraint(constraint: NSLayoutConstraint?, to value: CGFloat) {
        guard let constraint = constraint else {
            print("Constraint is nil")
            return
        }

        guard let view = self.view, view.superview != nil else {
            print("View is not in the view hierarchy")
            return
        }

        DispatchQueue.main.async {
            constraint.constant = value
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    var isDarkModeEnabled: Bool {
        get {
            if #available(iOS 12.0, *) {
                return traitCollection.userInterfaceStyle == .dark
            } else {
                return false
            }
        }
    }
    
    class func topMostViewController() -> UIViewController? {
        
        var topController = UIApplication.keyWindow?.rootViewController

        while true {
            if let presented = topController?.presentedViewController {
                topController = presented
            } else if let nav = topController as? UINavigationController {
                topController = nav.visibleViewController
            } else if let tab = topController as? UITabBarController {
                topController = tab.selectedViewController
            } else {
                break
            }
        }
        
        return topController
    }
}
