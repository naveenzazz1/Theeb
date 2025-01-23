//
//  MapViewVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Fastis
import SkyFloatingLabelTextField
import MapKit

class BranchesLocationsVC : BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navgationItem: UINavigationItem!
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.setTitle("", for: .normal)
        }
    }
    var mapView =  GMSMapView()
    
  //  @IBOutlet weak var titleLable: UILabel!
    //MARK: - Outlets
    @IBOutlet weak var stackContainers: UIStackView!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var ragionCollectionView: UICollectionView!
    @IBOutlet weak var headerView: TwoTextFieldsView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var selecteDateButton: UIButton!
//    @IBOutlet weak var speratorView: UIImageView! {
//        didSet {
//            speratorView.isHidden = true
//        }
//    }
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var chooseLocationView: UIView! {
        didSet {
            chooseLocationView.isHidden = true
        }
    }
    
//    @IBOutlet weak var chooseDifferntReturnLocation: UIButton!
//    @IBOutlet weak var selectReturnBranchTextField: DropDown! {
//        didSet {
//
//            setTextFieldAttributedPlaceholder(textField: selectReturnBranchTextField, localizedString: "mapLocation_selectTReturnLocation".localized)
//            selectReturnBranchTextField.setLeftPaddingPoints(40.0)
//            selectReturnBranchTextField.arrow.isHidden = true
//            if let locations =  CachingManager.locations() {
//
//                self.selectReturnBranchTextField.optionArray = locations.map({ return $0?.arabicBranchName ?? ""})
//            }
//            selectReturnBranchTextField.delegate = self
//            selectReturnBranchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
//            selectReturnBranchTextField.selectedRowColor = .clear
//
//            selectReturnBranchTextField.didSelect {  [weak self] (text, index, id) in
//
//                self?.viewModel.setDropOffBranchId(withIndex: index)
//                self?.chooseLocationView.isHidden = false
//                self?.stackContainers.isHidden = false
//
//            }
//        }
//    }
//    @IBOutlet weak var pickupLocationTextField: DropDown! {
//        didSet {
//
//            pickupLocationTextField.setLeftPaddingPoints(40.0)
//            pickupLocationTextField.arrow.isHidden = true
//            setTextFieldAttributedPlaceholder(textField: pickupLocationTextField, localizedString: "mapLocation_selectPickLocation".localized)
//            if let locations =  CachingManager.locations() {
//
//                self.pickupLocationTextField.optionArray = locations.map({ return $0?.arabicBranchName ?? ""})
//
//
//            }
//            pickupLocationTextField.delegate = self
//            pickupLocationTextField.selectedRowColor = .clear
//            pickupLocationTextField.didSelect {  [weak self] (text, index, id) in
//
//                self?.viewModel.setPickupBranchId(withIndex: index)
//                self?.chooseLocationView.isHidden = false
//                self?.branchNameLabel.text = text
//                self?.stackContainers.isHidden = false
//            }
//
//
//            pickupLocationTextField.placeholder  = "mapLocation_pickUp".localized
//            pickupLocationTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
//
//        }
//    }
//    @IBOutlet weak var containerStackView: UIStackView!
//    @IBOutlet weak var choosePickupLocationView: UIView!
//    @IBOutlet weak var selectReturnBranchView: UIView!
//    @IBOutlet weak var chooseDifferentReturnBranch: UIView!
//    @IBOutlet weak var returnLocationHintLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeigh: NSLayoutConstraint!
    
    //MARK: - Variables
    var titleString : String?
    
     var getAvailbecarsViewModel = GetAvailabelVechilesViewModel()
    @IBOutlet weak var mapViewContainer: UIView!
    
   // var mapView: GMSMapView!
    var locationsListVC: LocationsListVC?
    let isArabic = UIApplication.isRTL()

    var timePArentHeightConstraint: NSLayoutConstraint!
    var timeParentView:UIView?
    var viewModel = BranchesLocationsViewModel()
    var datePickerVC: DateTimePickerVC?
    var cardView:BranchCardView?
    var isFromMore = false
    var isSelectedFromHome = false
    var shouldShowContainerView = true
    var superVC:UIViewController?
    var selectedKey = ""{
        didSet{
            cityCollectionView.reloadData()
        }
    }
    var selectedCity = 0 {
        didSet{
            cityCollectionView.reloadData()
        }
    }
    var selectedRagion = 0 {
        didSet{
            ragionCollectionView.reloadData()
        }
    }
    var btnFade:UIButton = {
     let btn = UIButton()
      btn.backgroundColor = .gray
      btn.alpha = 0.7
      btn.addTarget(self, action: #selector(dismissCardView), for: .touchUpInside)
      return btn
    }()
    //MARK: - View Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
     //   mapView.frame = mapViewContainer.bounds
        mapViewContainer.isUserInteractionEnabled  = true
      
        handleViews()
        
        
    }
    
    func checkLocationAuthorization() {
        let locationManager = viewModel.locationManager
        locationManager.delegate = self  // Ensure delegate is set

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Ask for permission
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted, setup map
            setupDidLoad()
        case .restricted, .denied:
            // Permission denied, show alert or handle the case
            showLocationDisabledAlert()
        @unknown default:
            break
        }
    }

    func setupDidLoad(){
        setupViewModel()
      //  checkLocationAuthorization()
           
           viewModel.setupLocationManager()
           
           // If permission is granted, setup map view and load the user's location
           if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
               setupMapView()
           }

        viewModel.setupLocationManager()

        if  let cachedLocations = CachingManager.locations() {
            viewModel.branches = cachedLocations
        } else {
            CustomLoader.customLoaderObj.startAnimating()
            viewModel.getBrachesData()
        }
//            viewModel.getAvailableCars()
//
//        }
        mapView.delegate = self
        let location = viewModel.currentLocation
        if let lat = location?.coordinate.latitude , let lang = location?.coordinate.longitude {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lang , zoom: 13)
            let options = GMSMapViewOptions()
            options.camera = camera
            options.frame = self.view.bounds

             mapView = GMSMapView(options: options)
            self.mapViewContainer.addSubview(mapView)
            mapView.delegate = self
            mapViewContainer.isUserInteractionEnabled  = true
           self.mapView.animate(to: camera)
        }
        handleHeaderView()
        HomeVC.isFromSuccesVc = false
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.semanticContentAttribute = .forceLeftToRight
        self.hideKeyboardWhenTappedAround()
        titleLabel.text = "mapLocation_selectPickLocation".localized
      //  title =  "landing_page_book_weem_item".localized
        headerView.lblstaticReturn.text = "mapLocation_differentCity".localized
        selecteDateButton.setTitle("mapLocation_selectDates".localized, for: .normal)
        setupDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    @objc func appEnteredForeground() {
        // Check location authorization again when the app enters the foreground
        checkLocationAuthorization()
    }

    
    func handleHeaderView(){
        headerView.superVC = self
        headerView.headerViewHeigh = headerViewHeigh
        headerView.complitionBtnReturn = selectReturnBranchBtnAction
        headerView.returnTxtFieldDidSelect = {  [weak self] (text, index, id) in
            
            self?.viewModel.setDropOffBranchId(withIndex: index)
            self?.chooseLocationView.isHidden = false
            self?.stackContainers.isHidden = false
            
        }
        
        headerView.pickUpTxtFieldDidSelect = {  [weak self] (text, index, id) in
            self?.viewModel.setPickupBranchId(withIndex: index)
            self?.chooseLocationView.isHidden = self?.headerView.isSelected ?? false
            self?.branchNameLabel.text = text
            self?.stackContainers.isHidden = false
        }
        headerView.isSelected = isSelectedFromHome
        guard let pickUpId = HomeVC.branchStateTuble.pickupBranch else {return}
        if let pickupBranchObject = CachingManager.locations()?.filter({ $0?.branchCode == pickUpId}).first as? Branch {
            let localizedBranch = isArabic ? pickupBranchObject.branchName:pickupBranchObject.branchNameTranslated
            headerView.txtFieldPickup.text = HomeVC.isFromSuccesVc ? "":localizedBranch
            shouldShowContainerView = (HomeVC.branchStateTuble.returnBranch != nil ) || isSelectedFromHome
            headerView.isSelected = shouldShowContainerView
            branchNameLabel.text = isArabic ? pickupBranchObject.branchName:pickupBranchObject.branchNameTranslated
          //  chooseLocationView.isHidden = false
        }
        
        if  let returnId = HomeVC.branchStateTuble.returnBranch,
            let returnBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == returnId}).first as? Branch{
            let localizedBranch = isArabic ? returnBranchObject.branchName:returnBranchObject.branchNameTranslated
            headerView.txtFieldReturn.text = HomeVC.isFromSuccesVc ? "":localizedBranch
            headerView.isSelected = (pickUpId != returnId)
            chooseLocationView.isHidden = false
        }
    }
    
    func handleMoreVC(){
        headerView.isHidden = isFromMore
        titleView.isHidden = isFromMore
        if isFromMore {
            headerViewHeigh.constant = 0
            titleViewHeight.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    //MARK: - Initialization
    
    class func initializeFromStoryboard() -> BranchesLocationsVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.MapLocationView, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: BranchesLocationsVC.self)) as! BranchesLocationsVC
    }
    
    func handleViews(){
        view.bringSubviewToFront(stackContainers)
        selectedKey = viewModel.cityRagionDict.keys.first ?? ""
        
        let city = viewModel.cityRagionDict[selectedKey]?[0] ?? ""
        selectedCity = 0
        setSelectedCity(city: city)
        
        let albumNib = UINib(nibName: CityCell.identifier, bundle: nil)
        [cityCollectionView,ragionCollectionView].forEach{
            $0?.delegate = self
            $0?.dataSource = self
            $0?.register(albumNib, forCellWithReuseIdentifier: CityCell.identifier)
        }
    }
    
    func setTextFieldAttributedPlaceholder (textField : UITextField , localizedString: String?) {
        
        textField.attributedPlaceholder = NSAttributedString(string: localizedString ?? "" , attributes: [
            .foregroundColor: UIColor.weemDarkGray,
//            .font: UIFont.montserratRegular(fontSize: 15)!
        ])
       
        
        
        textField.textAlignment = Language.isRTL ? .left : .right
        
    }
    
    
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: initializeFromStoryboard())
        
        return navigationController
    }
    
//    func constrauctTimeView(onView:UIView){
//         timeParentView = UIView()
//        onView.addSubview(timeParentView!)
//        timeParentView!.anchor(nil, left: onView.leftAnchor, bottom: onView.bottomAnchor, right: onView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -onView.frame.height/3, rightConstant: 0, widthConstant: 0, heightConstant: onView.frame.height/3)
//        if let btmConst = onView.constraints.first(where: { $0.identifier == "btmConst" }) {
//           timePArentHeightConstraint = btmConst
//        }
//    }
    
   
    @objc func dismissCardView(){
      UIView.animate(withDuration: 0.7) {
      self.cardView?.removeFromSuperview()
      self.btnFade.removeFromSuperview()
      self.stackContainers.isHidden = false
     }
    }
    
    func addBranchCardToView(location: Branch?){
        view.addSubview(btnFade)
        btnFade.fillSuperview()
        cardView = BranchCardView()
        cardView?.location = location
        cardView?.delegate = self
        guard let cardView = cardView else {return}
        view.addSubview(cardView)
        cardView.anchor(stackContainers.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 60, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: view.frame.height*0.6)
        stackContainers.isHidden = true
        cardView.scaleAnimate()
        cardView.fillViews()
    }

     func fillTextFieldFromMarker(_ location: Branch?) {
         if !(headerView.txtFieldPickup.text?.isEmpty ?? true) && headerView.isSelected{
             headerView.btnClearReturn.isHidden = false
             let localizedBranch = isArabic ? location?.branchName:location?.branchNameTranslated
             headerView.txtFieldReturn.text = localizedBranch
             headerView.txtFieldReturn.setTextFieldAttributedPlaceholder(HomeVC.isFromSuccesVc ? "mapLocation_selectTReturnLocation".localized:"")
             HomeVC.branchStateTuble.returnBranch = location?.branchCode
         }else{
             headerView.btnClearPickup.isHidden = false
             let localizedBranch = isArabic ? location?.branchName:location?.branchNameTranslated
             headerView.txtFieldPickup.text = localizedBranch
             headerView.txtFieldPickup.setTextFieldAttributedPlaceholder(HomeVC.isFromSuccesVc ? "mapLocation_selectPickLocation".localized:"")
             HomeVC.branchStateTuble.pickupBranch = location?.branchCode
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        locationsListVC = segue.destination as? LocationsListVC
        locationsListVC?.didTapOnLocation = { [unowned self] (location) in
            
            let lat = Double(viewModel.getOnlyValueLatLong( string: location?.branchLat ?? ""))
            let long = Double(viewModel.getOnlyValueLatLong(string:location?.branchLong ?? "" ))
            
            //  if Double(location) == self.locationsListVC?.selectedLocation { return }
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            headerView.hideTextFieldLists()
            let marker = GMSMarker(position: position)
            marker.title = isArabic ? location?.branchName:location?.branchNameTranslated
            marker.userData = location
            marker.icon = UIImage(named: MapMarkerIcon.defaultMarkerIconName)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.05)
            marker.userData = location
            viewModel.setMarkerMap?(marker)
            marker.map = self.mapView
            self.mapView.selectedMarker = marker
            chooseLocationView.isHidden = isFromMore
            isFromMore ? addBranchCardToView(location: location):fillTextFieldFromMarker(location)
            branchNameLabel.text = isArabic ? location?.branchName:location?.branchNameTranslated
            self.navigateMapToLocation(position, animated: true)
            
        }
        
    }
    
    
    //MARK: - Map
    
    func navigateMapToLocation(_ locationCoordinate: CLLocationCoordinate2D, animated: Bool = false) {
        
        let camera = GMSCameraPosition.camera(withLatitude: locationCoordinate.latitude,
                                              longitude: locationCoordinate.longitude,
                                              zoom: Float(13))
        
        if animated {
            mapView.animate(to: camera)
        } else {
            mapView.camera = camera
        }
    }
    
    //MARK: - Setup ViewModel
    
    func setupViewModel() {
        
        viewModel.updateMapWithLocations = { [unowned self] (locations) in
            
            guard var locations = locations else { return }
            locations = viewModel.calculateDistanceForSpecificBranch(locations)
            self.locationsListVC?.setLocations(locations: locations)
            
            //  self.removeAllMarkers()
            
            for location in locations {
                
                viewModel.addMarker(location)
                
            }
            handleViews()
            cityCollectionView.reloadData()
            ragionCollectionView.reloadData()
        }
        
        viewModel.reloadBranchCollectionView = { [weak self] in
            self?.ragionCollectionView.reloadData()
            
        }
        
        viewModel.reloadCityCollectionView = { [weak self] in
            self?.cityCollectionView.reloadData()
        }
        
        viewModel.didTapOnLocation = { [unowned self] (location) in
            let lat = Double(viewModel.getOnlyValueLatLong( string: location?.branchLat ?? ""))
            let long = Double(viewModel.getOnlyValueLatLong(string:location?.branchLong ?? "" ))
            
            //  if Double(location) == self.locationsListVC?.selectedLocation { return }
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let marker = GMSMarker(position: position)
            marker.title = isArabic ? location?.branchName:location?.branchNameTranslated
            marker.userData = location
            marker.icon = UIImage(named: MapMarkerIcon.defaultMarkerIconName)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.05)
            marker.userData = location
            viewModel.setMarkerMap?(marker)
            marker.map = self.mapView
            self.mapView.selectedMarker = marker
            
            chooseLocationView.isHidden = isFromMore
            isFromMore ? addBranchCardToView(location: location):fillTextFieldFromMarker(location)
            branchNameLabel.text = isArabic ? location?.branchName:location?.branchNameTranslated
            self.navigateMapToLocation(position, animated: true)
        }
        
        viewModel.setLocationSelected = {
            
//            self.viewModel.setPickupBranchId(withIndex: index)
//            self.chooseLocationView.isHidden = false
//            self.branchNameLabel.text = text
//            self.stackContainers.isHidden = false
            
        }
        
        viewModel.locationpPrmissionChanged = {
            self.setupDidLoad()
        }
        
        viewModel.stopAnimation = {
            CustomLoader.customLoaderObj.stopAnimating()
            
        }
        viewModel.setMarkerMap = { [unowned self] (marker) in
            
            marker?.map = self.mapView
        }
        
        viewModel.presentViewController = { [unowned self] (vc) in
            
            self.present(vc, animated: true, completion: nil)
        }
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //checkLocationAuthorization()
        headerViewHeigh.constant = isSelectedFromHome ? TwoTextFieldsView.expandableHeight:TwoTextFieldsView.normalHeight
        handleMoreVC()
        [headerView.txtFieldPickup,headerView.txtFieldReturn].forEach{
            if !($0?.text?.isEmpty ?? false){$0?.setTextFieldAttributedPlaceholder("")}
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationsListVC = nil
        if let datePickerVC = datePickerVC{
        removeChildVC(mainVc: datePickerVC)
        }
    }
    // MARK: - List
    
    func setListSelectedLocation(fromMarker marker: GMSMarker) {
        
        let location: Branch? = marker.userData as? Branch
        locationsListVC?.setSelectedLocation(location)
    }
    
    
    
    func setupMapView() {
        guard let location = viewModel.currentLocation else {
            return
        }
        
        if mapView == nil {
            mapView = GMSMapView(frame: mapViewContainer.bounds)
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.delegate = self
            mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
            mapViewContainer.addSubview(mapView)
        }
        
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 13)
        mapView.camera = camera
    }

    //MARK: - Helper Methods
    
    func chooseDate() {
        
        var customConfig = FastisConfig.default
        customConfig.monthHeader.labelColor = .theebColor
        customConfig.monthHeader.monthLocale = Locale(identifier: UIApplication.isRTL() ? "ar":"en")
        customConfig.monthHeader.labelFont = UIFont.logoutItemFont
        customConfig.weekView.height  = 50
        if UIApplication.isRTL() {
            customConfig.semaitic = .forceRightToLeft
        } else {
            customConfig.semaitic = .forceLeftToRight
        }
    
        customConfig.weekView.textColor = .weemBlack
        customConfig.weekView.backgroundColor = .white
        customConfig.dayCell.selectedBackgroundColor = .theebColor
        customConfig.dayCell.dateLabelFont = UIFont.BahijTheSansArabicPlain(fontSize: 17) ?? UIFont.systemFont(ofSize: 17)
        customConfig.dayCell.customSelectionViewCornerRadius = 8
        customConfig.currentValueView.textColor = .theebColor
        customConfig.currentValueView.insets  =  UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        customConfig.currentValueView.locale = .current
        customConfig.controller.barButtonItemsColor  = .theebColor
        customConfig.currentValueView.textFont  = UIFont.BahijTheSansArabicPlain(fontSize:
        12) ?? UIFont.systemFont(ofSize: 12)
     
        customConfig.weekView.textFont = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        let fastisController = FastisController(mode: .range, config: customConfig)
       
        fastisController.title = "datePicker_chooseDate".localized
        if UIApplication.isRTL() {
            fastisController.semantic = .forceRightToLeft
        } else {
            fastisController.semantic = .forceLeftToRight
        }
        fastisController.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        fastisController.allowToChooseNilDate = true
      
        fastisController.hidesBottomBarWhenPushed = true
        

        fastisController.dismissHandler  = {
            
            if UIApplication.topViewController() ==  fastisController {
                
                self.navigationController?.popViewController(animated: true)
            }
        }
      
        fastisController.doneHandler = { [weak self] resultRange in
            self?.datePickerVC = DateTimePickerVC.initializeFromStoryboard()
            self?.datePickerVC?.returnDate = DateUtils.stringFromDate(resultRange?.toDate)
            self?.datePickerVC?.pickupDate =  DateUtils.stringFromDate(resultRange?.fromDate)
            DateTimePickerVC.pickupDateForPicker = resultRange?.fromDate
            DateTimePickerVC.returnDateForPicker = resultRange?.toDate
            if let fromDate = resultRange?.fromDate,let toDate = resultRange?.toDate{
            let days = DateUtils.daysBetweenDates(startDate: fromDate, endDate: toDate) ?? 1
               
                self?.datePickerVC?.textDays = "\(days) \("checkOutVC_Day".localized)"
            }
            self?.datePickerVC?.viewModel.carModels = CachingManager.carModels() ?? []


            if (resultRange?.toDate != nil &&  resultRange?.fromDate != nil) {
               let tuble = self?.constructTimeView(onView: fastisController.view)
                self?.timeParentView = tuble?.0
                self?.timePArentHeightConstraint = tuble?.1
                self?.datePickerVC?.superVc = fastisController
                fastisController.addChildViewController(self?.datePickerVC, onView: (self?.timeParentView) ?? UIView())
                self?.animateConstraint(constraint: self?.timePArentHeightConstraint, to: 8)

               // self?.navigationController?.pushViewController(datePickerVC, animated: true)

            }
            
            
            
        }
        
      
        fastisController.present(above: self)
        
    }
    
    
    
    
    
    // MARK: - Actions
    
    
    
    @IBAction func selectDateButtonAction(_ sender: Any) {
        if let superVC = superVC as? HomeVC {
            superVC.setPickupAndDropOffBranches(isChooseDate:true)
            superVC.pickupView.isSelected = headerView.isSelected
        }
      dismiss(animated: true)
     //   chooseDate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.TheebBranches, screenClass: String(describing: RentalDetailsVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.TheebBranches, screenClass: String(describing: RentalDetailsVC.self))
        
    }
    
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true)
        HomeVC.branchStateTuble.returnBranch = nil
        HomeVC.branchStateTuble.pickupBranch = nil
    }
    
    func selectReturnBranchBtnAction(_ sender: UIButton) {
        //headerViewHeigh.constant = headerView.isSelected ? 190:265
        headerView.isSelected = !headerView.isSelected
        if !headerView.isSelected{
            HomeVC.branchStateTuble.returnBranch = nil
        }
        let toggleCooseLocation = shouldShowContainerView && headerView.isSelected
        chooseLocationView.isHidden = toggleCooseLocation
         
//        if  headerView.isSelected {
//            //addInputView(view: selectReturnBranchView, atIndex: 1)
////            speratorView.isHidden = false
//        } else {
//            //removeInputView(view: selectReturnBranchView)
//           // speratorView.isHidden = true
//        }
    }
    
}
// MARK: - GMSMapViewDelegate

extension BranchesLocationsVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        viewModel.didTapOnMarker(marker)
        setListSelectedLocation(fromMarker: marker)
        let location: Branch? = marker.userData as? Branch
        viewModel.didTapOnLocation?(location)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        viewModel.didTapOnMarker(marker)
        setListSelectedLocation(fromMarker: marker)
        let location: Branch? = marker.userData as? Branch
        viewModel.didTapOnLocation?(location)
        return false
    }
}

extension BranchesLocationsVC:BranchLocatinDelegate{
    
    func setSelectedCity(city: String) {
        var branchArr = buildBranchArr(city: city)
        if branchArr.count > 0 {
            let branchLat = branchArr.first?.branchLat
            let branchLong = branchArr.first?.branchLong
            self.animateMap(branchLat: branchLat, branchLong: branchLong)
            
           
            
        }
        branchArr = viewModel.calculateDistanceForSpecificBranch(branchArr)
        locationsListVC?.setLocations(locations: branchArr)
        
    }
    
    
//    let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 20)
//
//    self.mapViewContainer.animate(to: camera)
   // let location  = CLLocation(latitude:getOnlyValueLatLong(string: item?.branchLat ?? "") , longitude: getOnlyValueLatLong(string: item?.branchLong ?? ""))
    
    func buildBranchArr(city: String)->[Branch]{
        var branchArr = [Branch]()
        guard let branches = viewModel.branches else {
            return branchArr
            
        }
        for branch in branches{
            let cityToCompare = branch?.city
            let cityBranch = UIApplication.isRTL() ? cityToCompare:branch?.distAreaName
            if cityBranch ?? "" == city,let branch = branch{
                branchArr.append(branch)
            }
        }
        return branchArr
    }
    
    func animateMap(branchLat : String? , branchLong: String?) {
        let location  = CLLocation(latitude:viewModel.getOnlyValueLatLong(string: branchLat ?? "") , longitude: viewModel.getOnlyValueLatLong(string: branchLong ?? ""))
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 15)
        
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let marker = GMSMarker(position: position)
       // marker.title = isArabic ? location?.branchName:location?.branchNameTranslated
        marker.userData = location
        marker.icon = UIImage(named: MapMarkerIcon.defaultMarkerIconName)
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.05)
        marker.userData = location
        viewModel.setMarkerMap?(marker)
        marker.map = self.mapView
        self.mapView.selectedMarker = marker
        
       self.mapView.animate(to: camera)
        
        
    }
}

extension BranchesLocationsVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  print(viewModel.cityRagionDict.count, "\n ",viewModel.cityRagionDict.keys, "\n",viewModel.cityRagionDict)
        if collectionView == ragionCollectionView{
            return viewModel.cityRagionDict.keys.count
        }else{
            return viewModel.cityRagionDict[selectedKey]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCell.identifier, for: indexPath) as? CityCell else {return UICollectionViewCell()}
        if collectionView == ragionCollectionView{
            let keyArr = Array(viewModel.cityRagionDict.keys)
            let isSelectedCell = selectedRagion == indexPath.item
            cell.lblCity.text = keyArr[indexPath.item]
            cell.heightLighCell(isSelectedCell)
        }else{
            let isSelectedCell = selectedCity == indexPath.item
            cell.lblCity.text = viewModel.cityRagionDict[selectedKey]?[indexPath.item]
            cell.lblCity.font = UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15, weight: .semibold)
            cell.heightLighCell(isSelectedCell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ragionCollectionView{
            let keyArr = Array(viewModel.cityRagionDict.keys)
            selectedKey = keyArr[indexPath.item]
            selectedRagion = indexPath.item
            let city = viewModel.cityRagionDict[selectedKey]?[0] ?? ""
            selectedCity = 0
            setSelectedCity(city: city)
        }else{
            let city = viewModel.cityRagionDict[selectedKey]?[indexPath.item] ?? ""
            selectedCity = indexPath.item
            setSelectedCity(city: city)
        }
    }
    
}

extension BranchesLocationsVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = viewModel.currentLocation
        if let lat = location?.coordinate.latitude , let long = location?.coordinate.longitude {
        let camera = GMSCameraPosition.camera(withLatitude:lat, longitude: long, zoom: 20)

        self.mapView.animate(to: camera)
        }
        //Finally stop updating location otherwise it will come again and again in this delegate
        viewModel.locationManager.stopUpdatingLocation()

    }
}

extension BranchesLocationsVC:BranchCardViewDelegate{
    func sendLangAndLat(name:String?,lat:String?,lang:String?){
        let lattitude = Double(viewModel.getOnlyValueLatLong( string: lat ?? ""))
        let longitude = Double(viewModel.getOnlyValueLatLong(string:lang ?? "" ))
        let position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        dismissCardView()
       // navigateMapToLocation(position, animated: true)
        //openMapsAppWithDirections(to: position, destinationName: name ?? "Theeb Branch")
        openGoogleMap(coordinate: position, destinationName: name ?? "Theeb Branch")
    }
    
    func openGoogleMap(coordinate: CLLocationCoordinate2D,destinationName: String) {
        let latDouble =  Double(coordinate.latitude)
        let longDouble =  Double(coordinate.longitude)
        guard let urlGmap = URL(string:"comgooglemaps://") else {return}
        if (UIApplication.shared.canOpenURL(urlGmap)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
        }
        else {
            openMapsAppWithDirections(to: coordinate, destinationName: destinationName)
        }
    }

    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
}


extension BranchesLocationsVC {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted, reload the map view
            setupDidLoad()

            // Check for accuracy (iOS 14+)
            if #available(iOS 14.0, *) {
                let accuracy = manager.accuracyAuthorization
                switch accuracy {
                case .fullAccuracy:
                    print("Full Accuracy")
                case .reducedAccuracy:
                    print("Reduced Accuracy")
                @unknown default:
                    break
                }
            }

        case .denied, .restricted:
            // Permission denied, show alert
            showLocationDisabledAlert()

        default:
            break
        }
    }

    
    func showLocationDisabledAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Location Services Disabled",
                message: "Please enable location services in Settings to use the map features.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}
