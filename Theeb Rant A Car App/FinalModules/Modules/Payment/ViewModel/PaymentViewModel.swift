//
//  PaymentViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import Foundation
import XMLMapper

class PaymentViewModel: BaseViewModel  {
    
    var payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)
 //  var payFort = PayFortController.init(enviroment: KPayFortEnviromentProduction)
    
    lazy var service = PaymentService()
    var presentViewController: ((_ vc: UIViewController) -> ())?

//
//    func createPayment(paymentOption: String?,
//                        merchantReference: String?,
//                        amount:String?,
//                        cardNumber:String?,
//                        expiry:String?,authorizationCode:String?,
//                        reservationNO : String?,
//                        driverCode:String?,
//                        currency:String?,
//                        invoice: String?,
//                        agreementNo : String? = nil) {
//
//        CustomLoader.customLoaderObj.startAnimating()
//        service.createPayment(paymentOption: paymentOption, merchantReference: merchantReference, amount: amount, cardNumber: cardNumber, expiry: expiry, authorizationCode: authorizationCode, reservationNO: reservationNO, driverCode: driverCode, currency: currency, invoice: invoice) { (response) in
//            CustomLoader.customLoaderObj.stopAnimating()
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<PaymentRequestMappable>().map(XMLString: response ){
//                if responseObject.response?.success == "Y" {
//                    let sucecesVC = SucessScreenForBookingVC.initializeFromStoryboard()
//                    sucecesVC.titleString = "successScreen_paymentSuccess".localized
//                    if  reservationNO?.description == "" {
//                        GoogleAnalyticsManager.logPaymentWithTransactionId(transactionId: invoice?.description, totalPrice: Double(amount ?? ""))
//                        sucecesVC.bookingNumber = invoice?.description ?? ""
//                    } else {
//                        GoogleAnalyticsManager.logPaymentWithTransactionId(transactionId: reservationNO?.description, totalPrice: Double(amount ?? ""))
//                        sucecesVC.bookingNumber = reservationNO?.description ?? ""
//                    }
//
//                    self.presentViewController?(sucecesVC)
//                } else {
//                    let variranceReason = responseObject.response?.varianceReason
//
//                    self.alertUser(msg: variranceReason ?? "")
//
//                }
//
//            }
//
//
//        } failure: { (response, error) in
//
//        }
//
//
//
//    }
           
    
    private func alertUser(msg:String){
//         let banner = Banner(title: msg, image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
//         banner.dismissesOnTap = true
//         banner.show(duration: 5.0)
        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    
    
    
    
    
    
}

extension PaymentViewModel {
    func createPayment(paymentOption: String?,
                        merchantReference: String?,
                        amount:String?,
                        cardNumber:String?,
                        expiry:String?,authorizationCode:String?,
                        reservationNO : String?,
                        driverCode:String?,
                        currency:String?,
                        invoice: String?,
                       agreementNo : String? = nil) {
        CustomLoader.customLoaderObj.startAnimating()
        let paramsDic: [String: Any] = [
            "PAYMENTOPTION": paymentOption ?? "",
            "MERCHANTREFERENCE": merchantReference ?? "",
            "AMOUNT": amount ?? "",
            "CARDNUMBER": cardNumber ?? "",
            "EXPIRYDATE": expiry ?? "",
            "AUTHORIZATIONCODE": authorizationCode ?? "",
            "RESERVATIONNO": reservationNO ?? "",
            "DRIVERCODE": driverCode ?? "",
            "CURRENCY": currency ?? "",
            "INVOICE": invoice ?? "",
            "AGREEMENT": agreementNo ?? "",
            "LicenseIdNo": CachingManager.loginObject()?.licenseNo ?? "",
            "MobileNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "PassportIdNumber": CachingManager.loginObject()?.iDNo ?? "",
            "InternetAddress": CachingManager.loginObject()?.email ?? ""
        ]
       
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.createPayment.rawValue, type: .post,CreatePaymentModel.self)?.response(error: { [weak self] error in
           // send error
            CustomLoader.customLoaderObj.stopAnimating()
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            CustomLoader.customLoaderObj.stopAnimating()
            
            // firebase event
            
            var requestString = ""
            var responseString = ""
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: paramsDic, options: []) {
                let jsonString = String(data: jsonData, encoding: .utf8)
                requestString = jsonString ?? ""
            }
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            if let responseJsonData = try? encoder.encode(model),
               let jsonString = String(data: responseJsonData, encoding: .utf8) {
                responseString = jsonString
            }
            
//            if let responseJsonData = try? JSONSerialization.data(withJSONObject: model, options: []) {
//                let jsonString = String(data: responseJsonData, encoding: .utf8)
//                responseString = jsonString ?? ""
//            }
            
          //  GoogleAnalyticsManager.logAPI(apiName: "theeb_CreatePayment", response: responseString, request: requestString)
            AppsFlyerManager.logAPI(apiName: "theeb_CreatePayment", response: responseString, request: requestString)
            
            guard let model = model else { return }
            if model.PAYMENTRS?.SUCCESS == "Y" {
                let sucecesVC = SucessScreenForBookingVC.initializeFromStoryboard()
                sucecesVC.titleString = "successScreen_paymentSuccess".localized
                sucecesVC.isFromPayment = true
              //  AppsFlyerManager.logPrimaryEvent(eventName: "Payment")
                if let doubleAmount = Double(amount ?? "0") {
                    AppsFlyerManager.logPayment(payment: doubleAmount)
                }
                if  reservationNO?.description == "" {
                    GoogleAnalyticsManager.logPaymentWithTransactionId(transactionId: invoice?.description, totalPrice: Double(amount ?? ""))
                    sucecesVC.bookingNumber = invoice?.description ?? ""
                } else {
                    GoogleAnalyticsManager.logPaymentWithTransactionId(transactionId: reservationNO?.description, totalPrice: Double(amount ?? ""))
                    sucecesVC.bookingNumber = reservationNO?.description ?? ""
                }
                
                self?.presentViewController?(sucecesVC)
            } else {
                //let variranceReason = model.PAYMENTRS?.VarianceReason
                
               // self?.alertUser(msg: variranceReason ?? "")
            }
        }).store(self)
        
    }
}
