//
//  PaymentVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import UIKit
import PassKit
import SnapKit
import Mixpanel
protocol PaymentDelegate{
    func btnClosePressed()
}

class PaymentVC: BaseViewController, PKPaymentAuthorizationControllerDelegate ,URLSessionDelegate  {
    
    var request : PKPaymentRequest?
    var paymentDelegate:PaymentDelegate?
    var SupportedPaymentNetworks = [PKPaymentNetwork.visa,PKPaymentNetwork.masterCard, .mada,.amex,.discover]
    let ApplePaySwagMerchantID = "merchant.rentcar.theeb"
    private var paymentRequest: PKPaymentRequest = {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.rentcar.theeb"
        request.supportedNetworks = [.visa, .masterCard,.amex,.discover, .mada]
            request.supportedCountries = ["SA"]
          //  request.merchantCapabilities = request.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS
         request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.countryCode = "SA"
            request.currencyCode = "SAR"
            return request
        }()
    
    @IBOutlet weak var partialView: UIView!
    @IBOutlet weak var lblLAterPAyValue: UILabel!
    @IBOutlet weak var lblStaticLaterPAyment: UILabel!{
        didSet {
            lblStaticLaterPAyment.text = "payment_laterPay".localized
        }
    }
    @IBOutlet weak var lblThankYou: UILabel!{
        didSet {
            lblThankYou.text = "payment_ThankYou".localized
        }
    }
    @IBOutlet weak var lblApplePAy: UILabel!{
        didSet{
            lblApplePAy.text =  "payment_applePay".localized
        }
    }
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAtaticTotal: UILabel!{
        didSet {
            lblAtaticTotal.text = "payment_total".localized
        }
    }
    
    @IBOutlet weak var btnSelectApplePay: UIButton!{
        didSet{
            btnSelectApplePay.addTarget(self, action: #selector(btnSelectPaymentPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnSelectCredit: UIButton!{
        didSet{
            btnSelectCredit.addTarget(self, action: #selector(btnSelectPaymentPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var viewPArtial: UIView!{
        didSet{
            viewPArtial.layer.cornerRadius = 8
            viewPArtial.layer.borderColor = UIColor.WeemBoredersColor.cgColor
            viewPArtial.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var btnPAyPartial: UIButton!{
        didSet{
            btnPAyPartial.addTarget(self, action: #selector(btnCheckPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var ptnPAyFull: UIButton!{
        didSet{
            ptnPAyFull.addTarget(self, action: #selector(btnCheckPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var lblPAyPArtial: UILabel!{
        didSet{
            lblPAyPArtial.text = "payment_payPartialy".localized
        }
    }
    @IBOutlet weak var lblPAyFullamount: UILabel!
    @IBOutlet weak var lblHowMuch: UILabel!{
        didSet{
            lblHowMuch.text = "payment_HowMuch".localized
        }
    }
    @IBOutlet weak var lblCreditCard: UILabel!{
        didSet{
            lblCreditCard.text = "payment_creditcard".localized
        }
    }
    
    @IBOutlet weak var totalTitleLabel: UILabel! {
        didSet {
            totalTitleLabel.text = "payment_Currenttotal".localized
        }
    }
    
    @IBOutlet weak var choosePaymentMethod: UILabel! {
        didSet {
            choosePaymentMethod.text =  "payment_payment_detailـchoose_option".localized
        }
    }
    
    @IBOutlet weak var currencyLabel: UILabel!  {
        didSet {
            currencyLabel.text = "sar".localized
        }
    }
    var paycontroller = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
    var paymentObj = PaymentObject()
    var amount = String()
    var orignalAmount = String(){
        didSet{
            let totalString = "\(String(format: "%.2f", Double(orignalAmount) ?? 0)) \("sar".localized)"
            lblTotalValue.text = totalString
            amountToPay = Double(totalString)
            btnPAyNow.setTitle("\("rental_pay_Pay".localized) \(totalString) \("rental_pay_Now".localized)", for: .normal)
            lblTotalValueVatNotInclude.text = totalString
            lblTotalValue.text = totalString
        }
    }
    var token = String()
    var rentalRentalObj : RentalsHistoryModel!
    var paymentRentalObj : PaymentsRentalHistoryModel!
    var invoiceRentalObj : InvoicesRentalHistoryModel!
    var reservationRentalObj : [ReservationRentalHistoryModel]!
    var invoiceNumber = String()
    var reservationNumber = String()
    lazy var viewModel = PaymentViewModel()
    var applePayButton: PKPaymentButton?
    var paymentMethod = PaymentMethod.credit
    var isInvoice: Bool? = false
    var isBooking: Bool? = false
    var numberOfDays: Int?
    var amountToPay: Double? = 0
    enum PaymentMethod{
        case credit,applePay
    }
    @IBOutlet weak var payNowBtn: UIButton! {
        didSet {
            payNowBtn.setTitle("payment_pay_with_card" .localized, for: .normal)
        }
    }
    
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var creditCardContainerView: UIView!
    
    @IBOutlet weak var btnPAyNow: UIButton!{
        didSet{
            btnPAyNow.layer.cornerRadius = 8
            btnPAyNow.addTarget(self, action: #selector(btnPayNowPressed(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var lblTotalValueVatNotInclude: UILabel!
    @IBOutlet weak var vatNotIncludedView: UILabel! {
        didSet {
            vatNotIncludedView.text = "paymeny_vat".localized
        }
    }
  //  @IBOutlet weak var applePayView: UIView!

    //MARK: - View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.Payment, screenClass: String(describing: PaymentVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.Payment, screenClass: String(describing: PaymentVC.self))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        lblTitle.text = "payment_payment_details".localized
       print("Invoice")
     
 
        orignalAmount = amount
        paymentAmountTextField.text =  (String(format: "%.2f", Double(amount) ?? 0))
        if isBooking ?? false {
            if numberOfDays ?? 0 < 0 {
                numberOfDays = -(numberOfDays ?? 0)
            }
           // lblPAyFullamount.text = "\("payment_payFullAmount".localized)" + " ( " + "\(numberOfDays ?? 0)" + " days) ".localized  + "\(String(format: "%.2f", Double(amount) ?? 0)) \("sar".localized)

            // Assuming lblPAyFullamount is your UILabel

            // Create an attributed string for the "Th" text with bold font
            let customSARString = String(format: "  %@ SAR".localized, orignalAmount) // Replace someVariable with your actual variable
            let boldSARString = NSMutableAttributedString(string: customSARString)
            let boldFont = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.boldSystemFont(ofSize: 14)// Adjust the font size as needed
            boldSARString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: boldSARString.length))

            // Now, construct the original string
            let localizedFormatString = "Pay the full amount for %@ days".localized
            let localizedString = String(format: localizedFormatString, String(numberOfDays ?? 0))

            // Concatenate the original string with the bold "Th" attributed string
            let finalAttributedText = NSMutableAttributedString(string: localizedString)
            finalAttributedText.append(boldSARString)

            // Set the attributed string to the label
         //   lblPAyFullamount.attributedText = finalAttributedText
            lblPAyFullamount.attributedText = finalAttributedText


            if numberOfDays ?? 0 < 2 {
                partialView.isHidden = true
            } else {
                partialView.isHidden = false
                let amountPerDay = ((Double(amount) ?? 0) / Double(numberOfDays ?? 0))
                let roundedAmount = String(format: "%.2f", amountPerDay)
                let payForDayText = "Pay for only one day".localized
                
                let customSARStringForDay = String(format: "  %@ SAR".localized, roundedAmount) // Replace someVariable with your actual variable
                let boldSARStringForDay = NSMutableAttributedString(string: customSARStringForDay)
                let boldFontForDay = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.systemFont(ofSize: 14)// Adjust the font size as needed
                boldSARStringForDay.addAttribute(.font, value: boldFontForDay, range: NSRange(location: 0, length: boldSARStringForDay.length))
                
                let finalAttributedText = NSMutableAttributedString(string: payForDayText)
                finalAttributedText.append(boldSARStringForDay)
                lblPAyPArtial.attributedText = finalAttributedText
                viewPArtial.isHidden = true
            }
        } else {
            lblPAyFullamount.text = "\("payment_payFullAmount".localized) \(String(format: "%.2f", Double(amount) ?? 0)) \("sar".localized)"
        }
        paymentAmountTextField.delegate = self
       // paycontroller?.isShowResponsePage = true
        setupViewModel()
       paycontroller?.setPayFortCustomViewNib("PayFortView2-ar")
  
        
    }
     
    func updateBtnArr(btnArr:[UIButton],btn : UIButton){
        btnArr.forEach{
            let img = ($0 == btn) ? UIImage(named: "CarWithYouForContractpdf"):UIImage(named: "UnchekForExtras")
            $0.setImage(img, for: .normal)
        }
    }
    
    
    @objc func btnSelectPaymentPressed(_ btn : UIButton) {
        let isCredit = (btn == btnSelectCredit)
       updateBtnArr(btnArr: [btnSelectCredit,btnSelectApplePay], btn: btn)
        paymentMethod = isCredit ? .credit:.applePay
    }
    
    @objc func btnCheckPressed(_ btn : UIButton) {
        let isPartial = (btn == btnPAyPartial)
       updateBtnArr(btnArr: [btnPAyPartial,ptnPAyFull], btn: btn)
        if !isPartial {
            paymentAmountTextField.text = orignalAmount
        }
        
        if isBooking ?? false {
            if numberOfDays ?? 0 < 0 {
                numberOfDays = -(numberOfDays ?? 0)
            }
           // lblPAyFullamount.text = "\("payment_payFullAmount".localized)" + " ( " + "\(numberOfDays ?? 0)" + " days) ".localized  + "\(String(format: "%.2f", Double(orignalAmount) ?? 0)) \("sar".localized)"
            let customSARString = String(format: "  %@ SAR".localized, orignalAmount) // Replace someVariable with your actual variable
            let boldSARString = NSMutableAttributedString(string: customSARString)
            let boldFont = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.boldSystemFont(ofSize: 14) // Adjust the font size as needed
            boldSARString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: boldSARString.length))

            // Now, construct the original string
            let localizedFormatString = "Pay the full amount for %@ days".localized
            let localizedString = String(format: localizedFormatString, String(numberOfDays ?? 0))

            // Concatenate the original string with the bold "Th" attributed string
            let finalAttributedText = NSMutableAttributedString(string: localizedString)
            finalAttributedText.append(boldSARString)

            // Set the attributed string to the label
            lblPAyFullamount.attributedText = finalAttributedText


            if numberOfDays ?? 0 < 2 {
                partialView.isHidden = true
            } else {
                partialView.isHidden = false
                let amountPerDay = ((Double(orignalAmount) ?? 0) / Double(numberOfDays ?? 0))
            //    lblPAyPArtial.text = "Pay for only one day".localized + " " + "\(String(format: "%.2f", amountPerDay ))"
                let roundedAmount = String(format: "%.2f", amountPerDay)
                let payForDayText = "Pay for only one day".localized
                
                let customSARStringForDay = String(format: "  %@ SAR".localized, roundedAmount) // Replace someVariable with your actual variable
                let boldSARStringForDay = NSMutableAttributedString(string: customSARStringForDay)
                let boldFontForDay = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.boldSystemFont(ofSize: 14)// Adjust the font size as needed
                boldSARStringForDay.addAttribute(.font, value: boldFontForDay, range: NSRange(location: 0, length: boldSARStringForDay.length))
                
                let finalAttributedText = NSMutableAttributedString(string: payForDayText)
                finalAttributedText.append(boldSARStringForDay)
                lblPAyPArtial.attributedText = finalAttributedText
                viewPArtial.isHidden = true
            }
        } else {
            lblPAyFullamount.text = "\("payment_payFullAmount".localized) \(String(format: "%.2f", Double(orignalAmount) ?? 0)) \("sar".localized)"
        }
        updateTextField(paymentAmountTextField, isPartial: isPartial)
    }
    
    func applePayInit(name:String ){
        
        request = PKPaymentRequest()
        print(SupportedPaymentNetworks)
        
        request!.merchantIdentifier = ApplePaySwagMerchantID
        request!.supportedNetworks = SupportedPaymentNetworks
        request!.merchantCapabilities = PKMerchantCapability.capability3DS
        request!.supportedNetworks = [.masterCard, .visa , .amex , .discover , .mada ]
        request!.countryCode = "SA"
        request!.currencyCode = "SAR"
        
        let  value = Int((amountToPay ?? Double(orignalAmount)) ?? 0)
        
        request!.paymentSummaryItems = [
            PKPaymentSummaryItem(label:"Theeb Rent A car Co", amount: NSDecimalNumber(value: value))
        ]
        
      
    }
    
    func useApplePayment(){
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Theeb Rent A Car", amount: NSDecimalNumber(string: amount))]
        if let controller = PKPaymentAuthorizationViewController(paymentRequest: request!) {
                   controller.delegate = self
                   present(controller, animated: true, completion: nil)
               }
    }
    
    @objc func btnPayNowPressed(_ sender : UIButton) {
       switch paymentMethod{
        case .credit:
            gettingToken()
        case .applePay:
          applyPayy()
          
        }
    }
    
    func gettingApplyPayToken()
    {
       applePayInit(name:"")
        //payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)
        let payFort = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
        
    
         var post = ""
         post += "\(MethodLiveCredentials.APPLE_PAY_SHAREQUESTPHRASE_CODE.rawValue)access_code=\(MethodLiveCredentials.APPLE_PAY_ACCESS_CODE.rawValue)"
         post += "device_id=\((payFort?.getUDID())!)"
         post += "language=en"
         post += "merchant_identifier=\(MethodLiveCredentials.MERCHANT_IDENTIFIER.rawValue)"
         post += "service_command=SDK_TOKEN\(MethodLiveCredentials.APPLE_PAY_SHARESPONSEPHRASE_CODE.rawValue)"
         
         let requestDic = NSMutableDictionary.init()
         requestDic.setValue("SDK_TOKEN", forKey: "service_command")
         requestDic.setValue("\(MethodLiveCredentials.APPLE_PAY_ACCESS_CODE.rawValue)", forKey: "access_code")
         requestDic.setValue("\(MethodLiveCredentials.MERCHANT_IDENTIFIER.rawValue)", forKey: "merchant_identifier")
         requestDic.setValue("en", forKey: "language")
         requestDic.setValue(payFort?.getUDID(), forKey: "device_id")
         requestDic.setValue(post.sha256(), forKey: "signature")
       // LIVE
        
                var post1 = ""
        
                post1 += "80yc4JWrJQbsmGtm7Z4SPO[)access_code=VApZgs3SBHRlC50TWS6h"
        
                post1 += "device_id=\((payFort?.getUDID())!)"
                post1 += "language=en"
                post1 += "merchant_identifier=kPLAlPIB"
                post1 += "service_command=SDK_TOKEN80yc4JWrJQbsmGtm7Z4SPO[)"
        
                let requestDic1 = NSMutableDictionary.init()
                requestDic1.setValue("SDK_TOKEN", forKey: "service_command")
                requestDic1.setValue("VApZgs3SBHRlC50TWS6h", forKey: "access_code")
                requestDic1.setValue("kPLAlPIB", forKey: "merchant_identifier")
                requestDic1.setValue("en", forKey: "language")
                requestDic1.setValue(payFort?.getUDID(), forKey: "device_id")
                requestDic1.setValue(post1.sha256(), forKey: "signature")
       // LIVE
        
        
        let postdata: Data? = try? JSONSerialization.data(withJSONObject: requestDic1, options: [])
        // let BaseDomain = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi" //Test
        //  var BaseDomain = "https://paymentservices.payfort.com/FortAPI/paymentApi" //Live
        
        let BaseDomain = SOAPACTIONS.domainForPayment
        let urlString = "\(BaseDomain)"
        //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        let postLength = "\(postdata?.count ?? 0)"
        let requestPost = NSMutableURLRequest()
        requestPost.url = URL(string: urlString)
        requestPost.httpMethod = "POST"
        requestPost.setValue(postLength, forHTTPHeaderField: "Content-Length")
        requestPost.setValue("application/json", forHTTPHeaderField: "Accept")
        requestPost.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        requestPost.httpBody = postdata
        //NSLog(@"signal mname %@", signalNameFunction);
        //print("url string \(urlString)")
        
        
        let session1 =  URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
       // CustomLoader.customLoaderObj.startAnimating()
        // DispatchQueue.main.async {
        
        
        session1.dataTask(with: requestPost as URLRequest) { (data, response, error) in
            if(error == nil)
            {
                //print("data    **** \(data)")
                DispatchQueue.main.async {
                    CustomLoader.customLoaderObj.stopAnimating()
                }
                
                var json = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                
                do {
                    
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    print(jsonDic)
                    if let result = jsonDic.value(forKey: "response_message") as? String
                    {
                        if(result == "Signature mismatch")
                        {
                            return
                        }
                        
                        if(result != "Success")
                        {
                            return
                        }
                        
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "sdk_token") as? String
                    {   self.token = tokenStr
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "SDK_token") as? String
                    {   self.token = tokenStr
                        
                    }
                    
                    
                    self.paymentObj.paymentOption = (jsonDic.value(forKey: "payment_option") as? String)
                    self.paymentObj.customer_email = jsonDic.value(forKey: "customer_email") as? String
                    self.paymentObj.language = jsonDic.value(forKey: "language") as? String
                    self.paymentObj.merchantReferenec = jsonDic.value(forKey: "merchant_reference") as? String
                    // self.paymentObj.amount = self.amountChange(amountStr: (jsonDic.value(forKey: "amount") as? String)!)
                    //  self.paymentObj.fortId = jsonDic.value(forKey: "fort_id") as? String
                    // self.paymentObj.carHolderName = jsonDic.value(forKey: "card_holder_name") as? String
                    self.paymentObj.status = jsonDic.value(forKey: "status") as? String
                    // self.paymentObj.customerIp = jsonDic.value(forKey: "customer_ip") as? String
                    //  self.paymentObj.eci = jsonDic.value(forKey: "eci") as? String
                    // self.paymentObj.currency = jsonDic.value(forKey: "currency") as? String
                    self.paymentObj.sdkToken = jsonDic.value(forKey: "sdk_token") as? String
                    self.paymentObj.responseMessage = jsonDic.value(forKey: "response_message") as? String
                    // self.paymentObj.cardNumber = jsonDic.value(forKey: "card_number") as? String
                    // self.paymentObj.expiryDate = jsonDic.value(forKey: "expiry_date") as? String
                    //self.paymentObj.command = jsonDic.value(forKey: "command") as? String
                    // self.paymentObj.authorizationCode = jsonDic.value(forKey: "authorization_code") as? String
                    
                    
                    
                    //print(jsonDic)
                    
                    //if Thread.current.isMainThread
                    //  {
                    DispatchQueue.main.async {
                        var button = UIButton()
                        self.applePayAction()
                        // }
                    }
                    //                if let names = json["names"] as? [String] {
                    //                    //print(names)
                    //                }
                } catch let error as NSError {
                    //print("Failed to load: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        self.gettingToken()
    }
    
    func setupApplePayButton() {
        
        applePayButton?.removeFromSuperview()
        
        let buttonType: PKPaymentButtonType = .inStore //true ? .inStore : .setUp
        
        applePayButton = PKPaymentButton(paymentButtonType: buttonType, paymentButtonStyle: .black);
        applePayButton?.addTarget(self, action: #selector(applePayButtonClicked(_:)), for: .touchUpInside)
        
//        applePayButton?.frame = applePayContainerView.bounds
     //   applePayButton?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        guard let applePayButton = applePayButton else { return }
        
       // applePayContainerView.addSubview(applePayButton)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.applyGrayNavigationBar()
       // setupApplePayButton()
        
        
    }
    
    
    @objc func applePayButtonClicked(_ sender: Any) {
        
        
    }
    
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        
        
    }
    
    
    func gettingToken() {
        
       


//        var post = ""
//         post += "\("Theebreq@2023")access_code=\("ydwtNcUh6XuQ2CZarVUr")"
//         post += "device_id=\((paycontroller?.getUDID())!)"
//         post += "language=en"
//         post += "merchant_identifier=fnISEZbA"
//         post += "service_command=SDK_TOKEN\("Theebreq@2023")"
//
//         let requestDic = NSMutableDictionary.init()
//        requestDic.setValue("SDK_TOKEN", forKey: "service_command")
//        requestDic.setValue("ydwtNcUh6XuQ2CZarVUr", forKey: "access_code")
//        requestDic.setValue("fnISEZbA", forKey: "merchant_identifier")
//        requestDic.setValue("en", forKey: "language")
//        requestDic.setValue(paycontroller?.getUDID(), forKey: "device_id")
//        requestDic.setValue(post.sha256(), forKey: "signature")
        
        var post = ""
         post += "\(MethodLiveCredentials.SHA_REQUEST_PHRASE.rawValue)access_code=\(MethodLiveCredentials.ACCESS_CODE.rawValue)"
         post += "device_id=\((paycontroller?.getUDID())!)"
         post += "language=en"
         post += "merchant_identifier=\(MethodLiveCredentials.MERCHANT_IDENTIFIER.rawValue)"
         post += "service_command=SDK_TOKEN\(MethodLiveCredentials.SHA_REQUEST_PHRASE.rawValue)"
         
         let requestDic = NSMutableDictionary.init()
         requestDic.setValue("SDK_TOKEN", forKey: "service_command")
         requestDic.setValue("\(MethodLiveCredentials.ACCESS_CODE.rawValue)", forKey: "access_code")
         requestDic.setValue("\(MethodLiveCredentials.MERCHANT_IDENTIFIER.rawValue)", forKey: "merchant_identifier")
         requestDic.setValue("en", forKey: "language")
         requestDic.setValue(paycontroller?.getUDID(), forKey: "device_id")
         requestDic.setValue(post.sha256(), forKey: "signature")
        
        // PRODUCTION WORKING
        

        
        var postdata: Data? = try? JSONSerialization.data(withJSONObject: requestDic, options: [])
        // let BaseDomain = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi" //Test
        //  var BaseDomain = "https://paymentservices.payfort.com/FortAPI/paymentApi" //Live
        
        let BaseDomain = SOAPACTIONS.domainForPayment//SOAPACTIONS.domainForPaymentTest//SOAPACTIONS.domainForPayment
    //    let BaseDomain = SOAPACTIONS.domainForPaymentTest
        let urlString = "\(BaseDomain)"
        //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        let postLength = "\(postdata?.count ?? 0)"
        let requestPost = NSMutableURLRequest()
        requestPost.url = URL(string: urlString)
        requestPost.httpMethod = "POST"
        requestPost.setValue(postLength, forHTTPHeaderField: "Content-Length")
        requestPost.setValue("application/json", forHTTPHeaderField: "Accept")
        requestPost.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        requestPost.httpBody = postdata
        //NSLog(@"signal mname %@", signalNameFunction);
        //print("url string \(urlString)")
        
        let session =  URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
       // CustomLoader.customLoaderObj.startAnimating()
        // DispatchQueue.main.async {
        
        
        session.dataTask(with: requestPost as URLRequest) { (data, response, error) in
            if(error == nil)
            {
                //print("data    **** \(data)")
                DispatchQueue.main.async {
                    CustomLoader.customLoaderObj.stopAnimating()
                }
                
                var json = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                
                do {
                    
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    if let result = jsonDic.value(forKey: "response_message") as? String
                    {
                        if(result == "Signature mismatch")
                        {
                            return
                        }
                        
                        if(result != "Success")
                        {
                            return
                        }
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "sdk_token") as? String
                    {
                        self.token = tokenStr
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "SDK_token") as? String
                    {
                        self.token = tokenStr
                        
                    }
                    
                    
                    self.paymentObj.paymentOption = (jsonDic.value(forKey: "payment_option") as? String)
                    self.paymentObj.customer_email = jsonDic.value(forKey: "customer_email") as? String
                    self.paymentObj.language = jsonDic.value(forKey: "language") as? String
                    self.paymentObj.merchantReferenec = jsonDic.value(forKey: "merchant_reference") as? String
                    self.paymentObj.status = jsonDic.value(forKey: "status") as? String
                    self.paymentObj.sdkToken = jsonDic.value(forKey: "sdk_token") as? String
                    self.paymentObj.responseMessage = jsonDic.value(forKey: "response_message") as? String
                    
                    
                    
                    DispatchQueue.main.async {
                       // switch self.paymentMethod{
                      //  case .credit:
                            self.openPaymentController()
                           // self.intializePayfort()
                     //   case .applePay:
                          //  self.useApplePayment()
                        }
                   // }
                    
                    //                }
                } catch let error as NSError {
                    print(error.localizedDescription)

                }
            }else{
                print(error?.localizedDescription)
            }
        }.resume()
    }
    
    private func alertUser(msg:String){

        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    func applyPayy() {
        
        
       applePayInit(name:"")
         let payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)
        
//        // staging
//        var post = ""
//
//        post += "083M3W4gb0O6b/Q4rsAmXE!]access_code=ENnE3c5yECUYI0ilLqzS"
//
//        post += "device_id=\((paycontroller?.getUDID())!)"
//        post += "language=en"
//        post += "merchant_identifier=fnISEZbA"
//        post += "service_command=SDK_TOKEN083M3W4gb0O6b/Q4rsAmXE!]"
//
//        let requestDic = NSMutableDictionary.init()
//        requestDic.setValue("SDK_TOKEN", forKey: "service_command")
//        requestDic.setValue("ENnE3c5yECUYI0ilLqzS", forKey: "access_code")
//        requestDic.setValue("fnISEZbA", forKey: "merchant_identifier")
//        requestDic.setValue("en", forKey: "language")
//        requestDic.setValue(payFort?.getUDID(), forKey: "device_id")
//        requestDic.setValue(post.sha256(), forKey: "signature")
        
       // LIVE
        
                var post = ""
        
                post += "80yc4JWrJQbsmGtm7Z4SPO[)access_code=VApZgs3SBHRlC50TWS6h"
        
                post += "device_id=\((paycontroller?.getUDID())!)"
                post += "language=en"
                post += "merchant_identifier=kPLAlPIB"
                post += "service_command=SDK_TOKEN80yc4JWrJQbsmGtm7Z4SPO[)"
        
                let requestDic = NSMutableDictionary.init()
                requestDic.setValue("SDK_TOKEN", forKey: "service_command")
                requestDic.setValue("VApZgs3SBHRlC50TWS6h", forKey: "access_code")
                requestDic.setValue("kPLAlPIB", forKey: "merchant_identifier")
                requestDic.setValue("en", forKey: "language")
                requestDic.setValue(payFort?.getUDID(), forKey: "device_id")
                requestDic.setValue(post.sha256(), forKey: "signature")
//       // LIVE
        
        
        let postdata: Data? = try? JSONSerialization.data(withJSONObject: requestDic, options: [])
        
        let BaseDomain = SOAPACTIONS.domainForPayment //SOAPACTIONS.domainForPaymentTest//
       // let BaseDomain = SOAPACTIONS.domainForPaymentTest
        let urlString = "\(BaseDomain)"
        let postLength = "\(postdata?.count ?? 0)"
        let requestPost = NSMutableURLRequest()
        requestPost.url = URL(string: urlString)
        requestPost.httpMethod = "POST"
        requestPost.setValue(postLength, forHTTPHeaderField: "Content-Length")
        requestPost.setValue("application/json", forHTTPHeaderField: "Accept")
        requestPost.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        requestPost.httpBody = postdata
  
        
        let session1 =  URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
       // CustomLoader.customLoaderObj.startAnimating()
        // DispatchQueue.main.async {
        
        
        session1.dataTask(with: requestPost as URLRequest) { (data, response, error) in
            if(error == nil)
            {
                //print("data    **** \(data)")
                DispatchQueue.main.async {
                    CustomLoader.customLoaderObj.stopAnimating()
                }
                
                var json = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                
                do {
                    
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    print(jsonDic)
                    if let result = jsonDic.value(forKey: "response_message") as? String
                    {
                        if(result == "Signature mismatch")
                        {
                            return
                        }
                        
                        if(result != "Success")
                        {
                            return
                        }
                        
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "sdk_token") as? String
                    {   self.token = tokenStr
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "SDK_token") as? String
                    {   self.token = tokenStr
                        
                    }
                    
                    
                    self.paymentObj.paymentOption = (jsonDic.value(forKey: "payment_option") as? String)
                    self.paymentObj.customer_email = jsonDic.value(forKey: "customer_email") as? String
                    self.paymentObj.language = jsonDic.value(forKey: "language") as? String
                    self.paymentObj.merchantReferenec = jsonDic.value(forKey: "merchant_reference") as? String
                    self.paymentObj.status = jsonDic.value(forKey: "status") as? String
                    self.paymentObj.sdkToken = jsonDic.value(forKey: "sdk_token") as? String
                    self.paymentObj.responseMessage = jsonDic.value(forKey: "response_message") as? String
            
            
                    DispatchQueue.main.async {
                      
                        self.applePayAction()
                       
                    }
                
                } catch let error as NSError {
                    //print("Failed to load: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    
    func openPaymentController() {
        
     
        if paymentAmountTextField.text != nil ||  paymentAmountTextField.text != "" {
            if let text = paymentAmountTextField.text {
                amount = text
            }
            
        }
        if orignalAmount == nil {
            self.alertUser(msg:"Amount can't be 0".localized)
            return
        }
        let originalValue =  Int(Double(orignalAmount)! * 100)
        var valDouble: Double = 0
       
        valDouble = ((((amountToPay) ??  Double(orignalAmount)) ?? 0) * 100)
        let value = Int(valDouble)
        
        if value > originalValue {
            
            self.alertUser(msg:"payment_more_than_current".localized)
            return
        }
        
       
       
       // request.setValue("kPLAlPIB", forKey: "merchant_identifier")

        let descText = "paymentType: " + ((isBooking ?? false) ? "reservationNo" : "invoice" ) + " / " + "paymentValue: " + ((isBooking ?? false) ? reservationNumber : invoiceNumber)
        
        let request = NSMutableDictionary()
        let doublee = Int(arc4random_uniform(999999999))
        request.setValue( value , forKey: "amount")
        request.setValue("PURCHASE", forKey: "command")
        request.setValue("SAR", forKey: "currency")
        request.setValue(CachingManager.loginObject()?.email, forKey: "customer_email")
        request.setValue("en", forKey: "language")
        request.setValue("\(doublee)", forKey: "merchant_reference")
        request.setValue(token, forKey: "sdk_token")
        request.setValue(descText, forKey: "order_description")
        request.setValue(CachingManager.loginObject()?.lastName, forKey: "merchant_extra1")
        request.setValue(CachingManager.loginObject()?.licenseNo, forKey: "merchant_extra2")
        request.setValue(CachingManager.loginObject()?.mobileNo, forKey: "merchant_extra3")
        request.setValue(CachingManager.loginObject()?.email, forKey: "merchant_extra4")
                                                                                                                             
        
        let payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)

        payFort?.callPayFort(withRequest: request, currentViewController: self,
                                   success: { (requestDic, responeDic) in
            
//            // firebase event
//            
//            var requestString = ""
//            var responseString = ""
//            
//            if let jsonData = try? JSONSerialization.data(withJSONObject: requestDic, options: []) {
//                let jsonString = String(data: jsonData, encoding: .utf8)
//                requestString = jsonString ?? ""
//            }
//            
//            if let responseJsonData = try? JSONSerialization.data(withJSONObject: responeDic, options: []) {
//                let jsonString = String(data: responseJsonData, encoding: .utf8)
//                responseString = jsonString ?? ""
//            }
//            
//           // GoogleAnalyticsManager.logAPI(apiName: "PayFort", response: responseString, request: requestString)
//            AppsFlyerManager.logAPI(apiName: "PayFort", response: responseString, request: requestString)
//            self.paymentObj.paymentOption = responeDic!["payment_option"] as? String
//            self.paymentObj.customer_email = responeDic!["customer_email"] as? String
//            self.paymentObj.language = responeDic!["language"] as? String
//            self.paymentObj.merchantReferenec = responeDic!["merchant_reference"] as? String
//            self.paymentObj.amount = responeDic!["amount"] as? String
//            self.paymentObj.fortId = responeDic!["fort_id"] as? String
//            self.paymentObj.carHolderName = responeDic!["card_holder_name"] as? String
//            self.paymentObj.status = responeDic!["status"] as? String
//            self.paymentObj.customerIp = responeDic!["customer_ip"] as? String
//            self.paymentObj.eci = responeDic!["eci"] as? String
//            self.paymentObj.currency = responeDic!["currency"] as? String
//            self.paymentObj.sdkToken = responeDic!["sdk_token"] as? String
//            self.paymentObj.responseMessage = responeDic!["response_message"] as? String
//            self.paymentObj.cardNumber = responeDic!["card_number"] as? String
//            self.paymentObj.expiryDate = responeDic!["expiry_date"] as? String
//            self.paymentObj.command = responeDic!["command"] as? String
//            self.paymentObj.authorizationCode = responeDic!["authorization_code"] as? String
//                
//            var amountToPay = ""
//            if let number = Double(self.paymentObj.amount ?? "0") {
//                let result = number / 100
//                amountToPay = String(format: "%.2f", result)
//                print(amountToPay)
//            } else {
//                print("Invalid input")
//            }
//            
//            
//            self.viewModel.createPayment(paymentOption: self.paymentObj.paymentOption!, merchantReference: self.paymentObj.merchantReferenec!, amount: amountToPay, cardNumber: self.paymentObj.cardNumber!, expiry: self.paymentObj.expiryDate!, authorizationCode: self.paymentObj.authorizationCode!, reservationNO: self.reservationNumber ?? "", driverCode: CachingManager.loginObject()?.driverCode, currency: "SAR", invoice: self.invoiceNumber ?? "" )
                self.paycontroller?.dismiss(animated: true, completion: {
            
                
            let sucecesVC = SucessScreenForBookingVC.initializeFromStoryboard()
            sucecesVC.titleString = "successScreen_paymentSuccess".localized
            if self.isBooking ?? false{
                sucecesVC.bookingNumber = self.reservationNumber.description
            } else {
                sucecesVC.bookingNumber = self.invoiceNumber.description
            }
                    sucecesVC.isFromPayment = true
                    self.present(sucecesVC, animated: true) {
                        self.paymentDelegate?.btnClosePressed()
                    }
                   
                })
        },   canceled: {(requestDic, responeDic) in
                                CustomLoader.customLoaderObj.stopAnimating()
                         print("requestDic=\(requestDic!)")
                                self.paycontroller?.dismiss(animated: true, completion: nil)
                                
                                
        }, faild: { (requestDic, responeDic, message) in
            print("requestDic=\(requestDic!)")
            CustomLoader.customLoaderObj.stopAnimating()
            payFort?.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
            CustomAlertController.initialization().showAlertWithOkButton(message: "payment_Declined".localized) { (index, title) in
                 print(index,title)
            }
            
        })
    }

   
    //MARK: - Actions
    
    @IBAction func payNowBtnAction(_ sender: Any) {
        
        self.gettingToken()
        
    }
    
    //MARK: - setupViewModel
    
    func setupViewModel() {
        
        viewModel.presentViewController = { [weak self]  (vc)  in
            
            self?.present(vc, animated: true)
            self?.paymentDelegate?.btnClosePressed()
            
            
        }
    }
    
    
    
    
    //MARK: - Initialization
    
    class func initializeFromStoryboard() -> PaymentVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Payment, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: PaymentVC.self)) as! PaymentVC
    }
    
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: PaymentVC.initializeFromStoryboard())
    }
    
    func applePayAction()
    {
        print(PKPaymentAuthorizationController.canMakePayments())
        if(PKPaymentAuthorizationController.canMakePayments())
        {
             let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request!)
            applePayController?.delegate = self
             DispatchQueue.main.async {
                self.present(applePayController!, animated: true, completion: nil)
             }
          
            
        }
    }
    
    @objc func gettingTokenApplePay() {
    
        
        var post1 = ""

        post1 += "80yc4JWrJQbsmGtm7Z4SPO[)access_code=VApZgs3SBHRlC50TWS6h"

        post1 += "device_id=\((paycontroller?.getUDID())!)"
        post1 += "language=en"
        post1 += "merchant_identifier=kPLAlPIB"
        post1 += "service_command=SDK_TOKEN80yc4JWrJQbsmGtm7Z4SPO[)"

        let requestDic1 = NSMutableDictionary.init()
        requestDic1.setValue("SDK_TOKEN", forKey: "service_command")
        requestDic1.setValue("VApZgs3SBHRlC50TWS6h", forKey: "access_code")
        requestDic1.setValue("kPLAlPIB", forKey: "merchant_identifier")
        requestDic1.setValue("en", forKey: "language")
        requestDic1.setValue(paycontroller?.getUDID(), forKey: "device_id")
        requestDic1.setValue(post1.sha256(), forKey: "signature")
        //LIVE
    
        var postdata: Data? = try? JSONSerialization.data(withJSONObject: requestDic1, options: [])
        // let BaseDomain = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi" //Test
        //  var BaseDomain = "https://paymentservices.payfort.com/FortAPI/paymentApi" //Live
        
        let BaseDomain = SOAPACTIONS.domainForPayment
        let urlString = "\(BaseDomain)"
        //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        let postLength = "\(postdata?.count ?? 0)"
        let requestPost = NSMutableURLRequest()
        requestPost.url = URL(string: urlString)
        requestPost.httpMethod = "POST"
        requestPost.setValue(postLength, forHTTPHeaderField: "Content-Length")
        requestPost.setValue("application/json", forHTTPHeaderField: "Accept")
        requestPost.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        requestPost.httpBody = postdata
        //print("url string \(urlString)")
        
        
        
        let session1 =  URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        

        
        
        session1.dataTask(with: requestPost as URLRequest) { (data, response, error) in
            if(error == nil)
            {
                //print("data    **** \(data)")
                DispatchQueue.main.async {
                    CustomLoader.customLoaderObj.stopAnimating()
                }
                
                var json = NSString(data: data!, encoding: String.Encoding.ascii.rawValue)
                
                do {
                    
                    let jsonDic = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    print(jsonDic)
                    if let result = jsonDic.value(forKey: "response_message") as? String
                    {
                        if(result == "Signature mismatch")
                        {
                            return
                        }
                        
                        if(result != "Success")
                        {
                            return
                        }
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "sdk_token") as? String
                    {   self.token = tokenStr
                        
                    }
                    if let tokenStr = jsonDic.value(forKey: "SDK_token") as? String
                    {   self.token = tokenStr
                        
                    }
                    
                    
                    self.paymentObj.paymentOption = (jsonDic.value(forKey: "payment_option") as? String)
                    self.paymentObj.customer_email = jsonDic.value(forKey: "customer_email") as? String
                    self.paymentObj.language = jsonDic.value(forKey: "language") as? String
                    self.paymentObj.merchantReferenec = jsonDic.value(forKey: "merchant_reference") as? String
                    
                    self.paymentObj.status = jsonDic.value(forKey: "status") as? String
                 
                    self.paymentObj.sdkToken = jsonDic.value(forKey: "sdk_token") as? String
                    self.paymentObj.responseMessage = jsonDic.value(forKey: "response_message") as? String
               
                  
                    
                  
                    //  {
                    DispatchQueue.main.async {
                        self.applePayAction()
                    }
                  
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    
    @IBAction func btnClosePressed(_ sender: UIButton) {
        paymentDelegate?.btnClosePressed()
    }
    

}

extension PaymentVC:UITextFieldDelegate{
    
    func updateTextField(_ textField: UITextField, isPartial: Bool? = nil){
        if let txtValue = textField.text,let txtFieldDouble = Double(txtValue){
            let amountAsDouble = (Double(orignalAmount) ?? 0)
            if txtFieldDouble > amountAsDouble{
                textField.text = orignalAmount
                return
            }
            if isBooking ?? false && isPartial ?? false{
                if numberOfDays ?? 0 < 0 {
                    numberOfDays = -(numberOfDays ?? 0)
                }
                amount = (numberOfDays != nil && (numberOfDays ?? 0 > 0)) ? String((Double(orignalAmount) ?? 0) / Double(numberOfDays ?? 0)) : String(orignalAmount)
                amountToPay = Double(amount)
                let payLaterVal =  amountAsDouble - (Double(amount) ?? 0)
                let payLaterString = "\(String(format: "%.2f", payLaterVal)) \("sar".localized)"
                let txtFieldString = "\(String(format: "%.2f", Double(amount) ?? 0)) \("sar".localized)"
                lblLAterPAyValue.text = payLaterString
                btnPAyNow.setTitle("\("rental_pay_Pay".localized) \(txtFieldString) \("rental_pay_Now".localized)", for: .normal)
                lblTotalValueVatNotInclude.text = txtFieldString
                lblTotalValue.text = txtFieldString
            } else {
                amount = String(orignalAmount)
                amountToPay = Double(String(format: "%.2f", (Double(textField.text ?? "0") ?? 0.0)))
                let payLaterVal =  amountAsDouble - (amountToPay ?? 0)
                let payLaterString = "\(String(format: "%.2f", payLaterVal)) \("sar".localized)"
                let txtFieldString = "\(String(format: "%.2f", Double(amount) ?? 0)) \("sar".localized)"
               // lblStaticLaterPAyment.text = "\(String(format: "%.2f", ((Double(amount) ?? 0) - (amountToPay ?? 0)))) \("sar".localized)"
                lblLAterPAyValue.text = payLaterString
                let totalPartialPay = "\(String(format: "%.2f", amountToPay ?? 0.0)) \("sar".localized)"
                btnPAyNow.setTitle("\("rental_pay_Pay".localized) \(totalPartialPay) \("rental_pay_Now".localized)", for: .normal)
                lblTotalValueVatNotInclude.text = totalPartialPay
                lblTotalValue.text = totalPartialPay
            }
           
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextField(textField)
        btnCheckPressed(btnPAyPartial)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateTextField(textField)
        btnCheckPressed(btnPAyPartial)
       
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnCheckPressed(btnPAyPartial)
    }
}


extension PaymentVC: PKPaymentAuthorizationViewControllerDelegate {
 
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        if let  data = String(data: payment.token.paymentData, encoding: .utf8)
             {
                print(data)
            Mixpanel.mainInstance().track(event: "apple pay token payment object", properties: [
                 "data": data,
             ])
        }
        let asyncSuccessful = payment.token.paymentData.count != 0
        
        if asyncSuccessful {
            
            //let request = NSMutableDictionary.init()
            let originalValue =  Int(Double(orignalAmount)! * 100)
            var valDouble: Double = 0
           
            valDouble = ((((amountToPay) ??  Double(orignalAmount)) ?? 0) * 100)
            let value = Int(valDouble)
            
            if value > originalValue {
                
                self.alertUser(msg:"payment_more_than_current".localized)
                return
            }
            
//            let double = Int(arc4random_uniform(999999999))
//            
//            let string = "\(value)"
//            let payFortcontroller = PayFortController.init(enviroment: KPayFortEnviromentProduction)
//            request.setValue("APPLE_PAY" , forKey: "digital_wallet")
//            request.setValue( value, forKey: "amount")
//            request.setValue("PURCHASE", forKey: "command")
//          //  request.setValue("\(paycontroller?.getUDID() ?? "")", forKey: "device_id")
//         //   request.setValue("VApZgs3SBHRlC50TWS6h", forKey: "access_code")
//           // request.setValue("kPLAlPIB", forKey: "merchant_identifier")
//            request.setValue("SAR", forKey: "currency")
//            request.setValue("\(CachingManager.loginObject()?.email ?? "")", forKey: "customer_email")
//            request.setValue("en", forKey: "language")
//            request.setValue("\(double)", forKey: "merchant_reference")
//            request.setValue(token, forKey: "sdk_token")
            
            let payFortcontroller = PayFortController.init(enviroment: KPayFortEnviromentProduction)
            
            let descText = "paymentType: " + ((isBooking ?? false) ? "reservationNo" : "invoice" ) + " / " + "paymentValue: " + ((isBooking ?? false) ? reservationNumber : invoiceNumber)
            
            let request = NSMutableDictionary()
            let doublee = Int(arc4random_uniform(999999999))
            request.setValue( value , forKey: "amount")
            request.setValue("APPLE_PAY" , forKey: "digital_wallet")
            request.setValue("PURCHASE", forKey: "command")
            
            request.setValue("SAR", forKey: "currency")
            request.setValue(CachingManager.loginObject()?.email, forKey: "customer_email")
            request.setValue("en", forKey: "language")
            request.setValue("\(doublee)", forKey: "merchant_reference")
            request.setValue(token, forKey: "sdk_token")
            request.setValue(descText, forKey: "order_description")
            request.setValue(CachingManager.loginObject()?.lastName, forKey: "merchant_extra1")
            request.setValue(CachingManager.loginObject()?.licenseNo, forKey: "merchant_extra2")
            request.setValue(CachingManager.loginObject()?.mobileNo, forKey: "merchant_extra3")
            request.setValue(CachingManager.loginObject()?.email, forKey: "merchant_extra4")
            
            payFortcontroller?.callPayFortForApplePay(withRequest: request,
                                            applePay: payment,
                                            currentViewController: self
                , success: { (responeDic, responeDic1) in
                
                let sucecesVC = SucessScreenForBookingVC.initializeFromStoryboard()
                sucecesVC.titleString = "successScreen_paymentSuccess".localized
                if self.isBooking ?? false{
                    sucecesVC.bookingNumber = self.reservationNumber.description
                } else {
                    sucecesVC.bookingNumber = self.invoiceNumber.description
                }
                sucecesVC.isFromPayment = true
                self.present(sucecesVC, animated: true)
                
//
//                if let responseDictionary = responeDic1 as? [String: Any] {
//                    self.paymentObj.paymentOption = responseDictionary["payment_option"] as? String
//                    self.paymentObj.customer_email = responseDictionary["customer_email"] as? String
//                    self.paymentObj.language = responseDictionary["language"] as? String
//                    self.paymentObj.merchantReferenec = responseDictionary["merchant_reference"] as? String
//                    self.paymentObj.amount = responseDictionary["amount"] as? String
//                    self.paymentObj.fortId = responseDictionary["fort_id"] as? String
//                    self.paymentObj.carHolderName = responseDictionary["card_holder_name"] as? String
//                    self.paymentObj.status = responseDictionary["status"] as? String
//                    self.paymentObj.customerIp = responseDictionary["customer_ip"] as? String
//                    self.paymentObj.eci = responseDictionary["eci"] as? String
//                    self.paymentObj.currency = responseDictionary["currency"] as? String
//                    self.paymentObj.sdkToken = responseDictionary["sdk_token"] as? String
//                    self.paymentObj.responseMessage = responseDictionary["response_message"] as? String
//                    self.paymentObj.cardNumber = responseDictionary["card_number"] as? String
//                    self.paymentObj.expiryDate = responseDictionary["expiry_date"] as? String
//                    self.paymentObj.command = responseDictionary["command"] as? String
//                    self.paymentObj.authorizationCode = responseDictionary["authorization_code"] as? String
//                   
//                    var amountToPay = ""
//                    if let number = Double(self.paymentObj.amount ?? "0") {
//                        let result = number / 100
//                        amountToPay = String(format: "%.2f", result)
//                        print(amountToPay)
//                    } else {
//                        print("Invalid input")
//                    }
//                    
//                    self.viewModel.createPayment(paymentOption: self.paymentObj.paymentOption ?? "", merchantReference: self.paymentObj.merchantReferenec ?? "", amount:  amountToPay, cardNumber: self.paymentObj.cardNumber ?? "", expiry: self.paymentObj.expiryDate ?? "", authorizationCode: self.paymentObj.authorizationCode ?? "", reservationNO: self.reservationNumber , driverCode: CachingManager.loginObject()?.driverCode ?? "", currency: "SAR", invoice: self.invoiceNumber )
//                }
           completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            }, faild:{ (requestDic, responeDic1, message) in
               // self.alertUser(msg: "request" + "  " + (message ?? ""))
                
                print(requestDic)
                print(responeDic1)
                print(message)
                var requestString = ""
                var responseString = ""
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: requestDic, options: []) {
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    requestString = jsonString ?? ""
                }
                
                if let responseJsonData = try? JSONSerialization.data(withJSONObject: responeDic1, options: []) {
                    let jsonString = String(data: responseJsonData, encoding: .utf8)
                    responseString = jsonString ?? ""
                }
                Mixpanel.mainInstance().track(event: "apple pay", properties: [
                     "request": requestString,
                     "response": responseString,
                 ])
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            })
            
         }else {
         //    alertUser(msg: "Authorization Faild")
             completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            
         }
        
   
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
       
        completion(PKPaymentRequestPaymentMethodUpdate(errors: nil, paymentSummaryItems: request!.paymentSummaryItems))
     
        
    }
    
 
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
       
        controller.dismiss(animated: true) { [weak self] in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            
//                self?.paymentDelegate?.btnClosePressed()
//
//            }
        }
      
    }
 
}

