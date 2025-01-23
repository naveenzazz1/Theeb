//
//  ViewController+KeyBoardHandling.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/10/1443 AH.
//


import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func shouldPresentLoadingView(_ status:Bool){
        var fadeView:UIView
        if status {
            if Holder._myComputedProperty{
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            fadeView.alpha = 0.0
            fadeView.tag = 991
            let spinner = UIActivityIndicatorView() //spinner
            spinner.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            spinner.style = .large
            spinner.center = view.center
            view.addSubview(fadeView)//7atenah el 2awel fa hyro7 lel backGround
            fadeView.addSubview(spinner) //hayet7at fo2 el fadeView
            fadeView.fadeTo(alphaValue: 0.7, withDuration: 0.3)
            spinner.startAnimating()
            Holder._myComputedProperty = false
            }
        }else {
            Holder._myComputedProperty = true
            for subview in view.subviews {
                if subview.tag == 991 {
                    UIView.animate(withDuration: 0.3, animations: {
                        subview.alpha = 0.0
                        
                    }, completion: { (finish) in
                        subview.removeFromSuperview() //elspinner hayetshal ma3a el fadeview
                    })
                }
            }
        }
    }
    
    struct Holder {
        static var _myComputedProperty:Bool = true
    }
}
