//
//  BillViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 23/08/1443 AH.
//

import UIKit
import XMLMapper

class BillsViewModel:BaseViewModel {

    
    lazy var service  = GetMyBookingsService()
   // var invoices = [InvoiceRentalHistoryModel]()
    var invoicesJson = [InvoiceJson]()
    var paidBills = [InvoiceRentalHistoryModel]()
//    var upaidBills = [InvoiceRentalHistoryModel]()
    var upaidBillsJson = [InvoiceJson]()
    var reloadTableData: (() -> ())?
    var showLoading: (() -> ())?
    var hideLoadding: (() -> ())?
    var openPDFWithURL: ((_ pdfText: String) -> ())?
    var showNoBillsLabel: ((_ count:Int? , _ title: String?, _ subTitle: String?) -> ())?
    var presentViewController: ((_ vc: UIViewController) -> ())?
    var rentalCase:RentalCase?
  //  var allInvoices  = [InvoiceRentalHistoryModel]()
    var allInvoicesJson  = [InvoiceJson]()
    var showNoBookingViewWithCount: ((_ count: Int?) -> ())?
    
//    func getBillsHistory() {
//       // CustomLoader.customLoaderObj.startAnimating()
//        let formatter = DateFormatter()
//        //2016-12-08 03:37:22 +0000
//        formatter.dateFormat = "dd/MM/yyyy"
//        formatter.locale = Locale(identifier: "en_US")
//
//        let now = Date()
//        let dateString = formatter.string(from:now)
//
//        service.getInvoicesPaymentsAgremments(driverCode: CachingManager.loginObject()?.driverCode, transactionFor: TransactionsType.Invoices, startDate: "01/01/2010", endDate: dateString) {[weak self] (response) in
//
//            guard let self = self else {return}
//            guard let response = response as? String else {return}
//
//            if let reponseObject = XMLMapper<RentalHistoryMappable>().map(XMLString: response)  {
//                if reponseObject.success == "Y" {
//                    if   reponseObject.invoiceRentalModel.invoiceRentalModelArray != nil {
//                        self.allInvoices = reponseObject.invoiceRentalModel.invoiceRentalModelArray ?? []
//
//                         self.invoices =   reponseObject.invoiceRentalModel.invoiceRentalModelArray.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0 == 0.0}
//                        self.upaidBills =   reponseObject.invoiceRentalModel.invoiceRentalModelArray.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0 != 0.0}
//                        self.showNoBookingViewWithCount?(self.invoices.count)
//
//                    } else {
//
//                        self.showNoBookingViewWithCount?(0)
//                    }
//
//
////                    self.upaidBills = reponseObject.invoiceRentalModel.invoiceRentalModelArray.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0
////                          > 0.0 }
////                    self.paidBills =     self.invoices.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0  ==   0.0 }
////
////
////
//
//
//
//                }
//
//                self.reloadTableData?()
//
//            }
//       //     CustomLoader.customLoaderObj.stopAnimating()
//
//        } failure: { (response, error) in
//          //  CustomLoader.customLoaderObj.stopAnimating()
//        }
//
//
//    }
    
    
    func getBillsHistoryJson() {
        
        let formatter = DateFormatter()
        //2016-12-08 03:37:22 +0000
        formatter.dateFormat = "dd/MM/yyyy"
  
        formatter.locale = Locale(identifier: "en_US")
        let now = Date()
        let dateString = formatter.string(from:now)
        let paramsDic: [String: Any] = [
            "StartDate": "01/01/2010" ,
            "EndDate": dateString,
            "TransactionFor": TransactionsType.Invoices,
            "DriverCode": CachingManager.loginObject()?.driverCode ?? "",
            "LicenseIdNo": CachingManager.loginObject()?.licenseNo ?? "",
            "MobileNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "PassportIdNumber": CachingManager.loginObject()?.iDNo ?? "",
            "InternetAddress": CachingManager.loginObject()?.email ?? ""
          ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.trasactionData.rawValue, type: .post,InvoicesRentalHistoryModelJson.self)?.response(error: { err in
            print(err.localizedDescription)
        }, receiveValue: { response in
            if let reponseObject = response{
                if reponseObject.transactionRS?.invoices != nil {
                    self.allInvoicesJson = reponseObject.transactionRS?.invoices?.invoice ?? []
                    
                    self.invoicesJson =   reponseObject.transactionRS?.invoices?.invoice?.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0 <= 0.0} ?? []
                    self.upaidBillsJson =   reponseObject.transactionRS?.invoices?.invoice?.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0 > 0.0} ?? []
                    self.showNoBookingViewWithCount?(self.invoicesJson.count)
                    self.reloadTableData?()
                } else {
                    
                    self.showNoBookingViewWithCount?(0)
                }
            }
            
         
        }).store(self)
    }

//
//    func downloadInvoice(reservationNo: String?,
//                         mode:  String?,
//                         recieptAgreementNo:  String?,
//                         recieptInvoiceNumber:  String?) {
//        self.showLoading?()
//        service.printInvoicePdf(reservationNo: reservationNo, mode: mode, recieptAgreementNo: recieptAgreementNo, recieptInvoiceNumber: recieptInvoiceNumber) {  response in
//
//
//            guard let response = response as? String else {return}
//            self.hideLoadding?()
//
//            if let reponseObject = XMLMapper<RentProPrintRSMappable>().map(XMLString: response)  {
//                if   reponseObject.obj.success == "Y" {
//
//
//                let pdfUrl  = URL(string:  reponseObject.obj.documentPrint ?? "")
//                    do {
//
//
//                        self.openPDFWithURL?(pdfUrl  ?? URL(fileURLWithPath: ""))
////                        self.reloadTableData?()
////                        self.getBillsHistory()
//                    } catch { }
//
//                } else {
//
//                    self.hideLoadding?()
//                    self.alertUser(msg: reponseObject.obj.varianceReason ?? "")
//                    self.getBillsHistory()
//                    self.reloadTableData?()
//
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
    
    private func alertUser(msg:String){

        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    
    
  
    
    //MARK: - Helper Methods
    
    func numberOfInvoicess() -> Int? {
        
        return invoicesJson.count
    }
    
    func invoice(atIndex index: Int) -> InvoiceJson? {
        
        return invoicesJson[index]
        
    }
    
    func filterBills() {
    
        
      let  filteredInvoices =   self.allInvoicesJson.filter { Double("\($0.invoiceBalance ?? "")") ?? 0.0  >  0.0 }
        
        self.invoicesJson = self.upaidBillsJson
        self.showNoBookingViewWithCount?(self.invoicesJson.count)
        reloadTableData?()
    }
    
    
    func selectedRentalItem(index:Int,isInvoicePaid:Bool) {
        let associatedObject = RentalCase.unpaid(val: invoice(atIndex: index))
        let rentalVC = RentalDetailsVC.initializeFromStoryboard()
        rentalVC.rentalCase = associatedObject
        rentalVC.isInvoicePaid = isInvoicePaid
        rentalVC.isFromBills = true
        presentViewController?(rentalVC)
    }
    
    func clearAll() {
        self.upaidBillsJson = []
        self.invoicesJson = []
        reloadTableData?()
        
    }  
    
}

extension BillsViewModel {
    
    func downloadInvoice(reservationNo: String?,
                                 mode:  String?,
                                 recieptAgreementNo:  String?,
                                 recieptInvoiceNumber:  String?) {
        self.showLoading?()

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
            self?.hideLoadding?()
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            self?.hideLoadding?()
            guard let model = model else { return }
            if model.RentProPrintRS?.Success == "Y" {
                let pdfUrl  = URL(string:  model.RentProPrintRS?.DocumentPrint ?? "")
                do {
                    
                    
                    self?.openPDFWithURL?(model.RentProPrintRS?.DocumentPrint ?? "")
                    //                        self.reloadTableData?()
                    //                        self.getBillsHistory()
                } catch { }
            } else {
                self?.alertUser(msg: model.RentProPrintRS?.VarianceReason ?? "")
                self?.getBillsHistoryJson()
                self?.reloadTableData?()
            }
        }).store(self)
    }
}
