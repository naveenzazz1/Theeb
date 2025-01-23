//
//  BookingHistoryTableViewCell.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/07/1443 AH.
//

import UIKit
import AlamofireImage
import Firebase

class BookingHistoryTableViewCell : UITableViewCell {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var imgArrow: UIImageView!{
        didSet{
            imgArrow.image = UIImage(named: "ArrowLine")
            imgArrow.tintColor = .theebPrimaryColor

        }
    }
    
    let paymentFlag = "payment_disabled"
    
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var firstStatusView: UIView!
    @IBOutlet weak var firstStatusLine: UIImageView!
    @IBOutlet weak var firstStatusHintLabel: UILabel!
    @IBOutlet weak var firstStatusImageView: UIImageView!
    
    
    @IBOutlet weak var secondStatusView: UIView!
    @IBOutlet weak var secondStatusHintLabel: UILabel!
    @IBOutlet weak var secondStatusLine: UIImageView!
    @IBOutlet weak var secondStatusImageView: UIImageView!
    
    
    @IBOutlet weak var thirdStatusView: UIView!
    @IBOutlet weak var thirdStatusHintLabel: UILabel!
    @IBOutlet weak var thirdStatusImageView: UIImageView!
    
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var fromLabel: UILabel! {
        didSet {
            
            fromLabel.text = "renalhistory_from_label" .localized
        }
    }
    @IBOutlet weak var toLabel: UILabel! {
        didSet {
            toLabel.text =  "renalhistory_to_label" .localized
        }
    }
    @IBOutlet weak var carImageView: UIImageView!

    @IBOutlet weak var dropOffDateTimeLabel: UILabel!
    @IBOutlet weak var pricukuptDateTimeLabel: UILabel!
    @IBOutlet weak var pickupBranchLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hintVatLabel: UILabel!{
        didSet{
            hintVatLabel.text = "payment_total".localized
        }
    }
    @IBOutlet weak var modelLabel: UILabel!
    
    var payNowAction: (() -> ())?
    var viewDetailsAction: (() -> ())?
    
    func showContact(_  contract : Agreement?, rentalItem : RentalItem? = nil, status : String? = nil) {
        
      //  removeInputView(view: actionsView )
        payBtn.isHidden = true
        
        self.updateToContractTheme(contract)
        
        let datepickup =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: contract?.checkOutDate)
            let datereturn =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: contract?.checkInDate)
        pricukuptDateTimeLabel.text =  "\(datepickup ?? "") \(contract?.agreementCheckOutTime ?? "")"
        dropOffDateTimeLabel.text =  "\(datereturn ?? "")"
        pickupBranchLabel.text = "\(contract?.checkOutBranch ?? "")"
        modelLabel.text =  "\(contract?.agreementModelName  ?? "")"
        priceLabel.text = "\(contract?.tOTALAMOUNT  ?? "")\( "sar".localized)"
        
    }
    
    
    
    func showInvoice(_  invoice : InvoiceRentalHistoryModel?, status : String? = nil) {
        
     
        updateToInvoicesTheme(invoice: invoice)
        
        let datepickup =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: invoice?.invoiceAgrOutDate )
            let datereturn =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: invoice?.invoiceAgrInDate)
        pricukuptDateTimeLabel.text =  "\(datepickup ?? "") \(invoice?.invoiceAgrOutTime ?? "")"
        dropOffDateTimeLabel.text =  "\(datereturn ?? "") \(invoice?.invoiceAgrInTime ?? "")"
        pickupBranchLabel.text = "\(invoice?.invoiceAgrOutBranch ?? "")"
        modelLabel.text =  "\(invoice?.invoiceAgrCarModel  ?? "")"
        priceLabel.text = "\(invoice?.invoiceTotal ?? "")\( "sar".localized)"
        
    }
    
    func showBooking(_  booking : Reservation?, status : String? = nil) {
        
        let rentalTotalAmount = Double(booking?.totalWithTax  ?? "") ?? 0
        let rentalPaidAmount =  Double(booking?.totalPaid  ?? "") ?? 0
        let remainingAmount = rentalTotalAmount - rentalPaidAmount
        self.makeVeiwConfirmed(booking: booking, status)
        carImageView.image = nil
        
        if let imageUrlString = booking?.carGroup,
           let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") {
            
            carImageView.af.setImage(withURL: imageUrl)
        }
        let datepickup =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: booking?.checkOutDate)
            let datereturn =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: booking?.checkInDate)
        pricukuptDateTimeLabel.text =  "\(datepickup ?? "") \(booking?.checkOutTime ?? "")"
        dropOffDateTimeLabel.text =  "\(datereturn ?? "") \(booking?.checkInTime ?? "")"
        pickupBranchLabel.text = "\(booking?.checkOutBranch ?? "")"
        modelLabel.text =  "\(booking?.carGroupDescription  ?? "")"
        priceLabel.text = "\(remainingAmount.roundedToTwoDecimalPlaces())\( "sar".localized)"
    }
    
    //MARK: - ViewLifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
   
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    }
    
    //MARK: - Helper Methods
    
    
    func removeInputView(view: UIView) {
        
        containerStackView.removeArrangedSubview(view)
        view.isHidden = true
    }
    
    func addInputView(view: UIView, atIndex index: Int) {
        
        containerStackView.insertArrangedSubview(view, at: index)
        view.isHidden = false
    }
    
    func showRentalItem(rentalItem : RentalItem?) {
        
        let rentalTotalAmount = Double(rentalItem?.totalAmount  ?? "") ?? 0
        let rentalPaidAmount =  Double(rentalItem?.totalPaid  ?? "") ?? 0
        let remainingAmount = rentalTotalAmount - rentalPaidAmount
        if rentalItem?.isBooking ?? false {
            
            self.makeVeiwConfirmedRentalItme(rentalItem: rentalItem, rentalItem?.status)
            carImageView.image = nil
            
            if let imageUrlString = rentalItem?.carImage,
               let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") {
                
                carImageView.af.setImage(withURL: imageUrl)
            }
        let datepickup =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: rentalItem?.returnDate)
            let datereturn =     DateUtils.GetDateOnlyFromFullDate(originalFormat: DateFormats.DateOnly, convertedFormat: DateFormats.FullDateex, dateString: rentalItem?.pickupDate)
            pricukuptDateTimeLabel.text =  "\(datereturn ?? "") \(rentalItem?.pickTime ?? "")"
            dropOffDateTimeLabel.text =  "\(datepickup ?? "") \(rentalItem?.pickTime ?? "")"
            pickupBranchLabel.text = "\(rentalItem?.pickupBranch ?? "")"
            modelLabel.text =  "\(rentalItem?.carModel  ?? "")"
            let rentalTotalAmount = Double(rentalItem?.totalAmount  ?? "")
            let rentalPaidAmount =  Double(rentalItem?.totalPaid  ?? "")
            priceLabel.text = "\(remainingAmount.roundedToTwoDecimalPlaces())\( "sar".localized)"
            
            
        } else if rentalItem?.isContract ?? false {
            updateToContractTheme(rentalItem)
            pricukuptDateTimeLabel.text =  "\(rentalItem?.returnDate ?? "") \(rentalItem?.pickTime ?? "")"
            dropOffDateTimeLabel.text =  "\(rentalItem?.pickupDate ?? "") \(rentalItem?.returnTime ?? "")"
            pickupBranchLabel.text = "\(rentalItem?.pickupBranch ?? "")"
            modelLabel.text =  "\(rentalItem?.carModel  ?? "")"
            priceLabel.text = "\(rentalItem?.totalAmount  ?? "")\( "sar".localized)"
            
        }  else if rentalItem?.isInvoice ?? false {
            
            updateToInvoicesTheme(rentalItem: rentalItem)
            pricukuptDateTimeLabel.text =  "\(rentalItem?.pickupDate ?? "") \(rentalItem?.pickTime ?? "")"
            dropOffDateTimeLabel.text =  "\(rentalItem?.returnDate ?? "") \(rentalItem?.returnTime ?? "")"
            pickupBranchLabel.text = "\(rentalItem?.pickupBranch ?? "")"
            modelLabel.text =  "\(rentalItem?.carModel  ?? "")"
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Locale(identifier: "de")
            let totalInvoice = Double(rentalItem?.totalInvoice ?? "") ?? 0
            let totalPaidInvoice =  Double(rentalItem?.totalPaidInvoice ?? "") ?? 0
           
            let amountTopay = totalInvoice - totalPaidInvoice
            if amountTopay > 0 {
                priceLabel.text = "\( amountTopay)\( "sar".localized)"
            } else {
                priceLabel.text = "\( totalInvoice)\( "sar".localized)"
            }
          
            
            
            
        }
        
        viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
    }
    
    
    func  updateToInvoicesTheme(invoice : InvoiceRentalHistoryModel?) {
        payBtn.isHidden = true
     //   removeInputView(view: actionsView)
        if   Double("\(invoice?.invoiceBalance ?? "")") ?? 0.0  >  0.0 {
            //addInputView(view: actionsView, atIndex: 3)
          
            payBtn.isHidden = false
            payBtn.setTitle("rental_payNow".localized, for: .normal)
        }
        firstStatusLine.image = UIImage(named: "LineUpaidInvoice")
        firstStatusImageView.image = UIImage(named: "InvoiceUpaidIcon")
        firstStatusHintLabel.text = "rental_BookingstatusConfirmed".localized
        
        secondStatusImageView.image = UIImage(named: "InvoiceUpaidIcon")
        secondStatusHintLabel.text  = "\("rental_carWithYou".localized) \(invoice?.invoiceAgrOutDate ?? "")"
        secondStatusLine.image = UIImage(named: "LineUpaidInvoice")
        
        viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
        thirdStatusImageView.image = UIImage(named: "InvoiceUpaidIcon")
        thirdStatusHintLabel.text = "\("rental_carReturned".localized)"
        
        
        
    }
    
    func  updateToInvoicesTheme(rentalItem : RentalItem?) {
        
        payBtn.isHidden = true
       // removeInputView(view: actionsView)
        if  Double("\(rentalItem?.totalBalance ?? "")") ?? 0.0  >  0.0{
           
            payBtn.isHidden = false
            payBtn.setTitle("rental_payNow".localized, for: .normal)
            //addInputView(view: actionsView, atIndex: 3)
        }
        firstStatusLine.image = UIImage(named: "LineUpaidInvoice")
        firstStatusImageView.image = UIImage(named: "InvoiceUpaidIcon")
        firstStatusHintLabel.text = "rental_BookingstatusConfirmed".localized
        
        secondStatusImageView.image = UIImage(named: "InvoiceUpaidIcon")
        secondStatusHintLabel.text  = "\("rental_carWithYou".localized) \(rentalItem?.pickupDate ?? "")"
        secondStatusLine.image = UIImage(named: "LineUpaidInvoice")
        
        thirdStatusImageView.image = UIImage(named: "InvoiceUpaidIcon")
        thirdStatusHintLabel.text = "\("rental_carReturned".localized)"
        
        viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
        
    }
    
    
    func updateToContractTheme(_ contract :Agreement? ) {
        
        payBtn.isHidden = true
      //  removeInputView(view: actionsView)
        firstStatusLine.image = UIImage(named: "GreenLineImge")
        firstStatusImageView.image = UIImage(named: "SuccessStatusImage")
        firstStatusHintLabel.text = "rental_BookingstatusConfirmed".localized
        
        secondStatusImageView.image = UIImage(named: "SuccessStatusImage")
        secondStatusHintLabel.text  = "\("rental_carWithYou".localized) \(contract?.checkOutDate ?? "")"
        secondStatusLine.image = UIImage(named: "GreenLineImge")
   
        thirdStatusImageView.image = UIImage(named: "SuccessStatusImage")
        
        thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(contract?.checkInDate ?? "")"
        
    }
    
    func updateToContractTheme(_ rentalItem :RentalItem? ) {
        
        
        payBtn.isHidden = true
       // removeInputView(view: actionsView)
        firstStatusLine.image = UIImage(named: "GreenLineImge")
        firstStatusImageView.image = UIImage(named: "SuccessStatusImage")
        firstStatusHintLabel.text = "rental_BookingstatusConfirmed".localized
        payBtn.setTitle("rental_payNow".localized, for: .normal)
        viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
        secondStatusImageView.image = UIImage(named: "SuccessStatusImage")
        secondStatusHintLabel.text  = "\("rental_carWithYou".localized) \(rentalItem?.returnDate ?? "")"
        secondStatusLine.image = UIImage(named: "GreenLineImge")
        
        thirdStatusImageView.image = UIImage(named: "CarWithYouForContractpdf")
        
        thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(rentalItem?.pickupDate ?? "")"
        
    }
    
    func makeVeiwConfirmed(booking :Reservation? ,_ withStatus: String?) {
        
        
        
        switch withStatus {
            
        case BookingsStatuses.Confirmed:
            payBtn.isHidden = true
           // removeInputView(view: actionsView)
            if Double("\(booking?.totalPaid ?? "")") ?? 0.0 < Double("\(booking?.totalWithTax ?? "")") ?? 0.0 {
               
                payBtn.isHidden = false
                payBtn.setTitle("rental_payNow".localized, for: .normal)
                //addInputView(view: actionsView, atIndex: 3)
            }
            
            firstStatusLine.image = UIImage(named: "GreenLineImge")
            firstStatusImageView.image = UIImage(named: "SuccessStatusImage")
            firstStatusHintLabel.text = "rental_BookingstatusConfirmed".localized
            
            secondStatusImageView.image = UIImage(named: "UnDefinedIcon")
            secondStatusHintLabel.text  = "\("rental_caravAilable".localized) \(booking?.checkOutDate ?? "")"
            secondStatusLine.image = UIImage(named: "statusSperatorLine")
            
            thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(booking?.checkInDate ?? "")"
            thirdStatusImageView.image = UIImage(named: "UnDefinedIcon")
            
            viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
            
            guard let pickupDate = booking?.checkOutDate?.toDate() else { return}
            if (Date()).isGreaterThan(pickupDate) {
                secondStatusImageView.image = UIImage(named: "SuccessStatusImage")
                
            }
            
            guard let returnDate = booking?.checkInDate?.toDate() else { return}
            if (Date()).isGreaterThan(returnDate) {
                secondStatusLine.image = UIImage(named: "GreenLineImge")
                thirdStatusImageView.image = UIImage(named: "SuccessStatusImage")
                
            }
            
            
        case BookingsStatuses.Cancelled:
            
          //  removeInputView(view: actionsView)
            payBtn.isHidden = true
            firstStatusImageView.image = UIImage(named: "CancelledIcon")
            firstStatusHintLabel.text = "rental_BookingstatusCanceled".localized
            firstStatusLine.image = UIImage(named: "statusSperatorLine")
            secondStatusImageView.image = UIImage(named: "UnDefinedIcon")
            secondStatusHintLabel.text  = "\("rental_caravAilable".localized)\(booking?.checkOutDate ?? "")"
            secondStatusLine.image = UIImage(named: "statusSperatorLine")
            thirdStatusImageView.image = UIImage(named: "UnDefinedIcon")
            thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(booking?.checkInDate ?? "")"
            viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
            
        case BookingsStatuses.Open:
            
            
            payBtn.isHidden = true
          //  removeInputView(view: actionsView)
           
            firstStatusImageView.image = UIImage(named: "WaitingForConfirmationIcon")
            firstStatusHintLabel.text = "rental_Bookingstatuswaiting".localized
            firstStatusLine.image = UIImage(named: "statusSperatorLine")
            secondStatusImageView.image = UIImage(named: "UnDefinedIcon")
            secondStatusHintLabel.text  = "\("rental_caravAilable".localized)\(booking?.checkOutDate ?? "")"
            secondStatusLine.image = UIImage(named: "statusSperatorLine")
            thirdStatusImageView.image = UIImage(named: "UnDefinedIcon")
            thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(booking?.checkInDate ?? "")"
            viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
            
            
        default:
            break
        }
        
        
    }
    
    func makeVeiwConfirmedRentalItme(rentalItem :RentalItem? ,_ withStatus: String?) {
        
        
        
        switch withStatus {
            
        case BookingsStatuses.Confirmed:
            payBtn.isHidden = true
         //   removeInputView(view: actionsView)
            if (rentalItem?.totalPaid!)! < (rentalItem?.totalAmount)! {
               // addInputView(view: actionsView, atIndex: 3)
               
                payBtn.isHidden = false
                payBtn.setTitle("rental_payNow".localized, for: .normal)
            }
            viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
            firstStatusLine.image = UIImage(named: "GreenLineImge")
            firstStatusImageView.image = UIImage(named: "SuccessStatusImage")
            firstStatusHintLabel.text = "rental_BookingstatusConfirmed".localized
            
            secondStatusImageView.image = UIImage(named: "UnDefinedIcon")
            secondStatusHintLabel.text  = "\("rental_caravAilable".localized) \(rentalItem?.pickupDate ?? "")"
            secondStatusLine.image = UIImage(named: "statusSperatorLine")
            
            thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(rentalItem?.returnDate ?? "")"
            thirdStatusImageView.image = UIImage(named: "UnDefinedIcon")
            guard let pickupDate = rentalItem?.pickupDate?.toDate() else { return}
            if (Date()).isGreaterThan(pickupDate) {
                secondStatusImageView.image = UIImage(named: "SuccessStatusImage")
                
            }
            
            guard let returnDate = rentalItem?.returnDate?.toDate() else { return}
            if (Date()).isGreaterThan(returnDate) {
                secondStatusLine.image = UIImage(named: "GreenLineImge")
                thirdStatusImageView.image = UIImage(named: "SuccessStatusImage")
                
            }
            
        case BookingsStatuses.Cancelled:
            payBtn.isHidden = true
            
            firstStatusImageView.image = UIImage(named: "CancelledIcon")
            firstStatusHintLabel.text = "rental_BookingstatusCanceled".localized
            firstStatusLine.image = UIImage(named: "statusSperatorLine")
            secondStatusImageView.image = UIImage(named: "UnDefinedIcon")
            secondStatusHintLabel.text  = "\("rental_caravAilable".localized) \(rentalItem?.pickupDate ?? "")"
            secondStatusLine.image = UIImage(named: "statusSperatorLine")
            thirdStatusImageView.image = UIImage(named: "UnDefinedIcon")
            thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(rentalItem?.returnDate ?? "")"
            viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
            
        case BookingsStatuses.Open:
            
            payBtn.isHidden = true
            firstStatusImageView.image = UIImage(named: "WaitingForConfirmationIcon")
            firstStatusHintLabel.text = "rental_Bookingstatuswaiting".localized
            firstStatusLine.image = UIImage(named: "statusSperatorLine")
            secondStatusImageView.image = UIImage(named: "UnDefinedIcon")
            secondStatusHintLabel.text  = "\("rental_caravAilable".localized) \(rentalItem?.pickupDate ?? "")"
            secondStatusLine.image = UIImage(named: "statusSperatorLine")
            thirdStatusImageView.image = UIImage(named: "UnDefinedIcon")
            thirdStatusHintLabel.text = "\("rental_carReturnOn".localized) \(rentalItem?.returnDate ?? "")"
            viewDetailsBtn.setTitle("rental_viewDetails".localized, for: .normal)
            
            
        default:
            break
        }
        
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func payBtnAction(_ sender: Any) {
        if !checkPaymentIsDisable() {
            payNowAction?()
            
        }
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
    
    @IBAction func viewDetailsBtnAction(_ sender: Any) {
        
        
        viewDetailsAction?()
        
        
        
    }
}



extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: self)
    }
}
