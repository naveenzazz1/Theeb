//
//  DatePickerViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 14/07/1443 AH.
//

import Foundation
import XMLMapper
class DatePickerViewModel:PriceEstimationBaseViewModel {
    
    lazy var service = GetAvailabelCarsService()
     var carModels = [CarGroup?]()
    var pushViewController: ((_ vc: FleetVC) -> ())?
    var navigate: ((_ vc: FleetVC) -> ())?
    var presentMap: (() -> ())?
    //var priceEstimationMappableResponse: PriceEstimationMappableResponse?
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?

    /*
    func getPriceEstimation(getCarsVC:FleetVC,outBranch: String?,
                            inBranch:String?,
                            outDate: String?,
                            inDate:String?,
                            outTime: String?,
                            inTime: String?,
                            vehicleType : String?,
                            driverCode : String? = CachingManager.loginObject()?.driverCode) {
        
        service.getPriceEstimation(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType) { (response) in
            guard let response = response as? String else {return}
            if let responseObject = XMLMapper<PriceEstimationMappableResponse>().map(XMLString: response) {
                self.priceEstimationMappableResponse = responseObject
                self.navigateToFleet(getCarsVC: getCarsVC, outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType)
            }
        }
         failure: { (response, error) in
            
        }
}
    */
    
    func getPriceEstimationJson(getCarsVC:FleetVC,outBranch: Int?,
                            inBranch:Int?,
                            outDate: String?,
                            inDate:String?,
                            outTime: String?,
                            inTime: String?,
                            vehicleType : String?,
                            driverCode : String? = CachingManager.loginObject()?.driverCode) {
        super.getPriceEstimetaionJson(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType, driverCode: driverCode, carGroup: nil, selectedInsurance: nil, insuranceCode: nil, InsuranceQuantitiy: nil, extras: []) {[weak self] response in
            guard let response = response as? PriceEstimationMappableResponseJson else {return}
            self?.priceEstimationMappableResponseJson = response
            self?.navigateToFleet(getCarsVC: getCarsVC, outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType)
        } err: { err in
            print(err.localizedDescription)
        }

}
    
    func navigateToFleet(getCarsVC: FleetVC,
                         outBranch: Int?,
                         inBranch: Int?,
                         outDate: String?,
                         inDate: String?,
                         outTime: String?,
                         inTime: String?,
                         vehicleType: String?,
                         driverCode: String? = CachingManager.loginObject()?.driverCode) {
//
//        // Ensure driverCode is not nil
//        guard let safeDriverCode = driverCode else {
//            // Handle the case where driverCode is nil
//            return
//        }

        // Set driverCode safely and proceed
        getCarsVC.setDataToFleet(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType)
        
        // Safely set optional properties
        if let priceEstimationMappableResponseJson = self.priceEstimationMappableResponseJson {
            getCarsVC.priceEstimationMappableResponseJson = priceEstimationMappableResponseJson
            getCarsVC.viewModel.priceEstimationMappableResponseJson = priceEstimationMappableResponseJson
        }
        
        // Safely set carModels
        if let carModels = CachingManager.carModels() {
            getCarsVC.viewModel.carModels = carModels
            getCarsVC.viewModel.fullUnfilteredArray = carModels
        }
        
        // Navigate only if getCarsVC is not nil
        navigate?(getCarsVC)
    }

//    func navigateToFleet(getCarsVC: FleetVC,outBranch: Int?,
//                         inBranch:Int?,
//                         outDate: String?,
//                         inDate:String?,
//                         outTime: String?,
//                         inTime: String?,
//                         vehicleType : String?,
//                         driverCode : String? = CachingManager.loginObject()?.driverCode) {
//        
//      
//        getCarsVC.setDataToFleet(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType)
//        getCarsVC.priceEstimationMappableResponseJson = self.priceEstimationMappableResponseJson
//        getCarsVC.viewModel.carModels = CachingManager.carModels() ?? []
//        getCarsVC.viewModel.fullUnfilteredArray =  CachingManager.carModels() ?? []
//        getCarsVC.viewModel.priceEstimationMappableResponseJson = self.priceEstimationMappableResponseJson
//        getCarsVC.viewModel.reloadTableData?()
//        getCarsVC.viewModel.reoloadBrandsTable?()
//        navigate?(getCarsVC)
//     
//       
//    }
//    


}
