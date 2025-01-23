//
//  CheckoutViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 02/08/1443 AH.
//

import UIKit
import XMLMapper
import Combine

class CheckOutViewModel:PriceEstimationBaseViewModel {
    
    var slectedextras = [ExtType?]()
    var showContentView: (() -> ())?
    var showLoading : (() -> ())?
    var hideLoadding: (() -> ())?
    var presentViewController: ((_ vc: UIViewController) -> Void)?
    var pushViewController: ((_ vc: UIViewController) -> Void)?
    var insurancePrice : String?

    var slectedInsurance : String?
    var slectedInsuranceCode : String?
    lazy var service = CheckoutService()
   // var priceEstimationMappableResponse: PriceEstimationMappableResponse?
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?
    var outBranch: Int?
    var selectedCarObject :CarGroup?
    var  inBranch:Int?
    var  outDate: String?
    var  inDate:String?
    var  outTime: String?
    var  inTime: String?
    var  vehicleType : String?
    var  driverCode : String? = CachingManager.loginObject()?.driverCode
   // var priceEstimatGroupModel : CarGroupModel?
   // var fillPriceEstimationView: ((_ carPriceModel:CarGroupModel?) -> ())?
    var priceEstimatGroupModelJson : CarGroupPrice?
    var fillPriceEstimationViewJson: ((_ carPriceModel:CarGroupPrice?) -> ())?
    
//    func  getPriceEstimetaion (isCustomLoader:Bool ,outBranch: String?,inBranch:String?,outDate: String?,inDate:String?,outTime: String?,inTime: String?,vehicleType : String?,driverCode : String? ,carGroup: String?, selectedInsurance: String?, insuranceCode: String?, InsuranceQuantitiy: String?) {
//
//        service.getPriceEstgetPriceEstimtion(isCustomLoader: isCustomLoader, outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, carGroup: carGroup, selectedInsurance: selectedInsurance,insuranceCode: insuranceCode,insuranceQuantity: InsuranceQuantitiy, vehicleType: vehicleType, driverCode: driverCode, extras: slectedextras, success: {  [weak self ] (response) in
//
//
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<PriceEstimationMappableResponse>().map(XMLString: response) {
//                self?.priceEstimationMappableResponse = responseObject
//
//                let  filteredObject = self?.priceEstimationMappableResponse?.priceResponseModel.carGroupModel?.filter({$0.carGrop == self?.selectedCarObject?.group}).first
//                self?.priceEstimatGroupModel = filteredObject
//                self?.fillPriceEstimationView?(filteredObject)
//                self?.showContentView?()
//
//            }
//
//        }, failure: nil)
//
//
//
//
//    }
//
    /*
    func  getPriceEstimetaionJSon (isCustomLoader:Bool ,outBranch: String?,inBranch:String?,outDate: String?,inDate:String?,outTime: String?,inTime: String?,vehicleType : String?,driverCode : String? ,carGroup: String?, selectedInsurance: String?, insuranceCode: String?, InsuranceQuantitiy: String?,extras:[ExtrasInsurenceData]?) {
        
        let paramsDic: [String: Any] = [
            "Price": [
                
                "CDP": nil,
                "InBranch": inBranch,
                "InDate": inDate,
                "InTime": inTime,
                "OutBranch": outBranch,
                "OutDate": outDate,
                "OutTime": outTime,
                "CarGroup": carGroup,
                "Currency": "SAR",
                "DebitorCode": nil,
                "DriverCode": driverCode,
                "Booked": [
                    "Extra":extras ?? [],
                    "Insurance": [
                        [
                        "Code": insuranceCode,
                        "Name": "THEEB Insurance",
                        "Quantity": InsuranceQuantitiy
                        ]
                    ]
                ],
                "VEHICLETYPE": nil,
                "VoucherNo": nil,
                "VoucherType": nil
            ]
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.priceEstimation.rawValue, type: .post,PriceEstimationMappableResponseJson.self)?.response(error: { err in
            print(err.localizedDescription)
        }, receiveValue: {[weak self] responseObject in
            self?.updatePrice(responseObject)
        }).store(self)
    }
    */
    
    func usePriceEstimation(isCustomLoader:Bool ,outBranch: String?,inBranch:String?,outDate: String?,inDate:String?,outTime: String?,inTime: String?,vehicleType : String?,driverCode : String? ,carGroup: String?, selectedInsurance: String?, insuranceCode: String?, InsuranceQuantitiy: String?,extras:[ExtrasInsurenceData]?){
        getPriceEstimetaionJson(isCustomLoader: isCustomLoader, outBranch: Int(outBranch ?? ""), inBranch: Int(inBranch ?? ""), outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType, driverCode: driverCode, carGroup: carGroup, selectedInsurance: selectedInsurance, insuranceCode: insuranceCode, InsuranceQuantitiy: InsuranceQuantitiy, extras: extras) {[weak self] response in
            if let responsePrice = response as? PriceEstimationMappableResponseJson{
                self?.updatePrice(responsePrice)
            }
        } err: { err in
            print(err.localizedDescription)

        }

    }
    func updatePrice(_ responseObject: PriceEstimationMappableResponseJson?){
        priceEstimationMappableResponseJson = responseObject
        let filteredObject = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == selectedCarObject?.group}).first
        priceEstimatGroupModelJson = filteredObject
        fillPriceEstimationViewJson?(filteredObject)
        showContentView?()
    }

    func createInsuranceArray(insuranceArray: [ExtrasInsurenceData?]) -> [[String:Any]] {
        var insuranceArrayTemp = [[String:Any]]()
        for item in insuranceArray {
            let insuranceObject: [String:Any] = [
                "Code": item?.Code ?? "",
                "Name": item?.Name ?? "",
                "Quantity": item?.Quantity ?? ""
            ]
            insuranceArrayTemp.append(insuranceObject)
        }
        return insuranceArrayTemp
    }
    
    func createExtraArray(extraArray: [ExtrasInsurenceData?]) -> [[String:Any]] {
        var extraeArrayTemp = [[String:Any]]()
        for item in extraArray {
            let extraObject: [String:Any] = [
                "Code": item?.Code ?? "",
                "Name": item?.Name ?? "",
                "Quantity": item?.Quantity ?? ""
            ]
            extraeArrayTemp.append(extraObject)
        }
        return extraeArrayTemp
    }
    
    
    func createReservationJson(firstName : String,
                           lastName: String,
                           reservationCode : String,
                           outBranch: Int,
                           inBranch:Int,
                           outDate: String,
                           inDate:String,
                           outTime: String,
                           inTime: String,
                           driverCode : String,
                           driverLicenseNumber: String,
                           cdp:String,
                           rateNo: String,
                           resevationNumber: String,
                           rentalSum: String,
                           carGroup : String,
                           insurance:[ExtrasInsurenceData?],
                           extras:[ExtrasInsurenceData?]) {
//        let jsonEncoder = JSONEncoder()
//        let jsonData = (try? jsonEncoder.encode(extras)) ?? Data()
//        let jsonExtras = String(data: jsonData, encoding: String.Encoding.utf8)
        let insuranceArray = createInsuranceArray(insuranceArray: insurance)
        let extraArray = createExtraArray(extraArray: extras)
 
        let paramsDic: [String: Any] = [
          "Reservation": [
            "LicenseNo": driverLicenseNumber,
            "LastName": lastName,
            "FirstName": firstName,
            "CDP": CachingManager.priceEstimateCDP(),
            "OutBranch": outBranch,
            "InBranch": inBranch,
            "OutDate": outDate,
            "OutTime": outTime,
            "InDate": inDate,
            "InTime": inTime,
            "RateNo": rateNo,
            "CarGroup": carGroup,
            "Currency": "SAR",
            "RentalSum": rentalSum,
            "ReservationNo": reservationCode,
            "ReservationStatus": ApiReservationStatus.newReservation.rawValue,
            "CarMake": nil,
            "CarModel": nil,
            "DriverCode": driverCode,
            "PassportIDNo": CachingManager.loginObject()?.iDNo ?? "",
            "DrvPhone": CachingManager.loginObject()?.mobileNo ?? "",
            "DrvEmail": CachingManager.loginObject()?.email ?? "",
            "Remarks":"IOS-APP",
            "Booked":[
              "Extra": extraArray,
              "Insurance": insuranceArray
            ]
          ]
        ]
        showLoading?()
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.createReservation.rawValue, type: .post,ReservationModelJson.self)?.response(error: { err in
            CustomLoader.customLoaderObj.stopAnimating()
            print(err.localizedDescription)
        }, receiveValue: {[weak self] reponseObject in
            guard let self = self else {return}
            self.hideLoadding?()
            if reponseObject?.reservationDetails?.success == "Y" {
                AppsFlyerManager.logPrimaryEventBooking(eventName: "af_Booking-Completion", amount: Double(rentalSum) ?? 0)
                let successVC = SucessScreenForBookingVC.initializeFromStoryboard()
                successVC.titleString  =  "success_screen_your_booking_created_succefully".localized
                successVC.isFromPayment = false
                //successVC.bookingNumber = reservationCode
                successVC.bookingNumber = reponseObject?.reservationDetails?.reservationNo ?? reservationCode
                self.pushViewController?(successVC)
                
            } else {
                CustomLoader.customLoaderObj.stopAnimating()
                CustomAlertController.initialization().showAlertWithOkButton(message: reponseObject?.reservationDetails?.varianceReason ?? "Error Occured") { (index, title) in
                     print(index,title)
                }
            }
        }).store(self)
        
    }
    
    func createReservation(firstName : String?,
                           lastName: String?,
                           reservationCode : String?,
                           outBranch: String?,
                           inBranch:String?,
                           outDate: String?,
                           inDate:String?,
                           outTime: String?,
                           inTime: String?,
                           vehicleType : String?,
                           driverCode : String?,
                           driverLicenseNumber: String?,
                           cdp:String?,
                           rateNo: String?,
                           resevationNumber: String?,
                           rentalSum: String?,
                           carGroup : String?,
                           insuranceCode: String?,
                           insuranceQuantity:String?,
                           extras:[ExtraListXmlModel?]) {
        
        self.showLoading?()
        service.createReservation(firstName: CachingManager.loginObject()?.firstName, lastName: CachingManager.loginObject()?.lastName, reservationCode: reservationCode, outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType, driverCode: driverCode, driverLicenseNumber: CachingManager.loginObject()?.licenseNo, cdp: cdp, rateNo: rateNo, rentalSum: rentalSum, carGroup: carGroup, insuranceCode: insuranceCode, insuranceQuantity: insuranceQuantity, extras: extras) { (response) in
            
            guard let response = response as? String else {return}
            
            if let reponseObject = XMLMapper<ReservationMappable>().map(XMLString: response) {
                self.hideLoadding?()
                if reponseObject.reservationDetails.success == "Y" {
                    let successVC = SucessScreenForBookingVC.initializeFromStoryboard()
                    successVC.titleString  =  "success_screen_your_booking_created_succefully".localized
                    successVC.bookingNumber = reservationCode ?? ""
                    successVC.isFromPayment = false
        
                 //   successVC.bookingNumber =  rese
                    self.pushViewController?(successVC)
                    
                } else {
                    CustomLoader.customLoaderObj.stopAnimating()
//                    let banner = Banner(title:reponseObject.reservationDetails.varianceReason, image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
//                    banner.dismissesOnTap = true
//                    banner.show(duration: 5.0)
                    CustomAlertController.initialization().showAlertWithOkButton(message: reponseObject.reservationDetails.varianceReason) { (index, title) in
                         print(index,title)
                    }
                }
            }
            
        } failure: { (response, error) in
            
            CustomLoader.customLoaderObj.stopAnimating()
            
            
        }

       

        
    }
    
    // MARK: - Helper Methods
    
    
     func returnVarianceReason(resultString : String?) -> String?{
         var varianceString = String()
        let resultString1 =  (resultString!).components(separatedBy: ">")
        if (resultString1.count >= 7)
        {
            _ = (resultString1[7]).replacingOccurrences(of: "</VarianceReason", with: "")
            for obj in resultString1
            {
                if(obj.contains("</VarianceReason"))
                {
                    let stringFilter = (resultString1[7] ?? "").replacingOccurrences(of: "</VarianceReason", with: "")
                    varianceString = stringFilter
                }
            }
            
        }
        return varianceString
    }
    
    
    
    
}
