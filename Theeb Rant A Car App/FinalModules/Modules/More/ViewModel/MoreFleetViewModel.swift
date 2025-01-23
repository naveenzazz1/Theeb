//
//  MoreFleetViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/08/1443 AH.
//

import UIKit
import XMLMapper

class MoreFleetViewModel: PriceEstimationBaseViewModel {

    lazy var service = GetAvailabelCarsService()
   // var priceEstimationMappableResponse: PriceEstimationMappableResponse?
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?
    var pushViewController: ((_ vc: UIViewController) -> ())?
    lazy var availalbeCarService = GetAvailabelCarsService()
    var filteresCarModels : [CarGroup]?
    var reloadCollectionView: (() -> ())?
    var selectedVechType : VehicleTypeModel?
    var vehicleTypes : [VehicleTypeModel]?

//    func getAvailableCars(_ vechCode: String? = nil) {
//
//        availalbeCarService.getAvailableCarsSerivce(vehicleTypeCode: vechCode) { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<CarModelBaseObject>().map(XMLString: response) {
//                self?.filteresCarModels = responseObject.soapEnvelopeOuter ?? [CarModelObject]()
//                self?.reloadCollectionView?()
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
    
//    func getAvailabelCarModels()  {
//
//        service.getVechileTypes(success: { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if  let responseObject = XMLMapper<VehicleTypeXmlMappable>().map(XMLString:response) {
//                if let vechArr = responseObject.soapEnvelopeOuter?.vehicleTypeModel{
//                self?.vehicleTypes = vechArr
//                CachingManager.setVechileTypes(self?.vehicleTypes)
//                self?.reloadCollectionView?()
//                }
//            }
//
//        }, failure: nil)
//
//    }
    
    /*
    func getPriceEstimation(getCarsVC:FleetVC) {
        getCarsVC.isFromMore = true
        getCarsVC.isFromMore = true
//        getCarsVC.forShowonly = true
        pushViewController?(getCarsVC)
        service.getPriceEstimationForMore { [weak self] response in
            
            guard let response = response as? String else {return}
            if let responseObject = XMLMapper<PriceEstimationMappableResponse>().map(XMLString: response) {
                self?.priceEstimationMappableResponse = responseObject
                self?.navigateToFleet(getCarsVC: getCarsVC)
            }
        } failure: { response, error in
            
        }

}
    */
    
    func getPriceEstimationJSon(getCarsVC:FleetVC) {
        getCarsVC.isFromMore = true
        getCarsVC.isFromMore = true
        pushViewController?(getCarsVC)
        getCarListPriceEstimation(getCarsVC: getCarsVC) { [weak self] response in
            guard let response = response as? PriceEstimationMappableResponseJson else {return}
            self?.priceEstimationMappableResponseJson = response
            self?.navigateToFleet(getCarsVC: getCarsVC)
        } err: { err in
            print(err.localizedDescription)
        }

    }
    

    func navigateToFleet(getCarsVC:FleetVC,outBranch: String? = nil,
                         inBranch:String? = nil,
                         outDate: String? = nil,
                         inDate:String? = nil,
                         outTime: String? = nil,
                         inTime: String? = nil,
                         vehicleType : String? = nil,
                         driverCode : String? = CachingManager.loginObject()?.driverCode) {
        
        
        
    
        getCarsVC.isFromMore = true
        getCarsVC.viewModel.isFromMore = true
        getCarsVC.priceEstimationMappableResponseJson = self.priceEstimationMappableResponseJson
        getCarsVC.viewModel.carModels = CachingManager.carModels()?.filter({ $0.vthCode == selectedVechType?.code
        }) ?? []
        getCarsVC.viewModel.reloadTableData?()
        getCarsVC.viewModel.reoloadBrandsTable?()
       //self.pushViewController?(getCarsVC)
       
    }
    


}
extension MoreFleetViewModel {
    
    func getAvailableCars(_ vechCode: String? = nil) {
        let paramsDic: [String: Any] = [
            "VehicleType": vechCode ?? ""
        ]
        NewNetworkManager.instance.paramaters = paramsDic
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.carGroup.rawValue, type: .post,CarGroupResponse.self)?.response(error: { [weak self] error in
           // send error
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
            
            print(error.localizedDescription)
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            if model.CarGroup?.success == "True" {
                self?.filteresCarModels = model.CarGroup?.groups
                CachingManager.setCarModels(model.CarGroup?.groups)
                self?.reloadCollectionView?()
               
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: "error_Occured_msg".localized) { (index, title) in
                     print(index,title)
                }
            }
        }).store(self)
    }
    
    func getAvailabelCarModels()  {
        NewNetworkManager.instance.paramaters = [:]
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.vehicleType.rawValue, type: .post,VehicleTypesResponseModel.self)?.response(error: { [weak self] error in
           // send error
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
            print(error.localizedDescription)
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            if model.vehicleTypes?.success == "True" {
                
                self?.vehicleTypes = model.vehicleTypes?.vehType
                self?.vehicleTypes = self?.vehicleTypes?.filter { $0.carGroups != nil && !($0.carGroups?.isEmpty ?? false) }

                CachingManager.setVechileTypes(self?.vehicleTypes)
                self?.reloadCollectionView?()
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: "error_Occured_msg".localized) { (index, title) in
                     print(index,title)
                }
            }
        }).store(self)
    }
//    func getAvailabelCarModels()  {
//
//        service.getVechileTypes(success: { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if  let responseObject = XMLMapper<VehicleTypeXmlMappable>().map(XMLString:response) {
//                if let vechArr = responseObject.soapEnvelopeOuter?.vehicleTypeModel{
//                self?.vehicleTypes = vechArr
//                CachingManager.setVechileTypes(self?.vehicleTypes)
//                self?.reloadCollectionView?()
//                }
//            }
//
//        }, failure: nil)
//
//    }
}
