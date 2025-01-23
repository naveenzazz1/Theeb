//
//  ViewController.swift
//  Theeb Rant A Car App
//
//  Created by Moustafa Gadallah on 24/04/1443 AH.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


extension UIViewController {
    func openURL(withURL url : URL ){
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
