//
//  BranchesLocationsViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//
import UIKit
import CoreLocation
import GoogleMaps
import XMLMapper



class BranchesLocationsViewModel : BaseViewModel, CLLocationManagerDelegate {
    
    //MARK: - Variables
    var setLocationSelected: (() -> ())?
    var locationpPrmissionChanged: (() -> ())?
    var stopAnimation: (() -> ())?

    var cityRagionDict = [String:[String]]()
//     var pickupBranchId: String?
//    var returnBranchId: String?
    lazy var getCarsService = GetAvailabelCarsService()
    var carModels : [CarGroup]?
    var presentViewController: ((_ vc: UIViewController) -> ())?
    lazy var service = LocationsSercivce()
    lazy var locationManager = CLLocationManager()
    lazy var markers = [GMSMarker]()
    var setMarkerMap: ((_ marker: GMSMarker?) -> Void)?
    var didTapOnLocation: ((_ location: Branch?) -> ())?
    var updateMapWithLocations: ((_ locations: [Branch?]?) -> ())?
 
    var branches: [Branch?]? {
        didSet {
            updateMapWithLocations?(branches)
            fillCityDict()
            reloadBranchCollectionView?()
            reloadCityCollectionView?()
        }
    }
    
    var reloadBranchCollectionView:(()->())?
    var reloadCityCollectionView:(()->())?
    
    var currentLocation: CLLocation? {
        
        return self.locationManager.location
    }
    
    var isLocationServiceEnabled: Bool {
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            return false
        default:
            return true
        }
        
    }
    
    func fillCityDict(){
        guard let branches = branches else {return}
        let isArabic = UIApplication.isRTL()
        for branch in branches{
            let state = (isArabic ? branch?.state : branch?.stateTranslated) ?? ""
            let city = (isArabic ? branch?.city:branch?.distAreaName) ?? ""
            if cityRagionDict[state] == nil && !state.isEmpty{
                cityRagionDict[state] = [String]()
                cityRagionDict[state]?.append(city)
            }else{
              var arr = cityRagionDict[state]
                if !(arr?.contains(city) ?? false) && !city.isEmpty{
                arr?.append(city)
                }
                cityRagionDict[state] = arr
            }
        }
    }
    
    func addMarker(_ location: Branch?) {
        
        guard let lat = location?.branchLat, let long = location?.branchLong else { return }
        
        let position = CLLocationCoordinate2D(latitude: getOnlyValueLatLong(string: lat)  , longitude: getOnlyValueLatLong(string: long)  )
        
        let marker = GMSMarker(position: position)
        marker.title = location?.branchName
        
        marker.appearAnimation = .pop
        marker.icon = UIImage(named: MapMarkerIcon.defaultMarkerIconName)
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.05)
        marker.userData = location
        setMarkerMap?(marker)
        markers.append(marker)
        

    }
    
    
    func setPickupBranchId(withIndex index: Int) {
        
        
       // self.pickupBranchId = self.branches?[index]?.branchCode
        //HomeVC.branchStateTuble.pickupBranch = self.branches?[index]?.branchCode
        HomeVC.branchStateTuble.pickupBranch = self.branches?[index]?.branchCode
    }
    
    func setDropOffBranchId(withIndex index: Int , text :String? = nil) {
        
     //   self.returnBranchId = self.branches?[index]?.branchCode
       // HomeVC.branchStateTuble.returnBranch = self.branches?[index]?.branchCode
        HomeVC.branchStateTuble.returnBranch = self.branches?[index]?.branchCode
        //self.returnBranchId = self.branches?[index].map({ $0.arabicBranchName == text})
    }
    
    func getBranchCodeFromText(_ text: String?) -> String? {
      
        var code : String?
        for item in branches ?? [] {
            if item?.branchNameTranslated == text {
                code = item?.branchCode.map(String.init)
            }
        
        }
        
        return code
    }

//    func getAvailableCars(_ vechCode: String? = nil) {
//
//        getCarsService.getAvailableCarsSerivce(vehicleTypeCode: vechCode) { [weak self] (response) in
//            guard let response = response as? String else {return}
//            if let responseObject = XMLMapper<CarModelBaseObject>().map(XMLString: response) {
//                self?.carModels = responseObject.soapEnvelopeOuter ?? [CarModelObject]()
//                CachingManager.setCarModels(responseObject.soapEnvelopeOuter)
//
//            }
//
//        } failure: { (response, error) in
//
//        }
//
//
//
//    }
    
    func getLocationsFromCaching() {
        if  let cachedLocations = CachingManager.locations() {
            self.branches = cachedLocations
        }
    }
    
    func getBrachesData() {
            NewNetworkManager.instance.paramaters = [:]
            NewNetworkManager.instance.requestRaw(NetworkConfigration.EndPoint.branches.rawValue, type: .post,BranchesResponse.self)?.response(error: { [weak self] error in
               // send error
              //  self?.stopAnimation?()
                CustomAlertController.initialization().showAlertWithOkButton(message: error.localizedDescription) { (index, title) in
                     print(index,title)
               }
            }, receiveValue: { [weak self] model in
                guard let model = model else { return }
               // self?.userProfile.send(model)
                if model.branches?.success == "Y" {
                    self?.branches = model.branches?.branch
                    self?.branches = self?.calculateDistanceForSpecificBranch( self?.branches ?? [])
                    CachingManager.setLocations(self?.branches)
                    self?.stopAnimation?()
                } else {
                    CustomAlertController.initialization().showAlertWithOkButton(message: model.branches?.varianceReason ?? "") { (index, title) in
                         print(index,title)
                    }
                }

            }).store(self)
//            CustomLoader.customLoaderObj.startAnimating()
//            service.getBranchesLocations {  [weak self] (response) in
//
//                guard let response = response as? String else {return}
//                let locationsResponse = XMLMapper<BranchXmlMappable>().map(XMLString: response)
//                let responseArra = locationsResponse?.soapEnvelopeOuter?.branch
//                self?.branches = responseArra
//                self?.caluclateDistanceForSpeicificBranch( self?.branches ?? [])
//                CachingManager.setLocations(self?.branches)
//                CustomLoader.customLoaderObj.stopAnimating()
//            } failure: { (response, error) in
//
//       }
//
//
//       }
        
    }
    
    //MARK: - Setup
    
    func setupLocationManager() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        checkLocationServiceStatus()
    }
    
    func checkLocationServiceStatus() {
        
        guard !isLocationServiceEnabled else { return }
        
        let locationAlert = UIAlertController(title: "home_location_service_disabled_alert_title".localized,
                                              message: "home_location_service_disabled_alert_message".localized,
                                              preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "home_location_service_disabled_alert_settings_option".localized,
                                           style: .default) { (UIAlertAction) in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        let cancelAction = UIAlertAction(title: "home_location_service_disabled_alert_cencel_option".localized,
                                         style: .cancel,
                                         handler: nil)
        
        locationAlert.addAction(settingsAction)
        locationAlert.addAction(cancelAction)
        
        presentViewController?(locationAlert)
    }
    
    
      
      func removeMapMarkers() {
          
          markers.removeAll()
        //  removeAllMapMarkers?()
        //  addUserLocationMarker()
      }
      
      
      func updateMapWithLocations(_ locations: [Branch?]?) {
          
          guard let locations = locations else { return }
          
          removeMapMarkers()
          
          for location in locations {
              
              addMarker(location)
          }
      }
    
    
    func calculateDistanceForSpecificBranch(_ branchModels: [Branch?]) -> [Branch] {
        var updatedBranchModels = [Branch]()
        for var item in branchModels {
            let location = CLLocation(latitude: getOnlyValueLatLong(string: item?.branchLat ?? ""), longitude: getOnlyValueLatLong(string: item?.branchLong ?? ""))
            let itemDistance = currentLocation?.distance(from: location)
            item?.distance = "\(itemDistance ?? 0 / 1000)"
            let time = Double(itemDistance ?? 0.0) / (60 * 1000 / 3600)
            item?.time = "\(time / 60)"
            if let branch = item {
                updatedBranchModels.append(branch)
            }
        }
        return updatedBranchModels
    }

//    func caluclateDistanceForSpeicificBranch(_ branchModels: [Branch?]) {
//        for var item in branchModels {
//            let location = CLLocation(latitude: getOnlyValueLatLong(string: item?.branchLat ?? ""), longitude: getOnlyValueLatLong(string: item?.branchLong ?? ""))
//            let itemDistance = currentLocation?.distance(from: location)
//            item?.distance = "\(itemDistance ?? 0)"
//            let time = Double(itemDistance ?? 0.0) / 80.0
//            item?.time = "\(time)"
//        }
//    }

    
 
    
    
    // MARK: - Markers
    
    func didTapOnMarker(_ marker: GMSMarker) {
        
    
        let branch = branches?.filter({$0?.branchName == marker.title}).first
        
        guard let location = branch else { return }
        
        setLocationSelected?()
        
    }
    
 
    
    func getOnlyValueLatLong(string : String) -> Double
    {
        if(string == "0.0")
        {
            return 0.0
        }
        print("\(string) this is lat long")
        // production
        let arr1 = string.replacingOccurrences(of: " ", with: "").components(separatedBy: "-");
        
        // testing
        
       // let arr1 = string.replacingOccurrences(of: " ", with: "").components(separatedBy: "\'");
        
        
        let degreeArr = arr1[0].replacingOccurrences(of: " ", with: "").components(separatedBy: "°");
        var arr3 = [String]()
        guard  arr1.count > 1 else {return 0}
        arr3.append(arr1[1])
        if( (arr1[1]).contains("N"))
        {
            arr3 = arr1[1].components(separatedBy: "\"");
        }
        if( (arr1[1] ).contains("E"))
        {
            arr3 = arr1[1].components(separatedBy: "\"");
        }
        if( (arr1[1] ).contains("W"))
        {
            arr3 = arr1[1].components(separatedBy: "\"");
        }
        if( (arr1[1] ).contains("S"))
        {
            arr3 = arr1[1].components(separatedBy: "\"");
        }
        let hour = Double(degreeArr[0]) ?? 0.0
        let minute = Double(degreeArr[1]) ?? 0.0
        let seconds = Double(arr3[0]) ?? 0.0
        let value = hour + (minute/60.0) + (seconds/3600.0)
        return Double(value)
        
    }


}


extension BranchesLocationsViewModel {
    
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
extension BranchesLocationsViewModel {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location access granted.")
                // Setup map or other location-dependent features
            case .denied, .restricted:
                // Handle when location access is denied or restricted
                print("Location access denied.")
            default:
                break
            }
        }
        
        // Handle accuracy for iOS 14+
        @available(iOS 14.0, *)
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.accuracyAuthorization {
            case .fullAccuracy:
                print("Full Accuracy")
                locationpPrmissionChanged?()
            case .reducedAccuracy:
                print("Reduced Accuracy")
            default:
                break
            }
        }
}
