//
//  ApplyPayManager.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 15/08/1443 AH.
//

import UIKit

class ApplePayManager: NSObject {


    // MARK: - Constants
    
    let applePayMerchantIdentifier = "merchant.rentcar.theeb"

    
    // MARK: - Variables
    
    var paymentController: PKPaymentAuthorizationViewController?
    var title: String?
    var payfortRequest: [AnyHashable : Any]?
    var paymentInfo: PaymentInfo?
    var paymentGatewayId: Int?
    var countryIsoCode: String?
    var currentViewController: UIViewController? = nil
    var success: PaymentSuccess = nil
    var cancelled: PaymentCancelled = nil
    var failure: PaymentFailure = nil

    
    // MARK: - Validations

    static var isApplePaySupported: Bool {
        
        return PKPaymentAuthorizationViewController.canMakePayments()
    }

    static var canPayWithApplePay: Bool {
        
        return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks)
    }
    
    static var supportedPaymentNetworks: [PKPaymentNetwork] {

        var supportedNetworks: [PKPaymentNetwork] = [
            .visa,
            .masterCard,
            .amex
        ]
        
        if #available(iOS 12.1.1, *) {
            supportedNetworks.append(.mada)
        }
        
        return supportedNetworks
    }
    
    
    // MARK: - Setup Cards
    
    class func openApplePayPaymentSetup() {
        
        PKPassLibrary().openPaymentSetup()
    }
    
    
    // MARK: - Payment

    func pay(withTitle title: String? = nil,
             paymentInfo: PaymentInfo?,
             payfortRequest: [AnyHashable : Any]?,
             paymentGatewayId: Int?,
             countryIsoCode: String?,
             currentViewController: UIViewController? = nil,
             success: PaymentSuccess = nil,
             cancelled: PaymentCancelled = nil,
             failure: PaymentFailure = nil) {
        
        self.title = title
        self.paymentInfo = paymentInfo
        self.payfortRequest = payfortRequest
        self.paymentGatewayId = paymentGatewayId
        self.countryIsoCode = countryIsoCode
        self.currentViewController = currentViewController
        self.success = success
        self.cancelled = cancelled
        self.failure = failure
        
        presentApplePayController()
    }
    
    func presentApplePayController() {
        
        guard ApplePayManager.isApplePaySupported else { return }
        
        guard ApplePayManager.canPayWithApplePay else {
            
            ApplePayManager.openApplePayPaymentSetup()
            return
        }

        let request = PKPaymentRequest()
        request.merchantIdentifier = applePayMerchantIdentifier
        request.supportedNetworks = ApplePayManager.supportedPaymentNetworks
        request.merchantCapabilities = .capability3DS
        request.currencyCode = paymentInfo?.currencyIso ?? ""
        request.countryCode = countryIsoCode ?? ""
        
        let decimalAmount = NSDecimalNumber(value: paymentInfo?.remainingAmount ?? 0)
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: title ?? "Theeb",
                                 amount: decimalAmount),
        ]
        
        paymentController = PKPaymentAuthorizationViewController(paymentRequest: request)
        
        if let paymentController = self.paymentController {
            
            paymentController.delegate = self
            currentViewController?.present(paymentController, animated: true, completion: nil)
            
        } else {
            
            failure?(nil, nil, nil)
        }
    }
}


// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension ApplePayManager: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        let isPaymentDataAvailable = (payment.token.paymentData.count != 0)
        
        if isPaymentDataAvailable {
            
            let payfort = PayFortController(enviroment: environment.payfortEnvironment)
            
            guard let payfortRequest = self.payfortRequest else { return }
            
            let request = NSMutableDictionary(dictionary: payfortRequest)
    
            payfort?.callPayFortForApplePay(withRequest: request, applePay: payment, currentViewController: currentViewController, success: { [weak self] (request, response) in
                
                guard let self = self else { return }
                
                let basePaymentInformation = PaymentManager.basePaymentInformation(request: request,
                                                                                   response: response,
                                                                                   paymentGatewayId: self.paymentGatewayId,
                                                                                   paymentMethod: .applePay,
                                                                                   paymentInfo: self.paymentInfo)
                
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                self.success?(request, response, basePaymentInformation)
                
                }, faild: { [weak self]  (request, response, message) in
                    
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    self?.failure?(request, response, nil)
            })
            
        } else {

            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            self.failure?(nil, nil, nil)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
