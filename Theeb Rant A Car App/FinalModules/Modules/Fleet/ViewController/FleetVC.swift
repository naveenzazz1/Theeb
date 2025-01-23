//
//  FleetVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 11/07/1443 AH.
//

import UIKit

class FleetVC: BaseViewController {
    
    //MARK: - PriceFiltersOutlets
    
    
    @IBOutlet weak var carTypeBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var brandBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var from0to250Btn: UIButton!
    @IBOutlet weak var from0to250Lbl: UILabel! {
        didSet {
            from0to250Lbl.text = "fleet_from_zero_to_250".localized
        }
    }
    
    @IBOutlet weak var from251to450label: UILabel! {
        didSet {
            from251to450label.text = "fleet_from_251_to_450".localized
        }
    }
    @IBOutlet weak var from251to450Btn: UIButton!
    
    @IBOutlet weak var from451to700Btn: UIButton!
    @IBOutlet weak var from451to700Label: UILabel! {
        didSet {
            from451to700Label.text = "fleet_from_451_to_700" .localized
        }
    }
    
    @IBOutlet weak var from701to1000Label: UILabel! {
        didSet {
            from701to1000Label.text = "fleet_from_701_to_1000".localized
        }
    }
    @IBOutlet weak var from701to1000Btn: UIButton!
    
    
    @IBOutlet weak var from1001to2000Label: UILabel! {
        didSet {
            from1001to2000Label.text = "fleet_from_1001_to_2000".localized
        }
    }
    @IBOutlet weak var from1001to2000Btn: UIButton!
    
    
    @IBOutlet weak var from2001orMoreLabel: UILabel! {
        didSet {
            from2001orMoreLabel.text = "fleet_from_2000_to_more".localized
        }
    }
    @IBOutlet weak var from2001orMoreBtn: UIButton!
    
    
    @IBOutlet weak var secondApplyButton: UIButton! {
        didSet {
            secondApplyButton.setTitle("fleet_apply".localized, for: .normal)
            
        }
    }
    
    @IBOutlet weak var firstApplyButton: UIButton!{
        didSet {
            firstApplyButton.setTitle("fleet_apply".localized, for: .normal)
            
        }
    }
    
    
    @IBOutlet weak var carTypeFilterTitleLabel: UILabel! {
        didSet {
            carTypeFilterTitleLabel.text = "checkout_cartype_filter_title".localized
        }
    }
    @IBOutlet weak var priceTitleLabel: UILabel! {
        didSet {
            priceTitleLabel.text =  "checkout_price_filter_title" .localized
        }
    }
    @IBOutlet weak var brandTitleLabel: UILabel! {
        didSet {
            brandTitleLabel.text =  "checkout_brand_filter_title".localized
        }
    }
    @IBOutlet weak var dismissBrandView: UIView!
    @IBOutlet weak var dismissCarFilterView: UIView!
    @IBOutlet weak var dismissPriceFilterView: UIView!
    
    @IBOutlet weak var clearFilterPrice: UIButton! {
        didSet {
            clearFilterPrice.setTitle("checkout_clear_filter".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var yearButtonFilterOutlet: UIButton! {
        didSet {
            yearButtonFilterOutlet.setTitle("Year".localized, for: .normal)
        }
        
    }
    @IBOutlet weak var topBrandBtn: UIButton!
    @IBOutlet weak var topbrandView: UIView!
    @IBOutlet weak var carTypeBtn: UIButton!
    @IBOutlet weak var carTypeView: UIView!
    @IBOutlet weak var topPriceBtn: UIButton!
    @IBOutlet weak var topPriceView: UIView!
    @IBOutlet weak var clearFilterForCarTypes: UIButton! {
        didSet {
            clearFilterForCarTypes.setTitle("checkout_clear_filter".localized, for: .normal)
        }
    }
    @IBOutlet weak var clearFilterForBrands: UIButton! {
        didSet {
            clearFilterForBrands.setTitle("checkout_clear_filter".localized, for: .normal)
        }
    }
    @IBOutlet weak var fleetActivityIndicator: UIActivityIndicatorView! {
        didSet {
            fleetActivityIndicator.stopAnimating()
            fleetActivityIndicator.isHidden = true
            
        }
        
    }
    
    @IBOutlet weak var fromzeroTo90Label: UILabel! {
        didSet {
            fromzeroTo90Label.text =   "fleet_from_zero_to_90".localized
        }
    }
    @IBOutlet weak var moreThan200Label: UILabel! {
        didSet {
            moreThan200Label.text = "fleet_more_than_200".localized
        }
    }
    
    
    
    @IBOutlet weak var clearAllFilterBtnAction: UIButton! {
        didSet {
            
            clearAllFilterBtnAction.setTitle("clear_all_filters_btn_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var yearFilterView: UIView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnClearFilter: UIButton!
    @IBOutlet weak var btnBrand: UIButton!
    @IBOutlet weak var btnCarType: UIButton!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var from91to200Label: UILabel! {
        didSet {
            from91to200Label.text = "fleet_from_91_to_200".localized
        }
    }
    @IBOutlet weak var morethan200Filter: UIButton!
    @IBOutlet weak var fromzeroto90Filter: UIButton!
    
    @IBOutlet weak var fromm91To200Filter: UIButton!
    @IBOutlet weak var brandsTableView: UITableView! {
        didSet {
            brandsTableView.delegate = self
            brandsTableView.dataSource  = self
        }
    }
    
    @IBOutlet weak var carTypesCollectionView: UICollectionView!
    
    @IBOutlet weak var brandView: UIView! {
        didSet {
            brandView.isHidden = true
        }
    }
    @IBOutlet weak var carTypeFilterView: UIView! {
        didSet {
            carTypeFilterView.isHidden = true
        }
    }
    @IBOutlet weak var priceFilterView: UIView! {
        didSet {
            priceFilterView.isHidden = true
        }
    }
    
    @IBOutlet weak var brandsAnimator: UIActivityIndicatorView!
   // var priceEstimationMappableResponse: PriceEstimationMappableResponse?
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?
    var carModels = [CarModelObject?]()
    var isFromMore: Bool?
    @IBOutlet weak var numberOfCarsLabel: UILabel!
    //    {
    //        didSet {
    //            numberOfCarsLabel.text = "\(viewModel.carModels.count) \("car_found_result".localized)"
    //        }
    //    }
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stepperStackvIEW: UIStackView!
    lazy var viewModel = GetAvailabelVechilesViewModel()
    var yearFilter = false
    var selectedPrice: Int?
    var selectedBrand: String?
    var tempBrand: String?
    var selectedType: String?
    var isCarTypeSelected: Bool? = false
    var publicFilteredArray : [CarGroup]?
    var temprorayFilterdArray : [CarGroup]?
    @IBOutlet weak var topStackHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (viewModel.isFromMore  ?? false) || ( isFromMore ?? false) {
            stepperStackvIEW.isHidden = true
            filterView.isHidden = true
            clearAllFilterBtnAction.isHidden = true
            stackHeight.constant = 0
            topStackHeight.constant = -20
            title = "more_carfleet_title".localized
            
        } else {
            
            title = "fleet_chooseCar".localized
        }
        let slideDownForPrice = UISwipeGestureRecognizer(target: self, action: #selector(gestureForPrice(gesture:)))
        let slideDownForBrand = UISwipeGestureRecognizer(target: self, action: #selector(gestureForBrand(gesture:)))
        let slideDownForCarTypes = UISwipeGestureRecognizer(target: self, action: #selector(gestureForCarTypes(gesture:)))
        slideDownForPrice.direction = .down
        slideDownForBrand.direction = .down
        slideDownForCarTypes.direction = .down
        priceFilterView.addGestureRecognizer(slideDownForPrice)
        carTypeFilterView.addGestureRecognizer(slideDownForCarTypes)
        brandView.addGestureRecognizer(slideDownForBrand)
        tableView.startShimmerAnimation(withIdentifier: String(describing: VechileTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
        brandsTableView.startShimmerAnimation(withIdentifier: String(describing: BrandTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
        if isFromMore ??  false {
            
            viewModel.getAvailableCars(viewModel.vechileTypeCode)
        } else {
            viewModel.getAvailableCars()
            viewModel.getAvailableCarModel()
            viewModel.getAvailabelCarModels()
        }
        
      
        viewModel.reoloadBrandsTable?()
        viewModel.reloadTableData?()
        carTypesCollectionView.reloadData()
        
        setupvieModel()
        setupCollectioViewInstes()
        viewModel.reoloadBrandsTable?()
        
        btnPrice.setTitle("fleet_price".localized, for: .normal)
        btnApply.setTitle("fleet_apply".localized, for: .normal)
        btnCarType.setTitle("fleet_carType".localized, for: .normal)
        btnBrand.setTitle("fleet_brand".localized, for: .normal)
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.backgroundColor = .white
        
        // Do any additional setup after loading the view.
    }
    
    func brandStartAnimating(){
        
        self.brandsAnimator.isHidden = false
        self.brandsAnimator.startAnimating()
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.CarFleet, screenClass: String(describing: FleetVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.CarFleet, screenClass: String(describing: FleetVC.self))
    }
    
    func setDataToViewModel(isFromMore : Bool? , vechileTypeCode : String?) {
        
        viewModel.isFromMore = isFromMore
        viewModel.vehicleType = vechileTypeCode
    }
    
    @objc func gestureForPrice(gesture: UISwipeGestureRecognizer) {
        addOrRemoveFade( viewToAdd: nil)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.tableView.alpha = 1.0
            self.priceFilterView.isHidden = true
        }
        makeAllEnabled()
        
    }
    @objc func gestureForBrand(gesture: UISwipeGestureRecognizer) {
        addOrRemoveFade( viewToAdd: nil)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.tableView.alpha = 1.0
            self.brandView.isHidden = true
        }
        makeAllEnabled()
        
    }
    
    @objc func gestureForCarTypes(gesture: UISwipeGestureRecognizer) {
        addOrRemoveFade( viewToAdd: nil)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.tableView.alpha = 1.0
            self.carTypeFilterView.isHidden = true
        }
        makeAllEnabled()
        
    }
    
    
    
    
    
    //MARK: - Inject Data
    
    func setDataToFleet(outBranch: Int?,
                        inBranch:Int?,
                        outDate: String?,
                        inDate:String?,
                        outTime: String?,
                        inTime: String?,
                        vehicleType : String?,
                        driverCode : String? = CachingManager.loginObject()?.driverCode) {
        
        viewModel.outBranch = String(outBranch ?? 0)
        viewModel.inBranch = String(inBranch ?? 0)
        viewModel.outDate = outDate
        viewModel.inDate = inDate
        viewModel.outTime = outTime
        viewModel.inTime = inTime
        viewModel.vehicleType = vehicleType
        
        
    }
    
    //MARK: - SetUpViewModel
    
    
    func setupvieModel() {
        
        viewModel.reloadTableData = {  [unowned self] in
            self.tableView.stopShimmerAnimation()
            self.tableView.reloadData()
            
            
        }
        
        viewModel.showResultLabel = { [unowned self] (count) in
            
            numberOfCarsLabel.text = "\(count ?? 0) \("car_found_result".localized)"
            
        }
        
        viewModel.reloadCollectionView =  { [unowned self] in
            
            self.carTypesCollectionView.reloadData()
        }
        
        viewModel.stopBrandsAnimator = { [unowned self] in
            
            self.brandsAnimator.stopAnimating()
            //self.brandsAnimator.removeFromSuperview()
            self.brandsAnimator.isHidden = true
            
        }
        
        viewModel.stopFleetAnimator = { [unowned self] in
            self.fleetActivityIndicator.stopAnimating()
            self.fleetActivityIndicator.removeFromSuperview()
            self.fleetActivityIndicator.isHidden = true
        }
        
        viewModel.setupPrices = { [weak self] (models) in
            for (index,item) in  (self?.viewModel.carModels ?? []).enumerated(){
                
                let  filteredObject = self?.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                if((filteredObject) != nil) {
                    self?.viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0")
                }
                
                //            for item in  viewModel.carModels?  {
                //
                //                let  filteredObject = self.priceEstimationMappableResponse?.priceResponseModel.carGroupModel?.filter({$0.carGrop == item?.group}).first
                //                if((filteredObject) != nil) {
                //                    item?.price = Double(filteredObject?.ratePackagePrice ?? "0")
                //                }
                //
                //            }
            }
        }
        
            viewModel.reoloadBrandsTable =   { [weak self] in
                self?.brandsTableView.stopShimmerAnimation()
                self?.brandsTableView.reloadData()
            }
            
            viewModel.navigateToViewController = { [weak self] (vc) in
                
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        
        
    }
    //MARK: - Initialization
    
    
    func setupCollectioViewInstes() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        carTypesCollectionView.collectionViewLayout = flowLayout
        
    }
    
    //    func setCarModels(_ carModels : [CarModelObject]) {
    //
    //        viewModel.carModels  = carModels
    //    }
    
    class func initializeFromStoryboard() -> FleetVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Fleet, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: FleetVC.self)) as! FleetVC
    }
    
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: FleetVC.initializeFromStoryboard())
    }
    
    
    
    @IBAction func clearFilterForCarTypes(_ sender: Any) {
        
        addFadeBackground(false, color: nil)
        //viewModel.getAvailableCarModel()
        self.tableView.alpha = 1.0
        viewModel.selectedvechileTypeCode = nil
        viewModel.selectedTypeDescription = nil
        
        viewModel.reloadCollectionView?()
        carTypeBtn.setTitle("fleet_carType".localized, for: .normal)
        carTypeBtn.setTitleColor(.darkGray, for: .normal)
        self.carTypeView.backgroundColor = .white
        
        if let vehicleTypes = viewModel.vehicleTypes {
            for (index, _) in vehicleTypes.enumerated() {
                viewModel.vehicleTypes?[index].isSelected = false
            }
        }

        
        carTypeFilterView.isHidden = true
        self.viewModel.reloadTableData?()
        makeAllEnabled()
        applyFilter()
    }
    
    func clearBrandViewDependedOnCarType(){
        viewModel.getBrands()
        for item in viewModel.makeNames {
            item?.isSelected = false
        }
        viewModel.selectedBrand = nil
        applyFilter()
        btnBrand.setTitle("fleet_brand".localized, for: .normal)
        topBrandBtn.setTitleColor(.darkGray, for: .normal)
        topBrandBtn.setTitle("fleet_brand", for: .normal)
        self.topbrandView.backgroundColor = .white
        self.tableView.alpha = 1.0
        self.brandView.isHidden = true
        viewModel.reloadTableData?()
        viewModel.reoloadBrandsTable?()
        makeAllEnabled()
    }
    @IBAction func clearFiltersForBrands(_ sender: Any) {
        addFadeBackground(false, color: nil)
        if yearFilter {
            viewModel.selectedModelYear = nil
            applyFilter()
            viewModel.getModelsYear()
            viewModel.reoloadBrandsTable?()
            yearButtonFilterOutlet.setTitle("Year".localized, for: .normal)
            yearButtonFilterOutlet.setTitleColor(.darkGray, for: .normal)
            (self.yearFilterView.backgroundColor = .white)
            viewModel.reloadTableData?()
            viewModel.reoloadBrandsTable?()
        } else {
            clearBrandViewDependedOnCarType()
        }
        self.tableView.alpha = 1.0
        self.brandView.isHidden = true
        makeAllEnabled()
        
    }
    
    @IBAction func clearFilterPriceButtonAction(_ sender: Any) {
        
        addOrRemoveFade(viewToAdd: nil)
        btnPrice.setTitle("fleet_price".localized, for: .normal)
        
        self.topPriceView.backgroundColor = .white
       // viewModel.getAvailableCarModel()
        viewModel.selectedPrice = nil
        applyFilter()
        self.tableView.alpha = 1.0
        topPriceBtn.setTitle("fleet_price".localized, for: .normal)
        self.topPriceView.backgroundColor = .white
        topPriceBtn.setTitleColor(.darkGray, for: .normal)
        from251to450Btn.isSelected =   false
        from0to250Btn.isSelected = false
        from451to700Btn.isSelected = false
        from701to1000Btn.isSelected = false
        from1001to2000Btn.isSelected = false
        from2001orMoreBtn.isSelected = false
        btnPrice.backgroundColor = .white
        self.priceFilterView.isHidden = true
        self.viewModel.reloadTableData?()
        makeAllEnabled()
        
    }
    
    
    @IBAction func pricFilterBtnAction(_ sender: Any) {
        
        
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.FilterCarPrice, screenClass: String(describing: FleetVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.FilterCarPrice, screenClass: String(describing: FleetVC.self))
        
        addOrRemoveFade(viewToAdd: priceFilterView)
        if   priceFilterView.isHidden {
            self.priceFilterView.isHidden = false
//            UIView.animate(withDuration: 3, delay: 0, options: .transitionFlipFromBottom) {
//                self.priceViewBottomConstraint.constant = 0
//                self.tableView.alpha = 0.7
//            }
            UIView.animate(withDuration: 0.5, animations: {() in
                self.priceViewBottomConstraint.constant = 0
               self.tableView.alpha = 0.7
                self.view.layoutIfNeeded()
            })

            topBrandBtn.isEnabled = false
            carTypeBtn.isEnabled = false
            
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.priceFilterView.isHidden = true
                self.tableView.alpha = 1.0
            }
            topBrandBtn.isEnabled = true
            carTypeBtn.isEnabled = true
        }
        
    }
    
    
    
    @IBAction func applyFilterPriceAction(_ sender: Any) {
        addOrRemoveFade(viewToAdd: nil)
        self.priceViewBottomConstraint.constant = 350
        self.tableView.alpha = 1
        viewModel.selectedPrice = nil
        if viewModel.fullUnfilteredArray.count ?? 0 > 0 {
            priceFilterView.isHidden = true
            publicFilteredArray = applyFilter()
            applyFilter()
            //carModels = viewModel.carModels
            if publicFilteredArray?.count == 0 {
                publicFilteredArray = viewModel.carModels
            }
            if from0to250Btn.isSelected == true {
                
                for (index, item) in  viewModel.carModels.enumerated() {
                    
                    
                    let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
                    }
                    
                }
                viewModel.selectedPrice = .firstRange
                publicFilteredArray = viewModel.carModels
//                let fileterdArray =  publicFilteredArray.filter { $0?.price ?? 0.0 <= 2000.0 && $0?.price ?? 0 >= 1001.0  }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.price ?? 0.0 <= 250.0 }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1
                    priceFilterView.isHidden = true
                    topPriceView.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitleColor(.white, for: .normal)
                    topPriceBtn.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitle( "fleet_from_zero_to_250".localized, for: .normal)
                    viewModel.carModels = filteredArray
                    viewModel.showResultLabel?(filteredArray.count)
                    viewModel.reloadTableData?()
                }
                
            } else if from251to450Btn.isSelected == true {
                
                
                for (index, item) in  viewModel.carModels.enumerated() {
                    
                    
                    let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
                    }
                    
                }
                viewModel.selectedPrice = .secondRange
                publicFilteredArray = viewModel.carModels
//                let fileterdArray =  publicFilteredArray.filter { $0?.price ?? 0.0 <= 2000.0 && $0?.price ?? 0 >= 1001.0  }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter  { $0.price ?? 0 <= 450.0 &&  $0.price ?? 0 >= 251.0  }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1
                    priceFilterView.isHidden = true
                    topPriceView.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitleColor(.white, for: .normal)
                    topPriceBtn.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitle( "fleet_from_251_to_450".localized, for: .normal)
                    viewModel.carModels = filteredArray
                    viewModel.showResultLabel?(filteredArray.count)
                    viewModel.reloadTableData?()
                }
                
            } else if  from451to700Btn.isSelected == true  {
                
                
                for (index, item) in  viewModel.carModels.enumerated() {
                    
                    
                    let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
                    }
                    
                }
                viewModel.selectedPrice = .thirdRange
                publicFilteredArray = viewModel.carModels
//                let fileterdArray =  publicFilteredArray.filter { $0?.price ?? 0.0 <= 2000.0 && $0?.price ?? 0 >= 1001.0  }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter  { $0.price ?? 0.0 <= 700.0 && $0.price ?? 0 >= 451.0   }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1
                    priceFilterView.isHidden = true
                    topPriceView.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitleColor(.white, for: .normal)
                    topPriceBtn.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitle( "fleet_from_451_to_700".localized, for: .normal)
                    viewModel.carModels = filteredArray
                    viewModel.showResultLabel?(filteredArray.count)
                    viewModel.reloadTableData?()
                }
                
              
            }else if from701to1000Btn.isSelected == true {
                
                for (index, item) in  viewModel.carModels.enumerated() {
                    
                    
                    let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
                    }
                    
                }
                viewModel.selectedPrice = .fourthRange
                publicFilteredArray = viewModel.carModels
//                let fileterdArray =  publicFilteredArray.filter { $0?.price ?? 0.0 <= 2000.0 && $0?.price ?? 0 >= 1001.0  }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter  { $0.price ?? 0.0 <= 1000.0 && $0.price ?? 0 >= 701.0   }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1
                    priceFilterView.isHidden = true
                    topPriceView.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitleColor(.white, for: .normal)
                    topPriceBtn.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitle( "fleet_from_701_to_1000".localized, for: .normal)
                    viewModel.carModels = filteredArray
                    viewModel.showResultLabel?(filteredArray.count)
                    viewModel.reloadTableData?()
                }
                
                
               
            } else if from1001to2000Btn.isSelected == true  {
                for (index, item) in  viewModel.carModels.enumerated() {
                    
                    
                    let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
                    }
                    
                }
                viewModel.selectedPrice = .fifthRange
                publicFilteredArray = viewModel.carModels
//                let fileterdArray =  publicFilteredArray.filter { $0?.price ?? 0.0 <= 2000.0 && $0?.price ?? 0 >= 1001.0  }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.price ?? 0.0 <= 2000.0 && $0.price ?? 0 >= 1001.0  }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1
                    priceFilterView.isHidden = true
                    topPriceView.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitleColor(.white, for: .normal)
                    topPriceBtn.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitle( "fleet_from_1001_to_2000".localized, for: .normal)
                    viewModel.carModels = filteredArray
                    viewModel.showResultLabel?(filteredArray.count)
                    viewModel.reloadTableData?()
                }
            } else if from2001orMoreBtn.isSelected == true  {
                
                
                for (index, item) in  viewModel.carModels.enumerated() {
                    
                    
                    let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == item.group}).first
                    if((filteredObject) != nil) {
                        viewModel.carModels[index].price = Double(filteredObject?.ratePackagePrice ?? "0") ?? 0.0
                    }
                    
                }
                viewModel.selectedPrice = .sixRange
                publicFilteredArray = viewModel.carModels
//                let fileterdArray =  publicFilteredArray.filter { $0?.price ?? 0.0 <= 2000.0 && $0?.price ?? 0 >= 1001.0  }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.price ?? 0.0 > 2000.0 }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1
                    priceFilterView.isHidden = true
                    topPriceView.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitleColor(.white, for: .normal)
                    topPriceBtn.backgroundColor = .theebPrimaryColor
                    topPriceBtn.setTitle( "fleet_from_2000_to_more".localized, for: .normal)
                    viewModel.carModels = filteredArray
                    viewModel.showResultLabel?(filteredArray.count)
                    viewModel.reloadTableData?()
                }
                
                
               
            }
            
            makeAllEnabled()
            self.tableView.alpha = 1
            
            
        }
        
        
    }
    
    
    
    @IBAction func from0to250btnAction(_ sender: Any) {
        resetPriceSelection() // Ensure other selections are reset
        from0to250Btn.isSelected = !from0to250Btn.isSelected
        viewModel.selectedPrice = from0to250Btn.isSelected ? .firstRange : nil
        
        
        
    }
    
    
    @IBAction func from251to400btnAction(_ sender: Any) {
        
        resetPriceSelection() // Ensure other selections are reset
        from251to450Btn.isSelected = !from251to450Btn.isSelected
        viewModel.selectedPrice = from251to450Btn.isSelected ? .firstRange : nil
        
    }
    
    
    @IBAction func from451to700BtnAction(_ sender: Any) {
        
        resetPriceSelection() // Ensure other selections are reset
        from451to700Btn.isSelected = !from451to700Btn.isSelected
        viewModel.selectedPrice = from451to700Btn.isSelected ? .firstRange : nil
    }
    
    
    @IBAction func from701to1000BtnAction(_ sender: Any) {
        
       
        
        resetPriceSelection() // Ensure other selections are reset
        from701to1000Btn.isSelected = !from701to1000Btn.isSelected
        viewModel.selectedPrice = from701to1000Btn.isSelected ? .firstRange : nil
    }
    
    @IBAction func from1001to2000BtnAction(_ sender: Any) {
        
        
        resetPriceSelection() // Ensure other selections are reset
        from1001to2000Btn.isSelected = !from1001to2000Btn.isSelected
        viewModel.selectedPrice = from1001to2000Btn.isSelected ? .firstRange : nil
    }
    
    @IBAction func from2001orMoreBtnAction(_ sender: Any) {
        
        resetPriceSelection() // Ensure other selections are reset
        from2001orMoreBtn.isSelected = !from2001orMoreBtn.isSelected
        viewModel.selectedPrice = from2001orMoreBtn.isSelected ? .firstRange : nil
    }
    
    
    
    
    @IBAction func clearAllFilterBtnAction(_ sender: Any) {
        // Start shimmer animations for loading UI
        tableView.startShimmerAnimation(withIdentifier: String(describing: VechileTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
        brandsTableView.startShimmerAnimation(withIdentifier: String(describing: BrandTableViewCell.self), numberOfRows: 8, numberOfSections: 1)

        // Reset all view model properties
        viewModel.selectedBrand = nil
        viewModel.selectedvechileTypeCode = nil
        viewModel.selectedTypeDescription = nil
        viewModel.selectedPrice = nil
        viewModel.selectedModelYear = nil

        // Reset selection for makeNames
        for index in viewModel.makeNames.indices {
            viewModel.makeNames[index]?.isSelected = false
        }
        
        // Reset selection for vehicleTypes
        for index in viewModel.vehicleTypes?.indices ?? 0..<0 {
            viewModel.vehicleTypes?[index].isSelected = false
        }

        viewModel.ModelsYear.removeAll()

        // Update UI for buttons and labels
        carTypeBtn.setTitle("fleet_carType".localized, for: .normal)
        carTypeBtn.setTitleColor(.darkGray, for: .normal)
        topPriceBtn.setTitle("fleet_price".localized, for: .normal)
        topPriceBtn.setTitleColor(.darkGray, for: .normal)
        btnBrand.setTitle("fleet_brand".localized, for: .normal)
        btnBrand.setTitleColor(.darkGray, for: .normal)
        yearButtonFilterOutlet.setTitle("Year".localized, for: .normal)
        yearButtonFilterOutlet.setTitleColor(.darkGray, for: .normal)
        // Reset the text color and background color of all buttons
        resetButtonColors()

        // Reset background colors of all views
        self.topPriceView.backgroundColor = .white
        topPriceBtn.backgroundColor = UIColor.clear
        
        self.topbrandView.backgroundColor = .white
        self.carTypeView.backgroundColor = .white
        self.yearFilterView.backgroundColor = .white

        // Clear selection states for the price buttons
        from0to250Btn.isSelected = false
        from251to450Btn.isSelected = false
        from451to700Btn.isSelected = false
        from701to1000Btn.isSelected = false
        from1001to2000Btn.isSelected = false
        from2001orMoreBtn.isSelected = false

        // Re-fetch and reload available car models
        viewModel.getAvailableCarModel()
        viewModel.reloadCollectionView?()
        viewModel.reoloadBrandsTable?()
        viewModel.reloadTableData?()

        makeAllEnabled()
    }

    func resetButtonColors() {
        // Reset the text color and background color of all filter buttons
        from0to250Btn.setTitleColor(.darkGray, for: .normal)
        from251to450Btn.setTitleColor(.darkGray, for: .normal)
        from451to700Btn.setTitleColor(.darkGray, for: .normal)
        from701to1000Btn.setTitleColor(.darkGray, for: .normal)
        from1001to2000Btn.setTitleColor(.darkGray, for: .normal)
        from2001orMoreBtn.setTitleColor(.darkGray, for: .normal)

        // Reset the background color to default
        from0to250Btn.backgroundColor = .white
        from251to450Btn.backgroundColor = .white
        from451to700Btn.backgroundColor = .white
        from701to1000Btn.backgroundColor = .white
        from1001to2000Btn.backgroundColor = .white
        from2001orMoreBtn.backgroundColor = .white
    }




    
    
    @IBAction func carTypeBtnAction(_ sender: Any) {
        //d
        addOrRemoveFade( viewToAdd: carTypeFilterView)
        
        //clearBrandViewDependedOnCarType()
        if   carTypeFilterView.isHidden {
//            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
//
//                self.tableView.alpha = 0.7
//            }
            self.carTypeFilterView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {() in
                self.carTypeBottomConstraint.constant = 0
               self.tableView.alpha = 0.7
                self.view.layoutIfNeeded()
            })
            topBrandBtn.isEnabled = false
            topPriceBtn.isEnabled = false
            
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.carTypeFilterView.isHidden = true
                self.tableView.alpha = 1.0
            }
            topBrandBtn.isEnabled = true
            topPriceBtn.isEnabled = true
        }
        
    }
    
    
    private func applayYearFilter(){
        self.publicFilteredArray = viewModel.fullUnfilteredArray
        applyFilter()
        if viewModel.selectedModelYear != nil {
            //  if viewModel.carModels.count > 0 {
            if self.publicFilteredArray?.count ?? 0 > 0 {
//                let filteredArray = publicFilteredArray.filter { $0?.modelVersion == viewModel.selectedModelYear}
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.modelVersion == viewModel.selectedModelYear}
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1.0
                    self.brandView.isHidden = true
                    self.brandBottomConstraint.constant = 500
                    yearButtonFilterOutlet.setTitle(viewModel.selectedModelYear, for: .normal)
                    yearButtonFilterOutlet.setTitleColor(.white, for: .normal)
                    self.yearFilterView.backgroundColor = .theebPrimaryColor
                    viewModel.carModels = filteredArray
                    viewModel.reloadTableData?()
                    makeAllEnabled()
                }
            } else {
                //let filteredArray = viewModel.carModels.filter { $0?.modelVersion == viewModel.selectedModelYear }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.modelVersion == viewModel.selectedModelYear }
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1.0
                    self.brandView.isHidden = true
                    self.brandBottomConstraint.constant = 500
                    yearButtonFilterOutlet.setTitle(viewModel.selectedModelYear, for: .normal)
                    yearButtonFilterOutlet.setTitleColor(.white, for: .normal)
                    self.yearFilterView.backgroundColor = .theebPrimaryColor
                    viewModel.carModels = filteredArray
                    viewModel.reloadTableData?()
                    makeAllEnabled()
                }
            }
         //   viewModel.ModelsYear.removeAll()
          //  self.brandsTableView.reloadData()
            
            
            
            //            } else {
            //                return
            //            }
        } else {
            self.tableView.alpha = 1.0
            self.brandView.isHidden = true
            self.brandBottomConstraint.constant = 500
            makeAllEnabled()
            
        }
    }
    @IBAction func applyBrandFilter(_ sender: Any) {
        
        addOrRemoveFade( viewToAdd: nil)
        
        
        
        if yearFilter {
            applayYearFilter()
            
        } else {
            applyFilter()
            isCarTypeSelected = true
        if viewModel.selectedBrand !=   self.tempBrand {
            
            if let vehicleTypes = viewModel.vehicleTypes {
                for (index, _) in vehicleTypes.enumerated() {
                    viewModel.vehicleTypes?[index].isSelected = false
                }
            }
            
            //viewModel.reloadCollectionView?()
           // viewModel.selectedvechileTypeCode = nil
            //self.carTypeView.backgroundColor = .white
           // btnCarType.setTitle("fleet_carType".localized, for: .normal)
          //  carTypeBtn.setTitleColor(.darkGray, for: .normal)
            
        }
        
        
        if viewModel.selectedBrand != nil {
            //  if viewModel.carModels.count > 0 {
            if self.publicFilteredArray?.count ?? 0 > 0 {
               // let filteredArray = publicFilteredArray.filter { $0?.makeName == viewModel.selectedBrand}
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.makeName == viewModel.selectedBrand}
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1.0
                    self.brandView.isHidden = true
                    self.brandBottomConstraint.constant = 500
                    topBrandBtn.setTitle(viewModel.selectedBrand, for: .normal)
                    topBrandBtn.setTitleColor(.white, for: .normal)
                    self.topbrandView.backgroundColor = .theebPrimaryColor
                    viewModel.carModels = filteredArray
                    viewModel.reloadTableData?()
                    makeAllEnabled()
                }
            } else {
                //let filteredArray = viewModel.carModels.filter { $0?.makeName == viewModel.selectedBrand }
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.makeName == viewModel.selectedBrand }
                    // Use the filteredArray as needed
                    
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1.0
                    self.brandView.isHidden = true
                    self.brandBottomConstraint.constant = 500
                    topBrandBtn.setTitle(viewModel.selectedBrand, for: .normal)
                    topBrandBtn.setTitleColor(.white, for: .normal)
                    self.topbrandView.backgroundColor = .theebPrimaryColor
                    viewModel.carModels = filteredArray
                    viewModel.reloadTableData?()
                    makeAllEnabled()
                }
            }
            
            
            
            //            } else {
            //                return
            //            }
        } else {
            self.tableView.alpha = 1.0
            self.brandView.isHidden = true
            makeAllEnabled()
            self.brandBottomConstraint.constant = 500
            
        }
        
        }
        
    }
    
    @IBAction func applyFilterCarTypeAction(_ sender: Any) {
        
        
        addOrRemoveFade( viewToAdd: nil)
        //viewModel.selectedBrand = nil
        applyFilter()
        carTypeBottomConstraint.constant = 250
        if viewModel.selectedvechileTypeCode != nil {
            if publicFilteredArray?.count ?? 0 > 0 {
            
           // let filteredArray =  publicFilteredArray.filter { $0?.vTHCode == viewModel.selectedvechileTypeCode}
                if let publicFilteredArray = publicFilteredArray {
                    let filteredArray = publicFilteredArray.filter { $0.vthCode == viewModel.selectedvechileTypeCode}
                    // Use the filteredArray as needed
                    
                    viewModel.carModels = filteredArray
                    viewModel.reloadTableData?()
                    self.publicFilteredArray = filteredArray
                    self.tableView.alpha = 1.0
                    carTypeBtn.setTitle(viewModel.selectedTypeDescription, for: .normal)
                    carTypeBtn.setTitleColor(.white, for: .normal)
                    self.carTypeView.backgroundColor = .theebPrimaryColor
                    carTypeFilterView.isHidden = true
                    makeAllEnabled()
                }
            
        }else {
            
            
            let filteredArray1 =  CachingManager.carModels()?.filter { $0.makeName == viewModel.selectedBrand}
            let filteredArray =  filteredArray1?.filter { $0.vthCode == viewModel.selectedvechileTypeCode}
            viewModel.carModels = filteredArray ?? []
            viewModel.reloadTableData?()
            self.publicFilteredArray = filteredArray ?? []
            self.tableView.alpha = 1.0
            carTypeBtn.setTitle(viewModel.selectedTypeDescription, for: .normal)
            carTypeBtn.setTitleColor(.white, for: .normal)
            self.carTypeView.backgroundColor = .theebPrimaryColor
            carTypeFilterView.isHidden = true
            makeAllEnabled()
        }
        } else {
            self.tableView.alpha = 1.0
            self.carTypeFilterView.isHidden = true
            makeAllEnabled()
            self.carTypeBottomConstraint.constant = 250
            
        }
        
        
    }
    
    func makeAllEnabled() {
        topBrandBtn.isEnabled = true
        carTypeBtn.isEnabled = true
        topPriceBtn.isEnabled = true
        
    }
    
    func addOrRemoveFade(viewToAdd:UIView?){
        if let viewToAdd = viewToAdd{
            addFadeBackground(true, color: .black)
            view.bringSubviewToFront(viewToAdd)
        }else{
            addFadeBackground(false, color: nil)
        }
    }
    
    @IBAction func yearFilterButtonAction(_ sender: Any) {
        yearFilter = true
        brandTitleLabel.text = "Year".localized
        viewModel.makeNames.removeAll()
        self.brandsTableView.reloadData()
        
       
//        UIView.animate(withDuration: 0.4, delay: 1, options: .curveEaseInOut) {
//            self.brandView.isHidden = false
//            self.tableView.alpha = 1
//        }
            
    //}
        if  brandView.isHidden {
            topPriceBtn.isEnabled  = false
            carTypeBtn.isEnabled = false
                            self.tableView.alpha = 0.3
                            self.brandView.isHidden = false
                            self.addOrRemoveFade( viewToAdd: self.brandView)
//            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {

//            }

            UIView.animate(withDuration: 0.5, animations: {() in
                self.brandBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {

            topPriceBtn.isEnabled  = true
            carTypeBtn.isEnabled = true
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.tableView.alpha = 1.0
                self.brandView.isHidden = true
            }
            
        }
        self.brandsAnimator.isHidden = true
        viewModel.getModelsYear()
        
        
    }
    @IBAction func brandBtnAction(_ sender: Any) {
        self.brandsAnimator.isHidden = true
        yearFilter = false
        viewModel.ModelsYear.removeAll()
        self.brandsTableView.reloadData()
        brandTitleLabel.text = "checkout_brand_filter_title".localized

        addOrRemoveFade( viewToAdd: brandView)
      //  brandStartAnimating()
        viewModel.getBrands()
        
        if  brandView.isHidden {
            topPriceBtn.isEnabled  = false
            carTypeBtn.isEnabled = false
                            
                            self.brandView.isHidden = false
//            UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseInOut) {

//            }
            UIView.animate(withDuration: 0.5, animations: {() in
                self.brandBottomConstraint.constant = 0
                self.tableView.alpha = 1
                self.view.layoutIfNeeded()
            })
            
        } else {
            
            topPriceBtn.isEnabled  = true
            carTypeBtn.isEnabled = true
            UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseInOut) {
                self.tableView.alpha = 1.0
                self.brandView.isHidden = true
            }
            
            
        }
    }
    
    //MARK:- Helper Methods
    
    func returnCarInsurancePrice(group:String)->String? {
        
        
        guard var fileteredCarModelArray = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice else {
            return ""
            
        }
        
        
        fileteredCarModelArray = (priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter( { (arr: CarGroupPrice) -> Bool in
            
            if (arr.carGrop == group)
            {
                return true
            }
            
            return false
        })) ?? [CarGroupPrice]()
        return fileteredCarModelArray.first?.insuranceSum ?? ""
    }
    
    
}

//MARK: UITableViwDataSource

extension FleetVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VechileTableViewCell.self), for: indexPath) as! VechileTableViewCell
            
            let car = viewModel.getCar(atIndex: indexPath.row)
            
            let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == car?.group}).first
            
            
            if((filteredObject) != nil)
            {
                if   filteredObject?.ratePackage == "1D" {
                    
                    cell.pricePerDayLabel.text =  "\(String(describing: filteredObject?.ratePackagePrice ?? "" ))" +  "sar".localized +  "per_day_label".localized
                    
                } else {
                    
                    cell.pricePerDayLabel.text =  "\(String(describing: filteredObject?.ratePackagePrice ?? "" ))" +  "sar".localized +  "per_month_label".localized
                    
                    
                }
                
            }
            
            cell.showCar(car)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BrandTableViewCell.self), for: indexPath) as! BrandTableViewCell
            if yearFilter {
                cell.brandNameLbel.text = viewModel.ModelsYear[indexPath.row]?.modelYear
                cell.checkButton.isSelected = viewModel.ModelsYear[indexPath.row]?.isSelected ?? false
                cell.slectBtnAction = { [weak self] in
                    
                    for item in self?.viewModel.ModelsYear ?? [] {
                        item?.isSelected = false
                    }
                    
                    self?.viewModel.ModelsYear[indexPath.row]?.isSelected = !(self?.viewModel.ModelsYear[indexPath.row]?.isSelected ?? false)
                    
                    
                    if self?.viewModel.ModelsYear[indexPath.row]?.isSelected ?? false {
                        self?.viewModel.selectedModelYear =  self?.viewModel.ModelsYear[indexPath.row]?.modelYear
                    }
                    
                    self?.viewModel.reoloadBrandsTable?()
                }
            } else {
            let brand = viewModel.brand(atIndex: indexPath.row)
            
            cell.showBrand(brand)
            cell.slectBtnAction = { [weak self] in
                
                for item in self?.viewModel.makeNames ?? [] {
                    item?.isSelected = false
                }
                brand?.isSelected = !(brand?.isSelected ?? false)
                
                
                if brand?.isSelected ?? false {
                    self?.viewModel.selectedBrand =  brand?.makeName
                }
                
                self?.viewModel.reoloadBrandsTable?()
            }
            }
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            print(viewModel.numberOfCarModels(),publicFilteredArray?.count)
            return viewModel.numberOfCarModels() ??  0
        } else {
            
            return (yearFilter) ? viewModel.ModelsYear.count : viewModel.numberOfBrands() ??  0
        }
        
        
    }
    
}


//MARK: UITableViwDataSource

extension FleetVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == self.tableView {
            let car = viewModel.getCar(atIndex: indexPath.row)
            
            viewModel.priceEstimationMappableResponseJson = priceEstimationMappableResponseJson

            let  filteredObject = self.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({$0.carGrop == car?.group}).first
            
            if((filteredObject) != nil)
            {
                if   filteredObject?.ratePackage == "1D" {

    
                    viewModel.carPrice =  "\(String(describing: filteredObject?.ratePackagePrice ?? "" ))" +  "sar".localized + "per_day_label".localized
                    
                } else {
                    
                    viewModel.carPrice =  "\(String(describing: filteredObject?.ratePackagePrice ?? "" ))" +  "sar".localized + "per_month_label".localized
                    
                }
                
            }
            viewModel.insrancePrice   = "\((returnCarInsurancePrice(group:car?.group ?? "")) ?? "")"
            
            viewModel.didSelectCar(atIndex: indexPath.row, fromMore:isFromMore )
            
            
            
        } else if tableView == brandsTableView {
            
            if yearFilter {
                if viewModel.ModelsYear[indexPath.row]?.isSelected ?? false {
                    viewModel.selectedModelYear =  viewModel.ModelsYear[indexPath.row]?.modelYear
                }
            } else{
            let brand =  viewModel.brand(atIndex: indexPath.row)
            for item in viewModel.makeNames {
                item?.isSelected = false
            }
            
            if brand?.isSelected ?? false {
                brand?.isSelected = false
            } else {
                brand?.isSelected = true
            }
            
            
            if brand?.isSelected ?? false {
                viewModel.selectedBrand =  brand?.makeName
                self.tempBrand = brand?.makeName
            }
            
        }
            viewModel.reoloadBrandsTable?()
            
            
            
        }
        
    }
}

//MARK: UICollectionViwDataSource
extension FleetVC : UICollectionViewDelegate {
    
    
}

//MARK: UICollectionViwDataSource (Car Types)

extension FleetVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfVechileTypes() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarTypesCollectionViewCell.self), for: indexPath) as! CarTypesCollectionViewCell
        let vechType =  viewModel.vechileType(atIndex: indexPath.row)
        if vechType?.isSelected ?? false {
            cell.backGroundView.layer.borderColor = UIColor.theebPrimaryColor.cgColor // Set the border color for the selected one
            cell.backGroundView.backgroundColor = .theebPrimaryColor // Set the background color for the selected one
            cell.cartTypeName.textColor = .white // Set the text color for the selected one
        } else {
            cell.backGroundView.layer.borderColor = UIColor.lightGray.cgColor // Set the border color for the selected one
            cell.backGroundView.backgroundColor = .white // Set the background color for the selected one
            cell.cartTypeName.textColor =  UIColor.theebPrimaryColor // Set the text color for the selected one
        }
        
        cell.showType(vechType)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselect all vehicle types (to reset selection state)
        if let vehicleTypes = viewModel.vehicleTypes {
            for (index, _) in vehicleTypes.enumerated() {
                viewModel.vehicleTypes?[index].isSelected = false
            }
        }

        // Deselect all visible cells (to reset their UI)
//        for cell in collectionView.visibleCells as! [CarTypesCollectionViewCell] {
//            cell.backGroundView.layer.borderColor = UIColor.clear.cgColor // Reset border
//            cell.backGroundView.backgroundColor = .white // Reset background
//            cell.cartTypeName.textColor = .black // Reset text color
//        }

        // Select the current item
        viewModel.vehicleTypes?[indexPath.row].isSelected = true
        let selectedType = viewModel.vechileType(atIndex: indexPath.row)
        
        // Update UI for the selected cell
        // Set selected vehicle type code and description
        viewModel.selectedvechileTypeCode = selectedType?.code
        viewModel.selectedTypeDescription = Language.isRTL ? selectedType?.desc : selectedType?.description_2
        
        // Reload collection view to reflect the changes (if needed)
        viewModel.reloadCollectionView?()
    }



    
    
    
}


extension FleetVC {
    
    enum PriceRange {
        case firstRange    // 0 - 250
        case secondRange   // 251 - 450
        case thirdRange    // 451 - 700
        case fourthRange   // 701 - 1000
        case fifthRange    // 1001 - 2000
        case sixRange      // 2001 and more
    }

    func resetPriceSelection() {
        from0to250Btn.isSelected = false
        from251to450Btn.isSelected = false
        from451to700Btn.isSelected = false
        from701to1000Btn.isSelected = false
        from1001to2000Btn.isSelected = false
        from2001orMoreBtn.isSelected = false
    }

    func applyFilter() -> [CarGroup] {
        // First, update the car prices
        updateCarPrices()

        // Start filtering with the updated prices
        var filteredArray = viewModel.fullUnfilteredArray

        if let selectedBrand = viewModel.selectedBrand, !selectedBrand.isEmpty {
            filteredArray = filteredArray.filter { $0.makeName?.localizedCaseInsensitiveContains(selectedBrand) ?? false }
        }

        if let selectedTypeCode = viewModel.selectedvechileTypeCode, !selectedTypeCode.isEmpty {
            filteredArray = filteredArray.filter { $0.vthCode == selectedTypeCode }
        }

        if let selectedModelYear = viewModel.selectedModelYear {
            filteredArray = filteredArray.filter { $0.modelVersion == selectedModelYear }
        }

        if let selectedPrice = viewModel.selectedPrice {
            let priceRange = getPriceRange(for: selectedPrice)
            filteredArray = filteredArray.filter { car in
                guard let carPrice = car.price else { return false }
                return priceRange.contains(carPrice)
            }
        }

        viewModel.carModels = filteredArray
        publicFilteredArray = filteredArray
        viewModel.showResultLabel?(filteredArray.count)
        viewModel.reloadTableData?()

        return filteredArray
    }



    
    func getPriceRange(for price: PriceFilterRanges) -> ClosedRange<Double> {
        switch price {
        case .firstRange:
            return 0...250
        case .secondRange:
            return 251...450
        case .thirdRange:
            return 451...700
        case .fourthRange:
            return 701...1000
        case .fifthRange:
            return 1001...2000
        case .sixRange:
            return 2001...Double.greatestFiniteMagnitude
        }
    }

    func updateCarPrices() {
        guard let priceDetails = priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice else { return }

        // Loop through each car model and assign the price from the matching `carGroupPrice`
        for index in viewModel.fullUnfilteredArray.indices {
            let car = viewModel.fullUnfilteredArray[index]
            if let matchingPrice = priceDetails.first(where: { $0.carGrop == car.group }) {
                let priceValue = Double(matchingPrice.ratePackagePrice ?? "0") ?? 0.0
                viewModel.fullUnfilteredArray[index].price = priceValue
            }
        }
    }


}
