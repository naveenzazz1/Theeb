//
//  TransParentNavigationController.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 08/06/1443 AH.
//

import UIKit

class TransparentNavigationController: UINavigationController {

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       applyTransparentNavigationBar()
    }
}
