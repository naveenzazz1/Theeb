//
//  NotificationHistroryCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 05/01/2024.
//

import UIKit

class NotificationHistroryCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var identifier:String {
       String(describing: NotificationHistroryCell.self)
    }
    
    func setup(notification: Messages?) {
        lblBody.text = notification?.body ?? ""
        lblTitle.text = notification?.title ?? ""
        lblDate.text = notification?.date?.replacingOccurrences(of: "T", with: "  ") ?? ""
    }
    
}
