//
//  ImagePopUpView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 23/08/2022.
//

import UIKit

protocol ImagePopUpViewDelegate{
   func btnCloseDelegatePressed()
}

class ImagePopUpView: UIView {
    
    var delegate:ImagePopUpViewDelegate?

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgViewDoc: UIImageView!
  
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialSetup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    func initialSetup() {
        addSubview(loadXibView(with: bounds))
        btnClose.addTarget(self, action: #selector(btnClosePessed), for: .touchUpInside)
    }

    @objc func btnClosePessed(){
        delegate?.btnCloseDelegatePressed()
    }
}
