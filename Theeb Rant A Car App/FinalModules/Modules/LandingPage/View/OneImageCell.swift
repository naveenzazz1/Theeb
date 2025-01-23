//
//  OneImageCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 05/04/2022.
//

import UIKit

protocol OneImageDelegate{
    func actionOfBtnNext()
}

class OneImageCell: UICollectionViewCell {

    //vars
    var delegate:OneImageDelegate?
    //outlet
    @IBOutlet weak var imgViewMain: UIImageView!
    @IBOutlet weak var btnNext: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnNext.addTarget(self, action: #selector(btnNextPressed(_:)), for: .touchUpInside)
        btnNext.setTitle("forget_password_next_button_title".localized, for: .normal)
        btnNext.setImage(UIImage(named: "arrowRightLine"), for: .normal)
    }

    static var identifier:String {
       String(describing: OneImageCell.self)
    }
    
    @objc func btnNextPressed(_ btn:UIButton){
        delegate?.actionOfBtnNext()
    }
    

}
