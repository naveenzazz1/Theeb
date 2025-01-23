//
//  RentalDetailsViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 26/03/2022.
//

import Foundation
import XMLMapper
import Combine

class RentalDetailsViewModel : BaseViewModel {
    
    //vars
    let bookingService = GetMyBookingsService()
    var fillBookingView: ((_ booking:Reservation) -> ())?
    var fillInvoiceView: ((_ invoice:InvoiceJson) -> ())?
    var fillContractView: ((_ contract:Agreement) -> ())?
    var fillAllViews: ((_ contract:RentalItem) -> ())?
    var navigateToViewController: ((_ vc: UIViewController) -> Void)?
    var returnToMyBookings: (() -> ())?
    var openPDFWithURL: ((_ url: URL) -> ())?

    func cancelBooking(reservationCode:String) {
        
        CustomLoader.customLoaderObj.startAnimating()
        bookingService.cancelMyRental(reservationCode: reservationCode) { response in
            guard let response = response as? String else {return}
            let userModel = XMLMapper<ReservationMappable>().map(XMLString: response )
            if userModel?.reservationDetails.success == "Y" {
                DispatchQueue.main.async{
                    self.alertUser(title: "alert_success".localized,msg: "rental_BookingCancell".localized)
                    self.returnToMyBookings?()
                }
            }else{
                DispatchQueue.main.async{
                    self.alertUser(title:"login_error".localized,msg: "Error Occured")
                }
            }
            CustomLoader.customLoaderObj.stopAnimating()
        } failure: { response, error in
            CustomLoader.customLoaderObj.stopAnimating()
            print(error?.localizedDescription ?? "error occured")
        }

    }
    
    func cancelBookingJson(reservationCode:String) {
        let driverCode = CachingManager.loginObject()?.driverCode
        let paramsDic: [String: Any] = [
          "PassportIDNo": CachingManager.loginObject()?.iDNo ?? "",
          "DrvPhone": CachingManager.loginObject()?.mobileNo ?? "",
          "DrvEmail": CachingManager.loginObject()?.email ?? "",
          "Reservation": [
            "ReservationNo": reservationCode,
            "ReservationStatus": ApiReservationStatus.cancelReservation.rawValue,
            "DriverCode": driverCode,
          ]
        ]
        CustomLoader.customLoaderObj.startAnimating()
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.createReservation.rawValue, type: .post,ReservationModelJson.self)?.response(error: { err in
            DispatchQueue.main.async{
                self.alertUser(title:"login_error".localized,msg: err.localizedDescription)
            }
        }, receiveValue: { response in
            if response?.reservationDetails?.success == "Y" {
                DispatchQueue.main.async{
                    self.alertUser(title: "alert_success".localized,msg: "rental_BookingCancell".localized)
                    self.returnToMyBookings?()
                }
            }else{
                DispatchQueue.main.async{
                    self.alertUser(title:"login_error".localized,msg:response?.reservationDetails?.varianceReason ?? "Error Occured")
                }
            }
            CustomLoader.customLoaderObj.stopAnimating()

        }).store(self)
    }
//
//    func downloadInvoice(reservationNo: String?,
//                         mode:  String?,
//                         recieptAgreementNo:  String?,
//                         recieptInvoiceNumber:  String?) {
//
//        CustomLoader.customLoaderObj.startAnimating()
//
//        bookingService.printInvoicePdf(reservationNo: reservationNo, mode: mode, recieptAgreementNo: recieptAgreementNo, recieptInvoiceNumber: recieptInvoiceNumber) {  response in
//
//            CustomLoader.customLoaderObj.stopAnimating()
//            guard let response = response as? String else {return}
//
//            if let reponseObject = XMLMapper<RentProPrintRSMappable>().map(XMLString: response)  {
//                if   reponseObject.obj.success == "Y" {
//
//
//                let pdfUrl  = URL(string:  reponseObject.obj.documentPrint ?? "")
//                    do {
//
//                        let data =  try Data(contentsOf:pdfUrl!)
//
//                        let documentURLPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//
//                        guard let pdfDocumentsUrl = documentURLPath?.appendingPathComponent("PDF_Documents") else { return }
//                        try FileManager.default.createDirectory(atPath: pdfDocumentsUrl.path,
//                                                                withIntermediateDirectories: true,
//                                                                attributes: nil)
//
//                        let filePath = String(format: "%@/%@", pdfDocumentsUrl.path, "Booking.pdf")
//                        let fileURL = URL(fileURLWithPath: filePath)
//
//                        try data.write(to: fileURL, options: .atomicWrite)
//
//                        if mode == "I" {
//                            UIApplication.shared.open(pdfUrl!)
//                        } else  {
//                            self.openPDFWithURL?(fileURL  ?? URL(fileURLWithPath: ""))
//
//                        }
//
//
//                    } catch { }
//
//                } else {
//                    self.alertUser(title:"login_error".localized,msg: reponseObject.obj.varianceReason ?? "")
//                }
//
//            }
//
//
//        } failure: { response, error in
//
//        }
//
//
//    }
    
    private func alertUser(title:String,msg:String){
//         let banner = Banner(title: msg, image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
//         banner.dismissesOnTap = true
//         banner.show(duration: 5.0)
        CustomAlertController.initialization().showAlertWithOkButton(title:title,message: msg) { (index, title) in
             print(index,title)
        }
     }
    
}



extension RentalDetailsViewModel {
    
    
    func cancelBookingJsonWithFees(reservationCode:String) {//not implemnted yet
        CustomLoader.customLoaderObj.startAnimating()
        let paramsDic: [String: Any] = [
            "ReservationNo": reservationCode
        ]
        NewNetworkManager.instance.paramaters = paramsDic 
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.cancelBooking.rawValue, type: .post,CancelBooking.self)?.response(error: {  error in
            CustomLoader.customLoaderObj.stopAnimating()
            print(error,"ssss ",reservationCode)
        }, receiveValue: { [weak self] response in
            if response?.Success == "Y"{
                DispatchQueue.main.async{
                    self?.alertUser(title: "alert_success".localized,msg: "rental_BookingCancell".localized)
                    self?.returnToMyBookings?()
                }
            }else{
                DispatchQueue.main.async{
                    self?.alertUser(title:"login_error".localized,msg: "Error Occured")
                }
            }
        }).store(self)

    }
    
    func downloadInvoice(reservationNo: String?,
                                 mode:  String?,
                                 recieptAgreementNo:  String?,
                                 recieptInvoiceNumber:  String?) {
        CustomLoader.customLoaderObj.startAnimating()
        
        let paramsDic: [String: Any] = [
            "PrintFor": mode ?? "",
            "DocumentNumber": reservationNo ?? "",
            "ReceiptAgrNo": recieptAgreementNo ?? "",
            "ReceiptInvNo": recieptInvoiceNumber ?? "",
            "LicenseIdNo": CachingManager.loginObject()?.licenseNo ?? "",
            "MobileNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "PassportIdNumber": CachingManager.loginObject()?.iDNo ?? "",
            "InternetAddress": CachingManager.loginObject()?.email ?? ""
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.getPrintDocument.rawValue, type: .post,DocumentPrintResponseModel.self)?.response(error: { [weak self] error in
           // send error
            CustomLoader.customLoaderObj.stopAnimating()
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            CustomLoader.customLoaderObj.stopAnimating()
            guard let model = model else { return }
            if model.RentProPrintRS?.Success == "Y" {
                //let pdfUrl  = URL(string:  model.RentProPrintRS?.DocumentPrint ?? "")
                    do {
                        
                        let data =  Data.init(base64Encoded: model.RentProPrintRS?.DocumentPrint ?? "")

                        let documentURLPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

                        guard let pdfDocumentsUrl = documentURLPath?.appendingPathComponent("PDF_Documents") else { return }
                        try FileManager.default.createDirectory(atPath: pdfDocumentsUrl.path,
                                                                withIntermediateDirectories: true,
                                                                attributes: nil)

                        let filePath = String(format: "%@/%@", pdfDocumentsUrl.path, "Booking.pdf")
                        let fileURL = URL(fileURLWithPath: filePath)

                        try data?.write(to: fileURL, options: .atomicWrite)
                        
//                        if mode == "I" {
//                            UIApplication.shared.open(pdfUrl!)
//                        } else  {
                        self?.openPDFWithURL?(fileURL  ?? URL(fileURLWithPath: ""))
                      //  }
                        
                        
                    } catch (let err) {
                        print(err.localizedDescription)
                    }
            } else {
                self?.alertUser(title:"login_error".localized,msg: model.RentProPrintRS?.VarianceReason ?? "")
            }
        }).store(self)
    }
}
