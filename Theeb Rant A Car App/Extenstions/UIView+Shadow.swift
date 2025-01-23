//
//  UIView+Shadow.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/07/1443 AH.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
            layer.masksToBounds = false
        }
        get {

            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
}

import UIKit

extension UINavigationController {

    func applyTransparentNavigationBar() {

//        navigationBar.bounds = navigationBar.bounds.insetBy(dx: 0, dy: -10.0)
        navigationBar.isTranslucent = true
        navigationBar.isOpaque = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .black
        navigationBar.barTintColor = .clear
        navigationBar.shadowOpacity = 0.0
        view.backgroundColor = .clear
    }
    
    func applyGrayNavigationBar() {
        
    //    navigationBar.setBackgroundImage(UIImage(color: .weemGrayNavigationBarColor), for: .default)
     //   navigationBar.setBackgroundImage(UIImage(c), for: .default)

//        navigationBar.setBackgroundImage(UIImage(named: "Navigation Background"), for: .default)
        navigationBar.setBackgroundImage(UIImage(), for: .default)

        navigationBar.shadowColor = .white
        navigationBar.shadowOpacity = 1.0
        navigationBar.shadowOffset = CGSize(width: 0, height: 5)
        navigationBar.shadowRadius = 6
    }
}
