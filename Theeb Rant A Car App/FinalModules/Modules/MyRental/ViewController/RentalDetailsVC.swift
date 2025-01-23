//
//  RentalDetalsVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 22/03/2022.
//

import UIKit
import Firebase

class RentalDetailsVC:BaseViewController{

    //outlets
    
    
    @IBOutlet weak var paidAmountStack: UIStackView! {
       didSet {
           // paidAmountStack.isHidden = true
        }
    }
    
    
    @IBOutlet weak var paidAmountHintLabel: UILabel! {
        didSet {
            paidAmountHintLabel.text = "details_paid_amount_hint_label".localized
        }
    }
    
    @IBOutlet weak var paidAmountValueLabel: UILabel!
    @IBOutlet weak var lblStaticgoldemMembership: UILabel!
    @IBOutlet weak var lblStaticDefault: UILabel!
    @IBOutlet weak var lblStaticpointsAdded: UILabel! {
        didSet {
            lblStaticpointsAdded.isHidden  = true
        }
    }
//    @IBOutlet weak var lblStaticPayforFull: UILabel!
//    @IBOutlet weak var lblStaticPAyfotFirst: UILabel!
    @IBOutlet weak var stackViewBtnsConstraints: NSLayoutConstraint!
//    @IBOutlet weak var lblAddonChild: UILabel!
//    @IBOutlet weak var lblAddonsSeats: UILabel!
    @IBOutlet weak var lblMemberKilos: UILabel!{
        didSet {
            lblMemberKilos.text = MemberUtility.instance.freeKiloMeters
        }
    }
    @IBOutlet weak var stackDelivery: UIStackView!
    @IBOutlet weak var stackCarRental: UIStackView!
    @IBOutlet weak var lblInsurenceTypr: UILabel!
    @IBOutlet weak var stackVat: UIStackView!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var stackAddons: UIStackView!
    @IBOutlet weak var totalHintLbl: UILabel!
    @IBOutlet weak var stackMemberDiscount: UIStackView!
    @IBOutlet weak var vatValueLabel: UILabel!
    @IBOutlet weak var stackInsurance: UIStackView!
    @IBOutlet weak var vatHintLabel: UILabel!
    @IBOutlet weak var stackExtras: UIStackView!
    @IBOutlet weak var membershipDiscountValueLabel: UILabel!
    @IBOutlet weak var stackViewDetails: UIStackView!
    @IBOutlet weak var addonsValueLbl: UILabel!
    @IBOutlet weak var addonsHintLbl: UILabel!
    @IBOutlet weak var memberMainStack: UIStackView!
    @IBOutlet weak var insuranceValueLabel: UILabel!
    @IBOutlet weak var memberDetailsStack: UIStackView!
    @IBOutlet weak var memberShipHintLabel: UILabel!
    @IBOutlet weak var lblDeliveryFees: UILabel!
    @IBOutlet weak var extraFessValueLabel: UILabel!
    @IBOutlet weak var deliveryFeesHintLabel: UILabel!
    @IBOutlet weak var carRentalValueLabel: UILabel!
    @IBOutlet weak var carRentaValueLabel: UILabel!
    @IBOutlet weak var lblAcarType: UILabel!
    @IBOutlet weak var stackViewButtonPay: UIStackView!
    @IBOutlet weak var btnCancell: ButtonRounded!
    @IBOutlet weak var btnPAyNow: ButtonRounded!
    
    @IBOutlet weak var cancelationStackView: UIStackView!
    
//    @IBOutlet weak var lblFirstDayPay: UILabel!
//    @IBOutlet weak var lblPayForFull: UILabel!
    @IBOutlet weak var lblFreeKM: UILabel!{
        didSet{
            //lblFreeKM.text = MemberUtility.instance.getSumKmString(str1: "225", str2: CachingManager.memberDriverModel?.memberShip.freeKm ?? "0")
            lblFreeKM.text = MemberUtility.instance.getSumKmString(str1: "225", str2: CachingManager.memberDriverModel?.membership?.freeKM ?? "0")
        }
    }
    @IBOutlet weak var lblDefaultKM: UILabel!
    @IBOutlet weak var destinationView: DistenationView!
    @IBOutlet weak var carImgView: UIImageView!
    @IBOutlet weak var lblPaument: UILabel!
    @IBOutlet weak var lblStaticCancelaionPolicy: UILabel!
    @IBOutlet weak var lblStsticConfirmingPay: UILabel!
    @IBOutlet weak var lblStaticPaymentInformation: UILabel!
    @IBOutlet weak var lblStaticPaymentMethod: UILabel!
    @IBOutlet weak var lblStaticInsurance: UILabel!
    @IBOutlet weak var lblStaticChooseToPAy: UILabel!
    @IBOutlet weak var lblStaticAddons: UILabel!
    @IBOutlet weak var lblStaticPayBefore: UILabel!
    @IBOutlet weak var lblStatictotalFree: UILabel!
    @IBOutlet weak var lblStaticFreeKilos: UILabel!
    @IBOutlet weak var btnLuxury: UILabel!
    
    @IBOutlet weak var extraFessHintLabel: UILabel!
    @IBOutlet weak var insuranceHintLabel: UILabel!
    //var
    let paymentFlag = "payment_disabled"
    var rentalCase:RentalCase?
    var totalAmount = ""
    var invoiceNumber = ""
    var reservationNumber = ""
    var viewModel = RentalDetailsViewModel()
    var timeParentView:UIView?
    var timePArentHeightConstraint: NSLayoutConstraint!
    var paymentVC: PaymentVC?
    var isInvoicePaid = false
    var imageCar:UIImage?
    var isFromBills = false
    static var bookings = [Reservation?]()
    var currentPickupDate: String? = ""
    var currentReturnDate: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        carImgView.image = imageCar
    }
    
    func openPDFDocument(with url: URL) {
        
        let documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = self
        documentController.uti = "com.adobe.pdf";
        
        documentController.presentPreview(animated: true)
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            documentController.presentOptionsMenu(from: self.view.frame, in: self.view, animated: true)
        }
      

       
        

    }
    
    
    func setupViews(){
        title = getTitleLoaclized(rentalCase?.titleRental ?? "Car details")
        setupViewModel()
        btnCancell.addTarget(self, action: #selector(btnCancelPressed), for: .touchUpInside)
        btnPAyNow.addTarget(self, action: #selector(btnPayNowPressed), for: .touchUpInside)
        lblStaticAddons.text = "checkOutVC_addOns".localized
        lblStaticInsurance.text = "checkOutVC_insurance".localized
        lblStatictotalFree.text = "rental_totalFree".localized
        lblStaticFreeKilos.text = "rental_freeKilosToUse".localized
        //lblStaticPayBefore.text = "rental_payBefore".localized
        lblStaticPaymentMethod.text = "rental_paymentMethod".localized
        lblStaticPaymentInformation.text = "rental_paymentInfo".localized
        btnCancell.setTitle("country_picker_cancelBookingn".localized, for: .normal)
        MemberUtility.instance.setMemberLabel(lbl: lblStaticgoldemMembership)
//        {
//            DispatchQueue.main.async {
//                self.memberMainStack.removeInputView(view: self.memberDetailsStack)
//            }
//        }
     
        btnLuxury.text = "myRental_luxury".localized
        btnLuxury.layer.cornerRadius = 1.0
        btnPAyNow.setTitle("rental_payNow".localized, for: .normal)
        lblStaticCancelaionPolicy.text = "rental_cancelPolcy".localized
        lblStsticConfirmingPay.text = "rental_byConfirming".localized
        carRentaValueLabel.text = "rental_carRental".localized
        totalHintLbl.text = "rental_totalValue".localized
        vatHintLabel.text = "rental_vatValue".localized
        insuranceHintLabel.text = "checkOutVC_insurance".localized
        addonsHintLbl.text = "checkOutVC_addOns".localized
        deliveryFeesHintLabel.text = "renta_Delivery".localized
        memberShipHintLabel.text = "rental_memberShipDeiscount".localized
        extraFessHintLabel.text = "renta_extraFees".localized
        lblStaticDefault.text = "checkOut_default".localized
       // lblStaticpointsAdded.text = "rental_pointsAdded".localized
//        lblStaticPayforFull.text = "rental_PayForFull".localized
//        lblStaticPAyfotFirst.text = "rental_payForFirst".localized
//        lblAddonChild.text = "renta_ChildSeat".localized
//        lblAddonsSeats.text = "renta_ChildSeat".localized
        lblStaticChooseToPAy.text = "rental_howToPay".localized
        handleSharBtn()

   
    }
    
 
    func getTitleLoaclized(_ titleTolocalize:String)->String{
        switch titleTolocalize{
        case "Booking":
            return "rental_Booking".localized
        case "All":
            return "rental_all".localized
        case "Invoice":
            return isInvoicePaid ? "bills_paid_invoice".localized:"rental_invoice".localized
        case "Contracts":
            return "profile_item_contracts".localized
        default:
            return "Car Details".localized
        }
    }
    class func initializeFromStoryboard() -> RentalDetailsVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.MyRentalHistory, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! RentalDetailsVC
    }
    
    func handleSharBtn() {
        
        switch rentalCase{
        case .booking(val: let val):
            if let _ = val as? Reservation {
                
                let btnBarHelp = UIBarButtonItem(image: UIImage(named: "Shareitem"), style: .plain, target: self, action: #selector(btnSupportPressed))
               // paidAmountStack.isHidden = true
                btnBarHelp.tintColor = UIColor.theebSecondaryColor
                navigationItem.leftBarButtonItem?.tintColor = UIColor.theebSecondaryColor
                navigationItem.rightBarButtonItem = btnBarHelp
            }
        case .unpaid(val: let val):
            if let _ = val as? InvoiceRentalHistoryModel{
                let btnBarHelp = UIBarButtonItem(image: UIImage(named: "Shareitem"), style: .plain, target: self, action: #selector(btnSupportPressed))
                paidAmountStack.isHidden = false

                btnBarHelp.tintColor = UIColor.theebSecondaryColor
                navigationItem.leftBarButtonItem?.tintColor = UIColor.theebSecondaryColor
                navigationItem.rightBarButtonItem = btnBarHelp
            }
        case .contracts(val: let val):
            if let _ = val as? RentalHistoryModel {
                navigationItem.rightBarButtonItem = nil
             //   paidAmountStack.isHidden = true
            }
        case .all(val: let val):
            if let val = val as? RentalItem{
                if val.isContract == true {
                    navigationItem.rightBarButtonItem = nil
                } else {
                    let btnBarHelp = UIBarButtonItem(image: UIImage(named: "Shareitem"), style: .plain, target: self, action: #selector(btnSupportPressed))
                    btnBarHelp.tintColor = UIColor.theebSecondaryColor
                    navigationItem.leftBarButtonItem?.tintColor = UIColor.theebSecondaryColor
                    navigationItem.rightBarButtonItem = btnBarHelp
                }
                
            }
        default:
            break
        }
        
    }
    
    func setupViewModel() {
        
        viewModel.navigateToViewController = {[weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        viewModel.returnToMyBookings = { [weak self] in
            
            self?.navigationController?.popViewController(animated: true)
            
        }
        
        viewModel.openPDFWithURL = { [unowned self] (url) in
            
            self.openPDFDocument(with: url)
        }
        
        viewModel.fillBookingView = fillBookingDetails
        viewModel.fillInvoiceView = fillInvoiceDetails
        viewModel.fillContractView = fillContractDetails
        viewModel.fillAllViews = fillAllViewsDetails
        switch rentalCase{
        case .booking(val: let val):
            if let val = val as? Reservation {
                viewModel.fillBookingView?(val)
            }
        case .unpaid(val: let val):
            if let val = val as? InvoiceJson{
                viewModel.fillInvoiceView?(val)
            }
        case .contracts(val: let val):
            if let val = val as? Agreement{
                viewModel.fillContractView?(val)
            }
        case .all(val: let val):
            if let val = val as? RentalItem{
                viewModel.fillAllViews?(val)
            }
        default:
            break
        }
    }
    
    @objc func btnSupportPressed(){
        switch rentalCase{
        case .booking(val: let val):
            if let val = val as? Reservation{
                 
                
                viewModel.downloadInvoice(reservationNo: val.reservationNo, mode: "R", recieptAgreementNo: "", recieptInvoiceNumber: "")
            }
          
        case .unpaid(val: let val):
          
            if let val = val as? InvoiceRentalHistoryModel {
                
                viewModel.downloadInvoice(reservationNo: val.invoiceNo, mode: "I", recieptAgreementNo: "", recieptInvoiceNumber: "")
            }
        case .contracts(val: _):
        
            return
//            if let val = val as? RentalHistoryModel{
//                viewModel.downloadInvoice(reservationNo: val.reservationNo, mode: "P", recieptAgreementNo: val.agreementNo, recieptInvoiceNumber: val.agreementNo)
//            }
        case .all(val: let val):
            if let val = val as? RentalItem{
                if val.isBooking  ?? false {
                    viewModel.downloadInvoice(reservationNo: val.reservationNumber, mode: "R", recieptAgreementNo: "", recieptInvoiceNumber: "")
                } else if val.isInvoice ?? false {
                    viewModel.downloadInvoice(reservationNo: val.reservationNumber, mode: "I", recieptAgreementNo: "", recieptInvoiceNumber: "")
                }
            }
        default:
            break
        }
    }
    
    func setupLabels(totalPaid:String?,reservationStatus:String?,checkOutBranch:String?,checkInBranch:String?,rateName:String?,carGroupImagePath:String?,rentalSum:String?,extrasSum:String?,insuranceSum:String?,vataAmount:String?,vehTypeDesc:String?,memberShipVal:String?,extraFeesVal:String?,bookingNum:String?,pickupDate:String?,pickupTime:String?,returnDate:String?,returnTime:String?,deliveryFees:String?){
        //lblPayForFull.text = totalPaid
        lblPaument.text = reservationStatus
        currentPickupDate = pickupDate ?? ""
        currentReturnDate = returnDate ?? ""
        lblPaument.font = UIFont.MontserratBold(fontSize: 20)
        destinationView.lblDestination.text = checkOutBranch
        destinationView.lblSourceBranch.text = checkInBranch
        destinationView.lblBookingValue.text = bookingNum
        destinationView.reservationNum = bookingNum
        destinationView.lblPickup.text =  "rental_pickUpOn".localized + " \(pickupDate ?? "") \(pickupTime ?? "")"
        destinationView.lblReturn.text = "rental_resturnOn".localized + " \(returnDate ?? "") \(returnTime ?? "")"
        if let imageUrlString = carGroupImagePath,
           let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") ,isFromBills{
            carImgView.af.setImage(withURL: imageUrl)
//            DispatchQueue.global().async {
//                if let imgData = try? Data(contentsOf: imageUrl),let img = UIImage(data: imgData){
//                    DispatchQueue.main.async {
//                        self.carImgView.image = img
//                    }
//                }
//            }
        }
        lblStaticPayBefore.text = "\("rental_carSchadulaed".localized) \(pickupDate ?? "")"
        carRentalValueLabel.text = "\(rentalSum?.toFormattedString ?? "0")\("sar".localized)"
      //  if rentalSum == nil {stackViewDetails.removeInputView(view: stackCarRental)}
        addonsValueLbl.text =  "\(extrasSum?.toFormattedString ?? "0")\("sar".localized)"
      //  if extrasSum == nil {stackViewDetails.removeInputView(view: stackAddons)}
        insuranceValueLabel.text = "\(insuranceSum?.toFormattedString ?? "0")\("sar".localized)"
       // if insuranceSum == nil {stackViewDetails.removeInputView(view: stackInsurance)}
        totalValueLabel.text  = "\(totalPaid?.toFormattedString ?? "0")\("sar".localized)"
        
       
        
        vatValueLabel.text = "\(vataAmount?.toFormattedString ?? "0")\("sar".localized)"
     //   if vataAmount == nil {stackViewDetails.removeInputView(view: stackVat)}
        lblDeliveryFees.text = "\(deliveryFees?.toFormattedString ?? "0")\("sar".localized)"
        
        let membValue =  Double(memberShipVal  ?? "") ?? 0
        
        if membValue > 0 {
            membershipDiscountValueLabel.text = "\("- ")\(memberShipVal?.toFormattedString ?? "0")\("sar".localized)"
            
        } else {
            membershipDiscountValueLabel.text = "\(memberShipVal?.toFormattedString ?? "0")\("sar".localized)"
        }
   
       // if memberShipVal == nil {stackViewDetails.removeInputView(view: stackMemberDiscount)}
        extraFessValueLabel.text = "\(extraFeesVal?.toFormattedString ?? "0")\("sar".localized)"
        if extraFeesVal == nil {stackViewDetails.removeInputView(view: stackExtras)}
        lblAcarType.text = "\(vehTypeDesc ?? "")"
      
        
        
    }
    
    func fillBookingDetails(_ booking:Reservation){
      
       // formatter.locale = Locale.current // Locale(identifier: "de")
        let totalInvoice =  Double(booking.rentalCharge ?? "") ?? 0
        let totalPaidInvoice = Double(booking.totalDiscount ?? "") ?? 0
        let totalPaidAm = Double(booking.totalPaid ?? "0.0") ?? 0
        let totalAfterPaid = (Double(booking.totalWithTax ?? "0") ?? 0) - totalPaidAm
        let totalCarRenal = totalInvoice + totalPaidInvoice
        print(totalCarRenal)
        setupLabels(totalPaid: String(format: "%.2f", totalAfterPaid), reservationStatus: booking.reservationStatus, checkOutBranch: booking.checkOutBranch, checkInBranch: booking.checkInBranch, rateName: booking.rateName, carGroupImagePath: booking.carGroupImage, rentalSum: totalCarRenal.description, extrasSum: booking.extrasCharge, insuranceSum: booking.insuranceCharge, vataAmount: booking.salesTax, vehTypeDesc: booking.carGroupDescription,memberShipVal:booking.totalDiscount,extraFeesVal:booking.extrasCharge, bookingNum: booking.reservationNo,
                    pickupDate:booking.checkOutDate,
                    pickupTime:booking.checkOutTime,
                    returnDate:booking.checkInDate,
                    returnTime:booking.checkInTime, deliveryFees: booking.dropOffCharge)
        bookingViewBehave(reservationStatus: booking.reservationStatus, totalWithTax: booking.totalWithTax, totalPaid: booking.totalPaid)
        
        if totalPaidAm >  0 {
            paidAmountValueLabel.text =   "\("- ")\(booking.totalPaid?.toFormattedString ?? "0")\("sar".localized)"
        } else {
            paidAmountValueLabel.text =   "\(booking.totalPaid?.toFormattedString ?? "0")\("sar".localized)"
        }
      
        totalAmount = booking.totalWithTax ?? ""
    }
    
    func getExtrasChargeFromReservation(reserv:String)->(String?,String?)?{
        for item in Self.bookings{
            if item?.reservationNo == reserv{
                return (item?.extrasCharge,item?.insuranceCharge)
            }
        }
        return nil
    }
    
    func getImgeURlForInvoiceAndContract(urlString:String?)->String?{
        guard let carModelsArr = CachingManager.carModels() else {return nil}
        //,let carModel =  carModelsArr.filter({ $0?.group == urlString }).first as? CarModelObject
        var imgUrl:String?
        carModelsArr.forEach{
            if $0.group == urlString{
                imgUrl = $0.group
            }
        }
         return imgUrl
    }
    
    func fillInvoiceDetails(invoice:InvoiceJson){
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Locale(identifier: "de")
        let totalInvoice = Double(invoice.invoiceTotal ?? "") ?? 0
        let totalPaidInvoice =  Double(invoice.invoiceAmountPaid ?? "") ?? 0
       
        let amountTopay = totalInvoice - totalPaidInvoice
        if amountTopay == 0 {
            totalAmount = totalInvoice.description
        } else {
            totalAmount = amountTopay.description
        }
      
        let totalInvoiceB = Double (invoice.invoiceRental  ?? "") ?? 0
        let discountAmount =  Double(invoice.invoiceDiscountAmount  ?? "") ?? 0
        let rentalSum = totalInvoiceB + discountAmount
        invoiceNumber = invoice.invoiceNo ?? ""
        let extrasAndInsurence = getExtrasChargeFromReservation(reserv: invoice.invoiceReservation ?? "")
        setupLabels(totalPaid: totalAmount, reservationStatus: invoice.invoiceReservation, checkOutBranch: invoice.invoiceAgrOutBranch, checkInBranch: invoice.invoiceAgrInBranch, rateName: invoice.agreementRateNo, carGroupImagePath: getImgeURlForInvoiceAndContract(urlString: invoice.invoiceAgrChargeGroup) , rentalSum: rentalSum.description, extrasSum: extrasAndInsurence?.0, insuranceSum: extrasAndInsurence?.1,vataAmount: invoice.invoiceVat, vehTypeDesc: invoice.invoiceAgrCarModel,memberShipVal:invoice.invoiceDiscountAmount,extraFeesVal:extrasAndInsurence?.0, bookingNum: invoice.invoiceNo,
                    pickupDate:invoice.invoiceAgrOutDate,
                    pickupTime:invoice.invoiceAgrOutTime,
                    returnDate:invoice.invoiceAgrInDate,
                    returnTime:invoice.invoiceAgrInTime, deliveryFees: invoice.invoiceDropOff)
      
        if Double(invoice.invoiceBalance ?? "0") ?? 0 > 0{
        invoiceViewBehave()
        }else{
            contractViewBehave()
        }
        lblPaument.text = "rental_carReturned".localized
        destinationView.lblStaticBooking.text = "fleet_contractNumber".localized
        
        let padd = Double(invoice.invoiceAmountPaid ?? "") ??  0
        if padd > 0 {
            paidAmountValueLabel.text =   "\("- ")\(invoice.invoiceAmountPaid?.toFormattedString ?? "0")\("sar".localized)"
        } else {
            
            paidAmountValueLabel.text =   "\(invoice.invoiceAmountPaid?.toFormattedString ?? "0")\("sar".localized)"
        }
       

    }
    
    func fillAllViewsDetails(allDetail:RentalItem){
        
        var tempSum: String = ""
        let paid = Double(allDetail.totalPaid ?? "0") ?? 0
        if allDetail.isInvoice ?? false {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Locale(identifier: "de")
            let totalInvoice =  Double(allDetail.totalInvoice ?? "") ?? 0
            let totalRentalValue =  Double(allDetail.carRentalAmount ?? "") ?? 0
            let totalPaidInvoice = Double (allDetail.totalPaidInvoice ?? "") ?? 0
        let amountTopay = totalInvoice - totalPaidInvoice
            if amountTopay != 0 {
                totalAmount = amountTopay.description
            } else {
                totalAmount = totalInvoice.description
                
            }
          let discountAmount  =  Double(allDetail.discountAmount ?? "") ?? 0
            
            let rentalSum = totalRentalValue +  discountAmount
            tempSum = rentalSum.description
            if allDetail.isBooking ?? false {
                invoiceNumber = ""
                reservationNumber = allDetail.reservationNumber ?? ""
            } else if allDetail.isInvoice ?? false {
                invoiceNumber = allDetail.invoiceNumber ?? ""
                reservationNumber =  ""
            }
           
            
            paidAmountStack.isHidden = false
          
            setupLabels(totalPaid: totalAmount, reservationStatus: allDetail.status, checkOutBranch: allDetail.pickupBranch, checkInBranch: allDetail.returnBBranch, rateName: allDetail.rateName, carGroupImagePath: allDetail.carImage, rentalSum: rentalSum.description, extrasSum: allDetail.extraxSum, insuranceSum: allDetail.insuranceAmount, vataAmount: allDetail.vatAmount, vehTypeDesc: allDetail.carModel, memberShipVal: allDetail.discountAmount, extraFeesVal: allDetail.extraFeesVal, bookingNum: allDetail.reservationNumber,pickupDate:allDetail.pickupDate,pickupTime:allDetail.pickTime,returnDate:allDetail.returnDate,returnTime:allDetail.returnTime, deliveryFees: allDetail.deliveryFees)
            
           
        } else {
            
            let formatter = NumberFormatter()
           // formatter.locale = Locale.current // Locale(identifier: "de")
            let total =  Double(allDetail.carRentalAmount ?? "") ?? 0
            let discount = Double(allDetail.discountAmount ?? "") ?? 0
            let totalAfterPaid = (Double(allDetail.totalAmount ?? "0") ?? 0) - paid
            let rentalSum = total + discount
          //  tempSum = rentalSum.description
            reservationNumber = allDetail.reservationNumber ?? ""
            print(allDetail.carImage)
            let isContactFromAll = allDetail.isContract ?? false
            setupLabels(totalPaid: String(totalAfterPaid), reservationStatus: allDetail.status, checkOutBranch: allDetail.pickupBranch, checkInBranch: allDetail.returnBBranch, rateName: allDetail.rateName, carGroupImagePath: allDetail.carImage, rentalSum:rentalSum.description, extrasSum: allDetail.extraxSum, insuranceSum: allDetail.insuranceAmount, vataAmount: allDetail.vatAmount, vehTypeDesc: allDetail.carModel, memberShipVal: allDetail.discountAmount, extraFeesVal: allDetail.extraFeesVal, bookingNum: allDetail.reservationNumber,
                        pickupDate:isContactFromAll ? allDetail.returnDate:allDetail.pickupDate,
                        pickupTime:allDetail.pickTime,
                        returnDate:isContactFromAll ? allDetail.pickupDate:allDetail.returnDate,
                        returnTime:allDetail.returnTime, deliveryFees: allDetail.deliveryFees)
//            totalAmount = allDetail.totalAmount ?? ""
        }
      
        
        if paid > 0 {
            paidAmountValueLabel.text =   "\("- ")\(allDetail.totalPaid?.toFormattedString  ?? "0")\("sar".localized)"
        } else {
            
            paidAmountValueLabel.text =   "\(allDetail.totalPaid?.toFormattedString  ?? "0")\("sar".localized)"
        }
       
        if allDetail.isContract ?? false{
            contractViewBehave()
            lblPaument.text = "rental_youHaveCar".localized
          //  paidAmountStack.isHidden = true
            paymentVC?.isBooking = true
            destinationView.lblStaticBooking.text = "fleet_contractNumber".localized
        }
        if allDetail.isBooking ?? false{
            bookingViewBehave(reservationStatus: allDetail.status, totalWithTax: allDetail.totalAmount, totalPaid: allDetail.totalPaid)
            paymentVC?.isBooking = true
           // paidAmountStack.isHidden = true
        }
        if allDetail.isInvoice ?? false{
            invoiceViewBehave()
            paidAmountStack.isHidden = false
            paymentVC?.isInvoice = true
            paymentVC?.isBooking = false
            lblPaument.text = "rental_carReturned".localized
            destinationView.lblStaticBooking.text = "fleet_contractNumber".localized
        }
        
        let paiddA = Double(allDetail.totalPaid ?? "") ?? 0
        if paiddA > 0 {
            paidAmountValueLabel.text =   "\("- ")\(allDetail.totalPaid?.toFormattedString ?? "0")\("sar".localized)"
        }else {
            paidAmountValueLabel.text =   "\(allDetail.totalPaid?.toFormattedString ?? "0")\("sar".localized)"
        }
     

    }
    
    func fillContractDetails(contract:Agreement){
        
        let totalInvoice =  Double(contract.agreementTotalRental ?? "") ?? 0
        let totalPaidInvoice = Double(contract.agreementDiscount ?? "") ?? 0
        let paid = Double (contract.tOTALPAID ?? "") ?? 0
        let TotalAfterPaid = Double(contract.tOTALAMOUNT ?? "0") ?? 0 - paid
        let totalCarRenal = totalInvoice + totalPaidInvoice
        let extrasAndInsurence = getExtrasChargeFromReservation(reserv: contract.reservationNo ?? "")
        print(extrasAndInsurence)
        setupLabels(totalPaid: String(TotalAfterPaid), reservationStatus: contract.statusCode, checkOutBranch: contract.checkOutBranch, checkInBranch: contract.checkInBranch, rateName: contract.agreementModelName, carGroupImagePath: getImgeURlForInvoiceAndContract(urlString: contract.agreementChargeGroup), rentalSum: totalCarRenal.description, extrasSum: extrasAndInsurence?.0, insuranceSum: extrasAndInsurence?.1, vataAmount: nil, vehTypeDesc: contract.agreementModelName,memberShipVal:contract.agreementDiscount,extraFeesVal:extrasAndInsurence?.0, bookingNum: contract.reservationNo,
                    pickupDate:contract.checkOutDate,
                    pickupTime:nil,
                    returnDate:contract.checkInDate,
                    returnTime:nil, deliveryFees: contract.agreementDropOff)
        contractViewBehave()
        lblPaument.text = "rental_youHaveCar".localized
        if paid > 0 {
            paidAmountValueLabel.text =   "\("- ")\(contract.tOTALPAID?.toFormattedString ?? "0")\("sar".localized)"
        } else {
            paidAmountValueLabel.text =   "\(contract.tOTALPAID?.toFormattedString ?? "0")\("sar".localized)"
        }
     
    }
    
    func bookingViewBehave(reservationStatus:String?,totalWithTax:String?,totalPaid:String? ){
        self.totalAmount =  String((Double(totalWithTax ?? "0") ?? 0.0) - (Double(totalPaid ?? "0") ?? 0.0))
        switch reservationStatus {
            
            case BookingsStatuses.Confirmed:

            lblPaument.textColor = #colorLiteral(red: 0, green: 0.6689888835, blue: 0.4855584502, alpha: 1)
            cancelationStackView.isHidden = true
            if Double(totalPaid ?? "0") ?? 0.0 < Double(totalWithTax ?? "0") ?? 0.0{
                invoiceViewBehave()
            }else{
                contractViewBehave()

            }
              
           
        case BookingsStatuses.Cancelled:
            lblPaument.textColor = #colorLiteral(red: 0.8595502973, green: 0.2179158032, blue: 0.2922554612, alpha: 1)
            cancelationStackView.isHidden = true
            contractViewBehave()
            
        case BookingsStatuses.Open:
            lblPaument.textColor = #colorLiteral(red: 0.9794566035, green: 0.6271900535, blue: 0.008592686616, alpha: 1)
            
            stackViewButtonPay.removeInputView(view: btnPAyNow)
            cancelationStackView.isHidden = true
            stackViewBtnsConstraints.constant = 50
        default:
            break
        }
    }
    
    func contractViewBehave(){
        stackViewButtonPay.removeInputView(view: btnCancell)
        stackViewButtonPay.removeInputView(view: btnPAyNow)
        cancelationStackView.isHidden = true
        stackViewBtnsConstraints.constant = 0
    }
    
    func invoiceViewBehave(){
        
        
        stackViewButtonPay.removeInputView(view: btnCancell)
        stackViewBtnsConstraints.constant = 50
        
    }
    
    @objc func btnPayNowPressed(){
//        let payVc = PaymentVC.initializeFromStoryboard()
//        payVc.amount = totalAmount
//        viewModel.navigateToViewController?(payVc)
        if !(self.checkPaymentIsDisable()) {
            setPaymentVc(val: totalAmount)
        }
    }
    
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
    
    func setPaymentVc(val:String?){
        
        let tuble = constructTimeView(onView: view,val: 0.8)
         timeParentView = tuble.0
         timePArentHeightConstraint = tuble.1
        addFadeBackground(true,  color:UIColor.black)
        paymentVC = PaymentVC.initializeFromStoryboard()
        paymentVC?.paymentDelegate = self
        paymentVC?.amount = val ?? ""
        paymentVC?.isBooking = (reservationNumber == "") ? false : true
        if let pickupDate = DateUtils.dateFromString(currentPickupDate),
           let returnDate = DateUtils.dateFromString(currentReturnDate) {
            let interval = pickupDate.timeIntervalSince(returnDate)
            let differenceInDays = Int(interval / (24 * 60 * 60)) // Convert seconds to days
            paymentVC?.numberOfDays = differenceInDays
        } else {
            print("Invalid date string") // Handle invalid date strings or nil values
        }
        
        
        paymentVC?.invoiceNumber = self.invoiceNumber
        paymentVC?.reservationNumber = self.reservationNumber
        view.bringSubviewToFront(timeParentView ?? UIView())
        addChildViewController(paymentVC, onView: (timeParentView) ?? UIView())
        animateConstraint(constraint: timePArentHeightConstraint, to: 8)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.RentalDetails, screenClass: String(describing: RentalDetailsVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.RentalDetails, screenClass: String(describing: RentalDetailsVC.self))
        
    }
    
    @objc func btnCancelPressed(){
       // let attributedTitleString = NSAttributedString(string: "renta_areYouSure".localized, attributes: [NSAttributedString.Key.font : UIFont.MontserratBold(fontSize: 15) ?? UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor : UIColor.green])
        
  //      let attributedMessageString = NSAttributedString(string: "checkOut_cancelFees".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 13) ?? UIFont.systemFont(ofSize: 13)])
        let alert = UIAlertController(title: "renta_areYouSure".localized, message: "checkOut_cancelFees".localized , preferredStyle: .actionSheet)
      //  alert.setValue(attributedTitleString, forKey: "attributedTitle")
      //  alert.setValue(attributedMessageString, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "checkOut_cancelMyBooking".localized, style: .destructive, handler: { [weak self] action in
            if case .booking(val: let val) = self?.rentalCase {
                if let val = val as? Reservation {
                    self?.viewModel.cancelBookingJson(reservationCode: val.internetReservationNo ?? "")
                }
            }
            if case .all(val: let val) = self?.rentalCase {
                if let val = val as? RentalItem {
                    self?.viewModel.cancelBookingJson(reservationCode: val.internetReservationNo ?? "")
                }
            }
            
        }))
        let actionKeep = UIAlertAction(title: "checkOut_keepMyBooking".localized, style: .cancel, handler: nil)
        actionKeep.setValue(UIColor.theebPrimaryColor,forKey: "titleTextColor")
        alert.addAction(actionKeep)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIDocumentInteractionControllerDelegate

extension RentalDetailsVC: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
      
    }
}


extension RentalDetailsVC:PaymentDelegate{
    func btnClosePressed() {
        if let paymentVC = paymentVC{
            addFadeBackground(false, color: nil)
            removeChildVC(mainVc: paymentVC)
            timeParentView?.removeFromSuperview()
        }
        
        if let navigationController = self.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if let billsVC = navigationController.topViewController as? BillsVC {
                    billsVC.setupScreenAfterPayment()
                } else if let myRentalVC = navigationController.topViewController as? MyRentalVC {
                    myRentalVC.setupScreenAfterPayment()
                }
            }
            navigationController.popViewController(animated: true)
            CATransaction.commit()
        }



    }
    
    
}
