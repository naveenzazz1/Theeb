//
//  SettingCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 01/04/2022.
//

import UIKit

class SettingCell: UITableViewCell {
    
    //vars
    var actionSegmented: ((_ sgmnt:UIControl?)-> Void)?

    @IBOutlet weak var segmentedSetting: UISegmentedControl!
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var imgSetting: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillSegmnt(sgmntTuble:(String?,String?,String?)?){
        
        segmentedSetting.setTitle(sgmntTuble?.0, forSegmentAt: 0)
        segmentedSetting.setTitle(sgmntTuble?.1, forSegmentAt: 1)
        if let sgmntTubleFr = sgmntTuble?.2 {
            segmentedSetting.insertSegment(withTitle: sgmntTubleFr, at: 2, animated: true)
        }
    }
    
    static var identifier:String {
       String(describing: TemplateCell.self)
    }
    
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        actionSegmented?(sender)
    }
}
