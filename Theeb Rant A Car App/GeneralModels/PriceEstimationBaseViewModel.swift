//
//  PriceEstimationBaseViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 16/08/2023.
//

import Foundation

class PriceEstimationBaseViewModel:BaseViewModel{
  
    
    func  getPriceEstimetaionJson (getCarsVC:UIViewController? = nil,isCustomLoader:Bool? = nil ,outBranch: Int?,inBranch:Int?,outDate: String?,inDate:String?,outTime: String?,inTime: String?,vehicleType : String?,driverCode : String? ,carGroup: String?, selectedInsurance: String?, insuranceCode: String?, InsuranceQuantitiy: String?,extras:[ExtrasInsurenceData]?,success:@escaping ((Codable)->Void),err:@escaping ((Error)->Void)) {
        let jsonEncoder = JSONEncoder()
        let bookedObject = Booked(Extra: extras, Insurance: [ExtrasInsurenceData(code: insuranceCode, name: selectedInsurance, quantity: InsuranceQuantitiy)])
        let jsonData = (try? jsonEncoder.encode(bookedObject)) ?? Data()
        let jsonBooked = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
        let paramsDic: [String: Any] = [
            "Price": [
                
                "CDP": CachingManager.priceEstimateCDP(),
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
                "Booked":jsonBooked ,
                "VEHICLETYPE": nil,
                "VoucherNo": nil,
                "VoucherType": nil
            ]
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.priceEstimation.rawValue, type: .post,PriceEstimationMappableResponseJson.self)?.response(error: err, receiveValue: success).store(self)
    }
    
    func getCarListPriceEstimation(getCarsVC:UIViewController?,success:@escaping ((Codable)->Void),err:@escaping ((Error)->Void)){
        let startDatePrice = Date().changeDateFormat(format: "dd/MM/yyyy")
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let endDatePrice = endDate.changeDateFormat(format: "dd/MM/yyyy")
        getPriceEstimetaionJson(getCarsVC:getCarsVC,outBranch:97 , inBranch: 97, outDate: startDatePrice, inDate: endDatePrice, outTime: "19:41", inTime: "19:40", vehicleType: "", driverCode: "", carGroup: "", selectedInsurance: "", insuranceCode: "", InsuranceQuantitiy: "", extras: [], success: success, err: err)
    }
}
