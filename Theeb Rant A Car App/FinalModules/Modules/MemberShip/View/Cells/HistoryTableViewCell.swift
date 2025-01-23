//
//  HistoryTableViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 26/04/2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBullet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    static var identifier:String {
       String(describing: MemberDetailCell.self)
    }
    
    func setupCell(transaction: LoyaltyConversionTransactions) {
        let date = DateUtils.dateFromString(transaction.requestDate, format: "yyyyMMdd")
        lblDate.text = DateUtils.stringFromDate(date, format: "dd/MM/yyyy")
        lblMiles.text = String(transaction.convertedPoints ?? 0)
        lblPoints.text = String(transaction.pointsToConvert ?? 0)
        formStatus(status: transaction.status ?? 0)
    }
    
    private func formStatus(status: Int){
        var color = UIColor.orange
        var statusString = "N/A"
        switch status {
        case 4:
            color = .green
            statusString = "status_Approved".localized
        case 5:
            color = .red
            statusString = "status_Declined".localized
        default:
            break
        }
       let mainAttibutedString = NSAttributedString(string: "\u{2022}",
                                                    attributes: [.foregroundColor: color, .font: UIFont.BahijTheSansArabicSemiBold(fontSize: 16) ?? UIFont.systemFont(ofSize: 16)])
        lblBullet.attributedText = mainAttibutedString
        lblStatus.text = statusString
    }
    
    func setHeader(){
        lblBullet.isHidden = true
        lblDate.text = "date_Column".localized
        lblPoints.text = "points_column".localized
        lblMiles.text = "miles_column".localized
        lblStatus.text = "status_column".localized
        [lblDate,lblMiles,lblPoints,lblStatus].forEach{
            $0?.font = UIFont.BahijTheSansArabicSemiBold(fontSize: 18) ?? UIFont.boldSystemFont(ofSize: 16)
            $0?.textColor = UIColor.weemBlack
        }
    }
}
