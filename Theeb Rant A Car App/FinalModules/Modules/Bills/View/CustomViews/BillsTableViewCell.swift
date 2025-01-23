//
//  BillsTableViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 23/08/1443 AH.
//

import UIKit
import Firebase


protocol BillsTableViewCellDelegate: class {
        func showLoadingInCell(_ cell: BillsTableViewCell)
        func hildeLoadingInisdeCell()
}

class BillsTableViewCell: UITableViewCell {

    
    
    // MARK: - Outlets
    weak var delegate: BillsTableViewCellDelegate?
    
    @IBOutlet weak var shareBtn: LoadingButton!
    @IBOutlet weak var lblStaticVat: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var pickupBranchLabel: UILabel!
    @IBOutlet weak var contractNumberLabel: UILabel!
    @IBOutlet weak var viewDetailsButton: UIButton!
    @IBOutlet weak var viewDetailsView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var toDateTimeLabel: UILabel!
    @IBOutlet weak var fromDateTimeLabel: UILabel!
    @IBOutlet weak var paynowBtn: UIButton! {
        didSet {
            paynowBtn.isHidden = true
            paynowBtn.setTitle("rental_payNow".localized, for: .normal) 
        }
    }
    
    
    // MARK: - Actions
    var payNowAction: (() -> ())?
    var viewDetailsAction: (() -> ())?
    var shareButtonAction: (() -> ())?
    
    let paymentFlag = "payment_disabled"
    
    // MARK: - Populate Data

    func showInvoice(_ invoice : InvoiceJson?,isUnpaid:Bool) {

        let totalInvoice = Double(invoice?.invoiceTotal ?? "0") ?? 0.0
        
        let totalPaidInvoice = Double(invoice?.invoiceAmountPaid ?? "0") ?? 0.0
       
        let amountTopay = (totalInvoice - totalPaidInvoice)

        print(totalInvoice)
        print(totalPaidInvoice)
        print(amountTopay)
        paynowBtn.isHidden = (Double(invoice?.invoiceBalance ?? "0") ?? 0.0 > 0 ) ? false : true
        paynowBtn.setTitle("rental_payNow".localized, for: .normal)
        if amountTopay > 0 {
           // totalAmountLabel.text = String(format: " %@ \("sar".localized)","\(amountTopay.toFormattedString ?? "")")
            
            totalAmountLabel.text = String(format: " %@ \("sar".localized)","\(invoice?.invoiceBalance ?? "")")
        } else {
          //  totalAmountLabel.text = String(format: " %@ \("sar".localized)","\(totalInvoice.toFormattedString ?? "")")
            totalAmountLabel.text = String(format: " %@ \("sar".localized)","\(invoice?.invoiceBalance ?? "")")
        }
        
        
        carModelLabel.text = invoice?.invoiceAgrCarModel
        pickupBranchLabel.text = invoice?.invoiceAgrOutBranch
        contractNumberLabel.text = String(format: "\("fleet_contractNumber".localized) : %@","\(invoice?.invoiceNo ?? "")")
        fromDateTimeLabel.text =  String(format: "\("renalhistory_from_label".localized) : %@ \("checkout_at".localized) %@ ","\(invoice?.invoiceAgrOutDate ?? "")" ,"\(invoice?.invoiceAgrOutTime ?? "")")
        
        toDateTimeLabel.text = String(format: "\("renalhistory_to_label".localized): %@ \("checkout_at".localized) %@ ","\(invoice?.invoiceAgrInDate ?? "")" ,"\(invoice?.invoiceAgrInTime ?? "")")
       

        viewDetailsButton.setTitle("rental_viewDetails".localized, for: .normal)
        imgArrow.image = UIImage(named: "ArrowLine")
        imgArrow.tintColor = .theebPrimaryColor

        lblStaticVat.text = "fleet_vat_included".localized
        
    }
    

    
    @IBAction func viewDetailsBtnAction(_ sender: Any) {
        
        viewDetailsAction?()
    }
    
    @IBAction func shareBillAction(_ sender: Any) {
        
        shareButtonAction?()
        
    }
    
    //MARK: - maintenanc check
    
    func checkPaymentIsDisable() -> Bool {
        var result = false
        let remoteConfig = RemoteConfig.remoteConfig()
        if let paymentRequiredDic = remoteConfig[paymentFlag].jsonValue as? [String : AnyObject] {
            if  let is_Disabled = paymentRequiredDic["is_disabled"] as? Bool {
                if is_Disabled {
                    let msg = (UIApplication.isRTL()) ? paymentRequiredDic["disabled_message_ar"] as? String : paymentRequiredDic["disabled_message_en"] as? String
                    let title = (UIApplication.isRTL()) ? paymentRequiredDic["disabled_title_ar"] as? String : paymentRequiredDic["disabled_title_en"] as? String
                    result = true
                    alertUser(title: title ?? "", msg: msg ?? "")
                   // alertUser(title: title ?? "maintenace_alert_title".localized, msg: msg ?? "maintenace_alert_msg".localized)
                }
            }
        }
        return result
    }
    
    private func alertUser(title: String, msg: String){
        CustomAlertController.initialization().showAlertWithOkButton(title: title ,message: msg) { (index, title) in
             print(index,title,msg)
        }
     }
    @IBAction func paynowAction(_ sender: Any) {
        if !checkPaymentIsDisable() {
            payNowAction?()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
   
  
    
    
}


