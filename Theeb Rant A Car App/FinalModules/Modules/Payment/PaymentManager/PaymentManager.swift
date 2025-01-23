//
//  PaymentManager.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import UIKit

typealias PaymentSuccess = ((_ request: Any?, _ response: Any?, _ basePaymentInformation: BasePaymentInformation?) -> Void)?
typealias PaymentCancelled = ((_ request: Any?, _ response: Any?) -> Void)?
typealias PaymentFailure = ((_ request: Any?, _ response: Any?, _ errorMessage: String?) -> Void)?




class PaymentManager: NSObject, URLSessionDelegate {
    
    
    // MARK: - Constants
    
    let addCardAmount = 0.01
    let defaultCurrencyIso = "SAR"
    let defaultCurrencyDecimalPlaces = 2
    let payfortCustomViewNibName = "PayFortView2"
    let applePayDigitalWalletValue = "APPLE_PAY"
    
    
    
    // MARK: - Payment

    func payUsingPaymentCard(paymentCard: PaymentCard? = nil,
                             paymentInfo: PaymentInfo?,
                             currentViewController: UIViewController? = nil,
                             success: PaymentSuccess = nil,
                             cancelled: PaymentCancelled = nil,
                             failure: PaymentFailure = nil) {
        
        let paymentMethod: PaymentMethods = .card
        
        getPayfortSDKToken(forPaymentMethod: paymentMethod,
                           paymentInfo: paymentInfo,
                           paymentCard: paymentCard,
                           currentViewController: currentViewController,
                           success: success,
                           cancelled: cancelled,
                           failure: failure)
    }
    
    func payUsingApplePay(title: String? = nil,
                          paymentInfo: PaymentInfo?,
                          currentViewController: UIViewController? = nil,
                          success: PaymentSuccess = nil,
                          cancelled: PaymentCancelled = nil,
                          failure: PaymentFailure = nil) {
        
        let paymentMethod: PaymentMethods = .applePay
        
        getPayfortSDKToken(forPaymentMethod: paymentMethod,
                           title: title,
                           paymentInfo: paymentInfo,
                           currentViewController: currentViewController,
                           success: success,
                           cancelled: cancelled,
                           failure: failure)
    }
    
    
    private func getPayfortSDKToken(forPaymentMethod paymentMethod: PaymentMethods,
                                    title: String? = nil,
                                    paymentInfo: PaymentInfo?,
                                    paymentCard: PaymentCard? = nil,
                                    currentViewController: UIViewController?,
                                    success: PaymentSuccess = nil,
                                    cancelled: PaymentCancelled = nil,
                                    failure: PaymentFailure = nil) {
        
        let currentViewController = currentViewController ?? UIViewController.topMostViewController()
//        
      let deviceUDID = PayFortController(enviroment: environment.payfortEnvironment).getUDID()
//
//
//        let service = WalletService()
//
//        service.payfortSDKToken(paymentMethodTypeId: paymentMethod.rawValue,
//                                deviceId: deviceUDID,
//                                success: { [weak self] (response) in
//
//                                    guard let self = self else { return }
//                                    
//                                    let paymentToken = PaymentToken(from: response)
//                                    let paymentGatewayId = paymentToken?.paymentGatewayId
//                                    let countryIsoCode = paymentToken?.countryIsoCode2
//
//                                    let request = self.payfortRequest(paymentMethod: paymentMethod,
//                                                                      paymentToken: paymentToken,
//                                                                      paymentInfo: paymentInfo,
//                                                                      paymentCard: paymentCard)
//                                    
//                                    if paymentMethod == .applePay {
//                                        
//                                        self.applePayManager = ApplePayManager()
//                                        
//                                        self.applePayManager.pay(withTitle: title,
//                                                                 paymentInfo: paymentInfo,
//                                                                 payfortRequest: request,
//                                                                 paymentGatewayId: paymentGatewayId,
//                                                                 countryIsoCode: countryIsoCode,
//                                                                 currentViewController: currentViewController,
//                                                                 success: success,
//                                                                 cancelled: cancelled,
//                                                                 failure: failure)
//                                    } else {
//                                        
//                                        self.openPayfort(withRequest: request,
//                                                         paymentMethod: paymentMethod,
//                                                         paymentInfo: paymentInfo,
//                                                         currentViewController: currentViewController,
//                                                         paymentGatewayId: paymentGatewayId,
//                                                         success: success,
//                                                         cancelled: cancelled,
//                                                         failure: failure)
//                                    }
//            },
//                                failure: nil)
    }

    
    class func basePaymentInformation(request: [AnyHashable : Any?]?,
                                      response: [AnyHashable : Any?]?,
                                      paymentGatewayId: Int?,
                                      paymentMethod: PaymentMethods?,
                                      paymentInfo: PaymentInfo?) -> BasePaymentInformation? {
        
        let paymentOption = response?["payment_option"] as? String
        let cardNo = response?["card_number"] as? String
        let merchantReferenceId = response?["merchant_reference"] as? String
        let transactionNo = response?["fort_id"] as? String
        
        let amount = Price(value: paymentInfo?.remainingAmount,
                           currencyId: paymentInfo?.currencyId,
                           isoCode: paymentInfo?.currencyIso)

        return BasePaymentInformation(paymentMethodId: paymentMethod?.rawValue,
                                      amount: amount,
                                      transactionNo: transactionNo,
                                      cardType: cardType(forPaymentOption: paymentOption)?.rawValue,
                                      cardNo: cardNo,
                                      merchantReferenceId: merchantReferenceId,
                                      paymentGatewayId: paymentGatewayId)
    }
    
    
    class func cardType(forPaymentOption paymentOption: String?) -> CardTypes? {
        
        switch paymentOption {
        case "VISA": return CardTypes.Visa
        case "MASTERCARD": return CardTypes.Master
        case "AMEX": return CardTypes.AMEX
        case "NAPS": return CardTypes.NAPS
        case "KNET": return CardTypes.KNET
        case "MADA": return CardTypes.MADA
        default: return CardTypes.Visa
        }
    }
    
    
    
    


    
}


