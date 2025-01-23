//
//  MyRentalHistoryViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/07/1443 AH.
//

import UIKit
import XMLMapper

class GetRentalHistoryViewModel : BaseViewModel {
   
    
    //MARK: - Variabels
    var rentalCase:RentalCase?{
        didSet{
            itemLoaded = 0
        }
    }
    lazy var service = GetMyBookingsService()
    lazy var availalbeCarService = GetAvailabelCarsService()
    var carModels : [CarGroup]?
    lazy var bookings = [Reservation?]()
   // var invoices = [InvoiceRentalHistoryModel]()
    var invoicesJSon = [InvoiceJson]()
    var presentViewController: ((_ vc: UIViewController) -> ())?
    var startLoadingIndicator: (() -> ())?
    var stopLoadingIndicator: (() -> ())?
    var showNoBookingViewWithCount: ((_ count: Int?) -> ())?
    var itemLoaded = 0
    var reloadTableData: (() -> ())?
    var bookingStatus: String?
    var navigateToViewController: ((_ vc: UIViewController) -> Void)?
    var dismissViewController: (() -> Void)?
    let dispatchGroup = DispatchGroup()
 //   lazy var contracts =  [RentalHistoryModel?]()
    lazy var contractsJson =  [Agreement?]()

   
    //MARK: - APIs
    
    func getReservationHistory() {
        
        service.getMyRentalHistory(idnumber: CachingManager.loginObject()?.iDNo) { [weak self](repsonse) in
            guard let response = repsonse as? String else {return}
            self?.itemLoaded += 1
            let baseObject =  XMLMapper<BookingResponseModel>().map(XMLString: response)
            if baseObject?.response?.success == "Y" {
                   let onGoingBookings = baseObject?.response?.onGoing
                    let cancelledBookings = baseObject?.response?.cancelled
                    let completedBookings = baseObject?.response?.completed
                    
                    self?.bookings.append(contentsOf: onGoingBookings ?? [])
                    self?.bookings.append(contentsOf: completedBookings ?? [])
                    self?.bookings.append(contentsOf: cancelledBookings ?? [])
                    self?.showNoBookingViewWithCount?(self?.bookings.count)
                
               
                self?.reloadTableData?()
            } else  {
                self?.showNoBookingViewWithCount?(0)
                self?.alertUser(msg: baseObject?.response?.varianceReason ?? "")
            }
          
            
        } failure: { (reposne, failure) in
            
        }

        
    }
    
    func getReservationHistoryJson() {
        let paramsDic: [String: Any] = [
            "LicenseIdNo": CachingManager.loginObject()?.licenseNo ?? "",
            "MobileNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "PassportIdNumber": CachingManager.loginObject()?.iDNo ?? "",
            "InternetAddress": CachingManager.loginObject()?.email ?? ""
        ]
        dispatchGroup.enter()
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.reservationHistory.rawValue, type: .post,BookingResponseModelJson.self)?.response(error: {[weak self] err in
            print(err.localizedDescription)
            self?.dispatchGroup.leave()
        }, receiveValue: { [weak self] baseObject in
            self?.handleBookData(baseObject: baseObject?.bookingDataRS)
            self?.dispatchGroup.leave()
        }).store(self)
    }
    
    func handleBookData(baseObject: BookingDataRSJson?){
        if baseObject?.success == "Y" {
               let onGoingBookings = baseObject?.onGoing
                let cancelledBookings = baseObject?.cancelled
                let completedBookings = baseObject?.completed
            bookings.append(contentsOf: onGoingBookings?.reservation ?? [])
            bookings.append(contentsOf: completedBookings?.reservation ?? [])
            bookings.append(contentsOf: cancelledBookings?.reservation ?? [])
            showNoBookingViewWithCount?(bookings.count)
        } else  {
            showNoBookingViewWithCount?(0)
            alertUser(msg: baseObject?.varianceReason ?? "")
        }
    }
    
    
    func getInvoicesPaymentAgreementJson<T:Codable>(withTransaction : String?,type:T.Type) {
        
        let formatter = DateFormatter()
        //2016-12-08 03:37:22 +0000
        formatter.dateFormat = "dd/MM/yyyy"
        dispatchGroup.enter()
        formatter.locale = Locale(identifier: "en_US")
        let now = Date()
        let dateString = formatter.string(from:now)
        let paramsDic: [String: Any] = [
            "StartDate": "01/01/2010" ,
            "EndDate": dateString,
            "TransactionFor": withTransaction ?? "",
            "DriverCode": CachingManager.loginObject()?.driverCode ?? "",
            "LicenseIdNo": CachingManager.loginObject()?.licenseNo ?? "",
            "MobileNumber": CachingManager.loginObject()?.mobileNo ?? "",
            "PassportIdNumber": CachingManager.loginObject()?.iDNo ?? "",
            "InternetAddress": CachingManager.loginObject()?.email ?? ""
          ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.trasactionData.rawValue, type: .post,T.self)?.response(error: {[weak self] err in
            print(err.localizedDescription)
            self?.dispatchGroup.leave()
        }, receiveValue: {[weak self] response in
            if let reponseObject = response as? InvoicesRentalHistoryModelJson{
                if reponseObject.transactionRS?.invoices != nil {
                    self?.invoicesJSon = reponseObject.transactionRS?.invoices?.invoice?.filter{ Double("\($0.invoiceBalance ?? "")") ?? 0.0 > 0.0} ?? []
                    self?.showNoBookingViewWithCount?(self?.invoicesJSon.count)
                }
            }
            
            if let reponseObject = response as? AgreementRentalModal{
                
                self?.contractsJson = reponseObject.transactionRS?.agreements?.agreement ?? []
                self?.showNoBookingViewWithCount?(self?.contractsJson.count)
            }
            self?.dispatchGroup.leave()
        }).store(self)
    }

    
    private func alertUser(msg:String){

        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    
    func selectedRentalItem(index: Int, img: UIImage? = nil) {
        var reservationNumber = ""
        var invoiceNumber = ""
        
        guard let rentalCase = rentalCase else {
            return
        }
        
        var associatedObject: RentalCase?
        
        switch rentalCase {
        case .booking:
            if let booking = booking(atIndex: index) {
                associatedObject = .booking(val: booking)
                reservationNumber = booking.reservationNo ?? ""  // Get the reservation number from booking
            }
            
        case .contracts:
            if let contract = contract(atIndex: index) {
                associatedObject = .contracts(val: contract)
                reservationNumber = contract.reservationNo ?? ""  // Assuming contract has a reservation number
            }
            
        case .unpaid:
            if let invoice = invoice(atIndex: index) {
                associatedObject = .unpaid(val: invoice)
                invoiceNumber = invoice.invoiceNo ?? ""  // Assuming invoice has a reservation number
            }
            
        case .all:
            if let rentalItem = rentalItem(atIndex: index) {
                associatedObject = .all(val: rentalItem)
                invoiceNumber = rentalItem.invoiceNumber ?? ""
                reservationNumber = rentalItem.reservationNumber ?? ""
            }
        }
        
        let rentalVC = RentalDetailsVC.initializeFromStoryboard()
        rentalVC.rentalCase = associatedObject
        rentalVC.imageCar = img
        rentalVC.reservationNumber = reservationNumber
        rentalVC.invoiceNumber = invoiceNumber
        
        if RentalDetailsVC.bookings.isEmpty {
            RentalDetailsVC.bookings = bookings
            print(RentalDetailsVC.bookings.count)
        }
        
        print("Reservation Number: \(reservationNumber)")  // Print the reservation number for debugging
        
        presentViewController?(rentalVC)
    }

//    func selectedRentalItem(index:Int,img:UIImage? = nil) {
//        var reservationNumber = ""
//        var invoiceNumber = ""
//        guard let rentalCase = rentalCase else {
//            return
//        }
//        var associatedObject:RentalCase?
//        switch rentalCase {
//        case .booking:
//            associatedObject = .booking(val:booking(atIndex: index))
//        case .contracts:
//            associatedObject = .contracts(val:contract(atIndex: index))
//        case .unpaid:
//            associatedObject = .unpaid(val: invoice(atIndex: index))
//        case .all:
//            associatedObject = .all(val: rentalItem(atIndex: index))
//        }
//        let rentalVC = RentalDetailsVC.initializeFromStoryboard()
//        rentalVC.rentalCase = associatedObject
//        rentalVC.imageCar = img
//        if RentalDetailsVC.bookings.isEmpty{
//            RentalDetailsVC.bookings = bookings
//            print(RentalDetailsVC.bookings.count)
//        }
//        presentViewController?(rentalVC)
//    }
//    
//    func getAvailableCars(_ vechCode: String? = nil) {
//
//        availalbeCarService.getAvailableCarsSerivce(vehicleTypeCode: vechCode) { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<CarModelBaseObject>().map(XMLString: response) {
//                self?.carModels = responseObject.soapEnvelopeOuter ?? [CarModelObject]()
//                CachingManager.setCarModels(responseObject.soapEnvelopeOuter)
//            }
//
//        } failure: { (response, error) in
//
//        }
//
//
//
//    }
    

    func getCarImageFromContracts(_ carGroup :  String?) -> String? {
        
        guard  let carModel =  self.carModels?.filter({ $0.group == carGroup }).first as? CarGroup else {return nil}
         
     
         return carModel.group
        
    }
    
    
    func convetAllToRentalItem() -> [RentalItem?]? {
        
        var rentalItems  = [RentalItem?]()
       
        for item in bookings {
            let bookingItem =  self.convertBookingOrContractOrAgreementToRentalItem(booking: item)
            rentalItems.append(bookingItem)

        }
        
        for item in contractsJson {
            let contractItems =  self.convertBookingOrContractOrAgreementToRentalItem(contract: item)
            rentalItems.append(contractItems)
        }
        
        
       
        
        for item in invoicesJSon{
            let invoiceItem =  self.convertBookingOrContractOrAgreementToRentalItem( invoice: item)
            rentalItems.append(invoiceItem)
        }
        
        _ = removeDuplicateElements(posts: rentalItems)
        
        return rentalItems
    }
    
    func removeDuplicateElements(posts: [RentalItem?]) -> [RentalItem] {
        var uniquePosts = [RentalItem]()
        for post in posts {
            if !uniquePosts.contains(where: {$0.reservationNumber == post?.reservationNumber }) {
                uniquePosts.append(post ?? RentalItem())
            }
        }
        return uniquePosts
    }
    
    
//    func convertBookingOrContractOrAgreementToRentalItem(booking: Reservation? = nil  , invoice: InvoiceRentalHistoryModel? = nil , contract : RentalHistoryModel? = nil ) -> RentalItem? {
    func convertBookingOrContractOrAgreementToRentalItem(booking: Reservation? = nil  , invoice: InvoiceJson? = nil , contract : Agreement? = nil ) -> RentalItem? {
         let rentalItem = RentalItem()
        if (booking != nil) {
            rentalItem.isBooking = true
            rentalItem.isContract = false
            rentalItem.isInvoice = false
            rentalItem.discountAmount = booking?.totalDiscount
            rentalItem.pickTime = booking?.checkOutTime
            rentalItem.returnTime = booking?.checkInTime
            rentalItem.pickupDate = booking?.checkOutDate
            rentalItem.returnDate = booking?.checkInDate
            rentalItem.totalAmount = booking?.totalWithTax
            rentalItem.carRentalAmount = booking?.rentalCharge
           
            rentalItem.totalPaid = booking?.totalPaid
            rentalItem.carImage = booking?.carGroup
          //  rentalItem.carImage = booking?.carGroupImagePath
            rentalItem.pickupBranch = booking?.checkInBranch
            rentalItem.returnBBranch = booking?.checkOutBranch
            rentalItem.carModel = booking?.carGroupDescription
            rentalItem.status = booking?.reservationStatus
            rentalItem.extraxSum = booking?.extrasCharge
            rentalItem.rentalSum = booking?.rentalCharge
            rentalItem.extraFeesVal = booking?.extrasCharge
            rentalItem.rateName = booking?.rateName
            rentalItem.deliveryFees = booking?.dropOffCharge
            rentalItem.reservationNumber = booking?.reservationNo
            rentalItem.resnumforCancel = booking?.internetReservationNo
            rentalItem.insuranceAmount = booking?.insuranceCharge
            rentalItem.vatAmount = booking?.salesTax
            rentalItem.internetReservationNo = booking?.internetReservationNo
            
        } else if (contract != nil) {
            rentalItem.isBooking = false
            rentalItem.isContract = true
            rentalItem.isInvoice = false
            rentalItem.discountAmount = contract?.agreementDiscount
            rentalItem.pickupDate = contract?.checkInDate
            rentalItem.returnDate = contract?.checkOutDate
            rentalItem.carRentalAmount = contract?.agreementTotalRental
            rentalItem.pickupBranch = contract?.checkOutBranch
            rentalItem.returnBBranch = contract?.checkInBranch
            rentalItem.pickTime = contract?.agreementCheckOutTime
            rentalItem.totalPaid = contract?.tOTALPAID
            rentalItem.returnTime = contract?.agreementCheckOutTime
            rentalItem.reservationNumber = contract?.agreementNo
            rentalItem.insuranceAmount = contract?.agreementInsurance?.first?.amount
            rentalItem.carImage = getCarImageFromContracts(contract?.agreementChargeGroup)
            rentalItem.totalAmount = contract?.tOTALAMOUNT
            rentalItem.carModel = contract?.agreementModelName
            rentalItem.extraxSum = contract?.agreementExtras?.first?.amount
            rentalItem.rentalSum = contract?.agreementTotalRental
            rentalItem.extraFeesVal = contract?.agreementExtras?.first?.amount//to ask mostafa about the different between extraFeesVal , extraxSum
            rentalItem.deliveryFees = contract?.agreementDropOff
            let vatAmount = Double(contract?.tOTALAMOUNT ?? "0") ?? 0 * 15
            let finalVat = vatAmount / 100
            rentalItem.vatAmount = finalVat.description
            
        } else if (invoice != nil) {
            rentalItem.isBooking = false
            rentalItem.isContract = false
            rentalItem.isInvoice = true
            rentalItem.carModel = invoice?.invoiceAgrCarModel
            rentalItem.reservationNumber = invoice?.invoiceNo
            rentalItem.totalInvoice = invoice?.invoiceTotal
            rentalItem.discountAmount = invoice?.invoiceDiscountAmount
            rentalItem.totalPaidInvoice = invoice?.invoiceAmountPaid
            rentalItem.pickupDate = invoice?.invoiceAgrOutDate
            rentalItem.returnDate = invoice?.invoiceAgrInDate
            rentalItem.carRentalAmount = invoice?.invoiceRental
            rentalItem.totalBalance = invoice?.invoiceBalance
            rentalItem.totalAmount = invoice?.invoiceTotal
            rentalItem.pickTime = invoice?.invoiceAgrOutTime
            rentalItem.pickupBranch = invoice?.invoiceAgrOutBranch
            rentalItem.returnBBranch = invoice?.invoiceAgrInBranch
            rentalItem.carImage  = getCarImageFromContracts(invoice?.invoiceAgrChargeGroup)
            rentalItem.returnTime = invoice?.invoiceAgrInTime
            rentalItem.extraxSum = invoice?.invoiceOtherAmount
            rentalItem.rentalSum = invoice?.invoiceRental
            rentalItem.extraFeesVal = invoice?.invoiceOtherAmount
            rentalItem.deliveryFees = invoice?.invoiceDropOff
      //      rentalItem.insuranceAmount = invoice?.invoiceInsurances?.amount
            rentalItem.vatAmount = invoice?.invoiceVat
            rentalItem.invoiceNumber = invoice?.invoiceNo
        }
        
        
        return rentalItem
    }
    
    
    
    
//    func getInvoicesPaymentAgreement(withTransaction : String?) {
//
//        let formatter = DateFormatter()
//        //2016-12-08 03:37:22 +0000
//        formatter.dateFormat = "dd/MM/yyyy"
//
//        formatter.locale = Locale(identifier: "en_US")
//        let now = Date()
//        let dateString = formatter.string(from:now)
//        service.getInvoicesPaymentsAgremments(driverCode: CachingManager.loginObject()?.driverCode ?? "", transactionFor: withTransaction, startDate: "01/01/2010", endDate: dateString) { [weak self] (response) in
//
//            guard let self = self else {return}
//            guard let response = response as? String else {return}
//            self.itemLoaded += 1
//            if let reponseObject = XMLMapper<RentalHistoryMappable>().map(XMLString: response)  {
//                if reponseObject.success == "Y" {
//
//
//                    if withTransaction ==  TransactionsType.Agreements {
//
//                        self.contracts = reponseObject.rentalModelobj.rentalModelArray ?? []
//                        self.showNoBookingViewWithCount?(self.contracts.count)
//                        self.reloadTableData?()
//
//                    } else if  withTransaction ==  TransactionsType.Invoices {
//                        if reponseObject.invoiceRentalModel.invoiceRentalModelArray != nil {
//
//                        self.invoices = reponseObject.invoiceRentalModel.invoiceRentalModelArray.filter{ Double("\($0.invoiceBalance ?? "")") ?? 0.0 != 0.0}
//                        self.showNoBookingViewWithCount?(self.invoices.count)
//                      } else {
//                          self.showNoBookingViewWithCount?(0)
//                      }
//                    }
//
//                }
//
//
//                self.reloadTableData?()
//
//                }
//
//
//        } failure: { (response, error) in
//
//        }
//
//
//
//    }

    func getAllMyRentalData() {
        getAvailableCars()
        getReservationHistoryJson()
        getInvoicesPaymentAgreementJson(withTransaction: TransactionsType.Invoices, type: InvoicesRentalHistoryModelJson.self)
        getInvoicesPaymentAgreementJson(withTransaction: TransactionsType.Agreements, type: AgreementRentalModal.self)
        dispatchGroupNotify()
        
    }
    
    func dispatchGroupNotify(){
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.reloadTableData?()
        }
    }
    
    //MARK: - Helper Methods
    
    func numberOfBookings() -> Int? {
        
        return bookings.count
    }
    
    func booking(atIndex index: Int) -> Reservation? {
        
        return bookings[index]
        
    }
    
    func rentalItem(atIndex index: Int) -> RentalItem? {
        let rentalArr = convetAllToRentalItem()
        return rentalArr?[index]
    }
    
    func clearBookings() {
    
        bookings.removeAll()
        reloadTableData?()
    }
    
    func numberOfContracts() -> Int? {
        
       // return contracts.count
        contractsJson.count
    }
    
    func contract(atIndex index: Int) -> Agreement? {
        
      //  return contracts[index]
        contractsJson[index]
    }
    
    func clearContracts() {
    
        //contracts.removeAll()
        contractsJson.removeAll()
        reloadTableData?()
    }
    
    func numberOfInvoices() -> Int? {
        
        return invoicesJSon.count
    }
    
  //  func invoice(atIndex index: Int) -> InvoiceRentalHistoryModel? {
    func invoice(atIndex index: Int) -> InvoiceJson? {
       // return invoices[index]
        invoicesJSon[index]
    }
    
    func clearInvoices() {
    
        //invoices.removeAll()
        invoicesJSon.removeAll()
        reloadTableData?()
    }
    
    func clearAll() {
        
    clearInvoices()
    clearContracts()
    clearBookings()
        
    }
    
    func getAll() -> Int? {
        
        let all = (numberOfContracts() ?? 0 ) + (numberOfInvoices() ?? 0) + (numberOfBookings() ?? 0)
        
        
        return all
    
    }
    
    
    
    
}


extension GetRentalHistoryViewModel {
        
        func getAvailableCars(_ vechCode: String? = nil) {
            let paramsDic: [String: Any] = [
                "VehicleType": vechCode ?? ""
            ]
            NewNetworkManager.instance.paramaters = paramsDic
            NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.carGroup.rawValue, type: .post,CarGroupResponse.self)?.response(error: { [weak self] error in
               // send error
//                CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                     print(index,title)
//                }
            }, receiveValue: { [weak self] model in
                guard let model = model else { return }
                if model.CarGroup?.success == "True" {
                    self?.carModels = model.CarGroup?.groups
                    CachingManager.setCarModels(model.CarGroup?.groups)
                } else {
                    CustomAlertController.initialization().showAlertWithOkButton(message: "error_Occured_msg".localized) { (index, title) in
                         print(index,title)
                    }
                }
            }).store(self)
        }
    }

