//
//  GetAvailableVechilesViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/07/1443 AH.
//

import UIKit
import XMLMapper

enum PriceFilterRanges {
    case firstRange
    case secondRange
    case thirdRange
    case fourthRange
    case fifthRange
    case sixRange
}

class GetAvailabelVechilesViewModel:PriceEstimationBaseViewModel  {

    
     var isFromMore: Bool?
    var vechileTypeCode : String?
    
    var selectedvechileTypeCode : String?
    var selectedTypeDescription : String?
    lazy var availalbeCarService = GetAvailabelCarsService()

    lazy var service = GetAvailabelCarsService()
    var reloadTableData: (() -> ())?
    var stopBrandsAnimator: (() -> ())?
    var stopFleetAnimator: (() -> ())?
    var reloadCollectionView: (() -> ())?
    var reoloadBrandsTable: (() -> ())?
  //  var priceEstimationMappableResponse: PriceEstimationMappableResponse?
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?
    var showResultLabel: ((_ count:Int?) -> ())?
    var setupPrices: ((_ carModels: [CarGroup]?) -> ())?
    var carModels = [CarGroup]()
    var fullUnfilteredArray = [CarGroup]()
    var vehicleTypes : [VehicleTypeModel]?
    var makeNames = [Brand?]()
    var ModelsYear = [YearFilterModel?]()
    var navigateToViewController: ((_ vc: UIViewController) -> Void)?
    var carPrice: String?
    var insranceName: String?
    var outBranch: String?
    var  inBranch:String?
    var  outDate: String?
    var  inDate:String?
    var   outTime: String?
    var  inTime: String?
    var  vehicleType : String?
    var  driverCode : String? = CachingManager.loginObject()?.driverCode
    var insrancePrice: String?
    var selectedBrand: String?
    var selectedModelYear: String?
    var selectedPrice: PriceFilterRanges?
    

    func getPriceRange() -> ClosedRange<Double>{
        switch selectedPrice {
        case .firstRange:
            return (0.0...250.0)
        case .secondRange:
            return (251.0...450.0)
        case .thirdRange:
            return (451.0...700.0)
        case .fourthRange:
            return (701.0...1000.0)
        case .fifthRange:
            return (1001.0...2000)
        case .sixRange:
            return (2001...1000000.0)
        default:
            break
        }
        return (0.0...250.0)
    }
    func getAvailableCars(_ vechCode: String? = nil) {
        
        
        self.reloadTableData?()
        
        self.showResultLabel?(self.carModels.count)
        self.setupPrices?(self.carModels )
            

            for (index, item) in carModels.enumerated() {
                let makename = Brand()
                makename.makeName = item.makeName
                makename.isSelected = false
                
                self.makeNames.append(makename)
                let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                if((filteredObject) != nil) {
                    self.carModels[index].price = Double(filteredObject?.ratePackage ?? "0") ?? 0.0
                }
            }
        
        
      
        
        
        let uniques = self.removeDuplicateElements(posts: self.makeNames ?? [])
        self.makeNames = uniques ?? []
        //self.makeNames = Array(Set(carModels.map({ $0?.makeName})))
        self.reoloadBrandsTable?()
        self.stopBrandsAnimator?()
        self.stopFleetAnimator?()
    }
    
    func getPriceEstimation(outBranch: Int?,
                            inBranch:Int?,
                            outDate: String?,
                            inDate:String?,
                            outTime: String?,
                            inTime: String?,
                            vehicleType : String? = nil,
                            driverCode : String?) {
        
        getPriceEstimetaionJson(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType, driverCode: driverCode, carGroup: nil, selectedInsurance: nil, insuranceCode: nil, InsuranceQuantitiy: nil, extras: []) { response in
            if let responseObject = response as? PriceEstimationMappableResponseJson{
                self.priceEstimationMappableResponseJson = responseObject
            }
        } err: { err in
            print(err)
        }

        
//        service.getPriceEstimation(outBranch: outBranch, inBranch: inBranch, outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: vehicleType) { (response) in
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<PriceEstimationMappableResponse>().map(XMLString: response) {
//                self.priceEstimationMappableResponse = responseObject
//            }
//        }
//        failure: { (response, error) in
//
//        }
        
    }
    

//    func getAvailableCarModel(_ vechCode: String? = nil) {
//
//        availalbeCarService.getAvailableCarsSerivce(vehicleTypeCode: vechCode) { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<CarModelBaseObject>().map(XMLString: response) {
//                self?.carModels = responseObject.soapEnvelopeOuter ?? [CarModelObject]()
//
//                self?.showResultLabel?(self?.carModels.count)
//                self?.setupPrices?(self?.carModels ?? [])
//                for item in  self?.carModels ?? [] {
//                    let makename = Brand()
//
//                    makename.makeName = item?.makeName
//                    makename.isSelected = false
//                    let  filteredObject = self?.priceEstimationMappableResponse?.priceResponseModel.carGroupModel?.filter({$0.carGrop == item?.group}).first
//                    if((filteredObject) != nil) {
//                        item?.price = Double(filteredObject?.ratePackagePrice ?? "0")
//                    }
//                    self?.makeNames.append(makename)
//                }
//
//
//                    for item in  self?.carModels ?? [] {
//
//                        let  filteredObject = self?.priceEstimationMappableResponse?.priceResponseModel.carGroupModel?.filter({$0.carGrop == item?.group}).first
//                        if((filteredObject) != nil) {
//                            item?.price = Double(filteredObject?.ratePackagePrice ?? "0")
//                        }
//
//                    }
//
//
//                let uniques = self?.removeDuplicateElements(posts: self?.makeNames ?? [])
//                self?.makeNames = uniques ?? []
//                self?.reoloadBrandsTable?()
//                self?.reloadTableData?()
//                self?.stopBrandsAnimator?()
//                self?.stopFleetAnimator?()
//            }
//
//        } failure: { (response, error) in
//
//        }
//
//
//
//    }
    
    func getModelsYear(){
        ModelsYear.removeAll()
        let currentYear = Calendar.current.component(.year, from: Date())
        ModelsYear.append(YearFilterModel(modelYear: String(currentYear - 4), isSelected: false))
        ModelsYear.append(YearFilterModel(modelYear: String(currentYear - 3), isSelected: false))
        ModelsYear.append(YearFilterModel(modelYear: String(currentYear - 2), isSelected: false))
        ModelsYear.append(YearFilterModel(modelYear: String(currentYear - 1), isSelected: false))
        ModelsYear.append(YearFilterModel(modelYear: String(currentYear), isSelected: false))
        ModelsYear.append(YearFilterModel(modelYear: String(currentYear + 1), isSelected: false))
        for item in ModelsYear {
            if item?.modelYear == selectedModelYear {
                item?.isSelected = true
            }
            if !(carModels.contains(where: { $0.modelVersion == item?.modelYear })) {
                ModelsYear.removeAll { value in
                  return value == item
                }
            }
          

        }
        
        self.reoloadBrandsTable?()
        
            //self.stopBrandsAnimator?()
    }
    
    func getBrands(_ vechCode: String? = nil) {
        
//        availalbeCarService.getAvailableCarsSerivce(vehicleTypeCode: vechCode) { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<CarModelBaseObject>().map(XMLString: response) {
        self.makeNames.removeAll()
        for item in  self.carModels  {
                    let makename = Brand()
                
            makename.makeName = item.makeName
                    makename.isSelected = false
                
            self.makeNames.append(makename)
                }

                
        let uniques = self.removeDuplicateElements(posts: self.makeNames )
        self.makeNames = uniques
        self.reoloadBrandsTable?()
             
               // self?.stopBrandsAnimator?()
               
            }
            
//        } failure: { (response, error) in
//
//        }
//
//
//
//    }
    
    func removeDuplicateElements(posts: [Brand?]) -> [Brand] {
        var uniquePosts = [Brand]()
        for post in posts {
            if !uniquePosts.contains(where: {$0.makeName == post?.makeName }) {
                uniquePosts.append(post ?? Brand())
            }
        }
        return uniquePosts
    }
   

/*
    func getAvailabelCarModels()  {
        
        service.getVechileTypes(success: {[weak self] (response) in
            guard let response = response as? String else {return}
            self?.handleCarModel(response)

        }, failure: nil)
        
    }
    
    func handleCarModel(_ response:String){
        
        if  let responseObject = XMLMapper<VehicleTypeXmlMappable>().map(XMLString:response) {
            if let vechArr = responseObject.soapEnvelopeOuter?.vehicleTypeModel{
                
            vehicleTypes = vechArr
                
                for item in carModels ?? [] {
                            
                    let  filteredObject = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item?.group}).first
                    if((filteredObject) != nil) {
                        item?.price = Double(filteredObject?.ratePackage ?? "0")
                    }
                   
                }
             //   self?.setupPrices?(self?.carModels ?? [])
                
            CachingManager.setVechileTypes(vehicleTypes)
            reloadCollectionView?()
            }
        }
        
    }
    */
//    func getAvailabelCarModels()  {
//
//        service.getVechileTypes(success: { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if  let responseObject = XMLMapper<VehicleTypeXmlMappable>().map(XMLString:response) {
//                if let vechArr = responseObject.soapEnvelopeOuter?.vehicleTypeModel{
//
//                self?.vehicleTypes = vechArr
//
//                    if let carModels = self?.carModels {
//
//                        for (index, item) in  carModels.enumerated() {
//
//                            let  filteredObject = self?.priceEstimationMappableResponse?.priceResponseModel.carGroupModel?.filter({$0.carGrop == item.group}).first
//                            if((filteredObject) != nil) {
//                                self?.carModels?[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
//                            }
//
//                        }
//                    }
//
//                 //   self?.setupPrices?(self?.carModels ?? [])
//
//                CachingManager.setVechileTypes(self?.vehicleTypes)
//                self?.reloadCollectionView?()
//                }
//            }
//
//        }, failure: nil)
//
//    }
//

    
    func didSelectCar(atIndex index: Int , fromMore: Bool? = false) {
        
        
    
        
        let selecteCar = getCar(atIndex: index)
        
        let carDetailsVC = CarDetailsVC.initializeFromStoryboard()
     
            carDetailsVC.isFromMore = fromMore
     
        carDetailsVC.selectedCarObject = selecteCar
        carDetailsVC.setDataToCarDetails(outBranch: Int(outBranch ?? "0"), inBranch: Int(inBranch ?? "0"), outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: selecteCar?.vthCode)
        carDetailsVC.selectedCarPrice = carPrice ?? ""
        carDetailsVC.insuranceprice = insrancePrice  ?? ""
        carDetailsVC.priceEstimationMappableResponseJson = priceEstimationMappableResponseJson
        navigateToViewController?(carDetailsVC)
    }
    
    //MARK: - Helper Methods
    
    func getCar(atIndex index: Int) -> CarGroup? {
        
        return carModels[index]
        
    }
    
    func numberOfCarModels() -> Int? {
        self.showResultLabel?(self.carModels.count)
        return carModels.count
    }
    
    
    func numberOfVechileTypes() -> Int? {
        
        return vehicleTypes?.count
    }
    
    func vechileType(atIndex index: Int) -> VehicleTypeModel? {
        
        return vehicleTypes?[index]
        
    }
    
    func brand(atIndex index: Int) -> Brand? {
        
        return makeNames[index]
        
    }
    
    func numberOfBrands() -> Int? {
        
        return makeNames.count
    }
    
    func brandNames(atIndex index: Int) -> Brand? {
        
        return makeNames[index]
        
    }
    
    
    
}




extension GetAvailabelVechilesViewModel {
        
        func getAvailableCarModel(_ vechCode: String? = nil) {
            let paramsDic: [String: Any] = [
                "VehicleType": vechCode ?? ""
            ]
            NewNetworkManager.instance.paramaters = paramsDic
            NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.carGroup.rawValue, type: .post,CarGroupResponse.self)?.response(error: { [weak self] error in
               // send error
//                CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                     print(index,title)
//                }
            }, receiveValue:{[weak self] model in
                self?.handleCarModel(model)
            } ).store(self)
        }
    
    func handleCarModel(_ model: CarGroupResponse?){
        guard let model = model else { return }
        if model.CarGroup?.success == "True" {
            carModels = model.CarGroup?.groups ?? []
            
           
            showResultLabel?(carModels.count)
            setupPrices?(carModels)
                for (index, item) in carModels.enumerated() {
                    let makeName = Brand()
                    makeName.makeName = item.makeName
                    makeName.isSelected = false
                    
                    if let filteredObject = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first {
                        carModels[index].price = Double(filteredObject.ratePackage ?? "0") ?? 0.0
                    }
                    
                    makeNames.append(makeName)
                }
            

                
                for (index, item) in  carModels.enumerated() {
                    
                    let  filteredObject = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        //                                item?.price = Double(filteredObject?.ratePackagePrice ?? "0")
                        carModels[index].price = Double(filteredObject?.ratePackage ?? "0") ?? 0.0
                    }
                    
                }
            
            
            
            let uniques = removeDuplicateElements(posts: makeNames ?? [])
            makeNames = uniques
            fullUnfilteredArray = carModels
            reoloadBrandsTable?()
            reloadTableData?()
            stopBrandsAnimator?()
           stopFleetAnimator?()
        } else {
            CustomAlertController.initialization().showAlertWithOkButton(message: "error_Occured_msg".localized) { (index, title) in
                 print(index,title)
            }
        }
    }
    
    func getAvailabelCarModels()  {
        NewNetworkManager.instance.paramaters = [:]
        NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.vehicleType.rawValue, type: .post,VehicleTypesResponseModel.self)?.response(error: { [weak self] error in
           // send error
//            CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
//                 print(index,title)
//            }
        }, receiveValue: { [weak self] model in
            guard let model = model else { return }
            if model.vehicleTypes?.success == "True" {
                self?.vehicleTypes = model.vehicleTypes?.vehType
                    
                    if let carModels = self?.carModels {
                        
                        for (index, item) in  carModels.enumerated() {
                            
                            let  filteredObject = self?.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                            if((filteredObject) != nil) {
                                self?.carModels[index].price = Double(filteredObject?.ratePackage ?? "0") ?? 0.0
                            }
                            
                        }
                    }
                    
                 //   self?.setupPrices?(self?.carModels ?? [])
                    
                CachingManager.setVechileTypes(self?.vehicleTypes)
                self?.reloadCollectionView?()
               
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: "error_Occured_msg".localized) { (index, title) in
                     print(index,title)
                }
            }
        }).store(self)
    }
    }

