//
//  CarDetailsViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 24/07/1443 AH.
//

import Foundation
import  XMLMapper


class CarDetailsViewModel:BaseViewModel {
    
  lazy var service = ExtrasService()
//    var extras = [ExtraListXmlModel?]()
//    var insurances = [InsuranceListXmlModel]()
    var insurancesJson = [InsType]()
    var extrasJson = [(ExtType,Bool)]()
    let dispatchGroup = DispatchGroup()
    var reloadTableData: (() -> ())?
    var showInsuranceName: (() -> ())?
    var  inBranch:Int?
    var  outBranch:Int?
    var  outDate: String?
    var  inDate:String?
    var  outTime: String?
    var  inTime: String?
    var  vehicleType : String?
    var  driverCode : String? = CachingManager.loginObject()?.driverCode
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?

    var selectedCarObject :CarGroup?
//    func getExtras() {
//        service.getExtras(success: {  [weak self] (response) in
//            guard let response = response as? String else {return}
//
//            if let extrasResponse = XMLMapper<ExtrasXMLMappable>().map(XMLString: response) {
//                self?.insurances = extrasResponse.soapEnvelopeOuter.insurance
//                self?.extras = extrasResponse.soapEnvelopeOuter.extras
//                self?.reloadTableData?()
//                self?.showInsuranceName?()
//            }
//
//
//
//        }, failure: nil)
//
//    }
    
    
    //MARK: - Helper Methods
    
    func extra(atIndex index: Int) -> (ExtType,Bool) {
        return extrasJson[index]
        
    }
    
    func insurence(atIndex index: Int) -> InsType {
        return insurancesJson[index]
    }
    
    func replaceExtras(_ selectedExtra:(ExtType,Bool)?){
        guard let selectedExtra = selectedExtra else{return}
        var index = 0
        if let idx = extrasJson.firstIndex(where: { $0.0 == selectedExtra.0 }) {
            extrasJson.remove(at: idx)
            index = idx
        }
        extrasJson.insert(selectedExtra, at: index)
    }
    
    func getInsurenceAndExtras(){
        let priceObject = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice
        let matchingCarGroupPrice = priceObject?.filter { $0.carGrop == selectedCarObject?.group }.first

        // Access the rateNo property of the matching CarGroupPrice object
        let rateNo = matchingCarGroupPrice?.rateNo ?? "0"
        
        getExtrasJson(rate: Int(rateNo) ?? 0, group: selectedCarObject?.group ?? "", fromDate: priceEstimationMappableResponseJson?.estimationDetails?.price?.outDate ?? "", toDate: priceEstimationMappableResponseJson?.estimationDetails?.price?.inDate ?? "")
        
        getInsurenceJson(rate: Int(rateNo) ?? 0, group: selectedCarObject?.group ?? "")
        dispatchGroup.notify(queue: .main) {[weak self] in
            self?.reloadTableData?()
            self?.showInsuranceName?()
        }
    }
    
    func getInsurenceJson(rate:Int,group:String){
        let paramsDic: [String: Any] = [
            "Rate":rate ,
            "Group": group,
            "Rentalpack": "1D"
          ]
        print(paramsDic)
        dispatchGroup.enter()
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.getInsurence.rawValue, type: .post,InsurenceModel.self)?.response(error: {[weak self] err in
            self?.dispatchGroup.leave()
        }, receiveValue: {[weak self] response in
            self?.dispatchGroup.leave()
            self?.insurancesJson = response?.insTypes?.insType ?? []
            let insurence = InsType(code: "", desc: "أساسي", amount: "00.0", nameTranslated: "Standard")
            self?.insurancesJson.insert(insurence, at: 0)
        }).store(self)
    }
    
    func getExtrasJson(rate:Int,group:String,fromDate:String,toDate:String){
        let paramsDic: [String: Any] = [
            "Rate": Int(rate) ,
              "Group": group,
              "FromDate": fromDate,
              "ToDate": toDate
          ]
        dispatchGroup.enter()
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.getExtras.rawValue, type: .post,ExtraJsonModel.self)?.response(error: {[weak self] err in
            print(err)
            self?.dispatchGroup.leave()
        }, receiveValue: {[weak self] response in
            self?.dispatchGroup.leave()
            for item in response?.extTypes?.extType ?? []{
                self?.extrasJson.append((item, false))
            }
        }).store(self)
    }
    
    func numberOfExtras() -> Int? {
        
        return extrasJson.count
    }
    
    func numberOfInsurence() -> Int? {
        
        return insurancesJson.count
    }
    

}
