//
//  HomeVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 20/08/1443 AH.
//

import UIKit
import Fastis
import ViewAnimator
import GLWalkthrough
import AppsFlyerLib
import FirebaseRemoteConfig

class HomeVC: BaseViewController , UICollectionViewDelegateFlowLayout {

    //MARK: - Outlets
    
    
    @IBOutlet weak var topLogoImageView: UIImageView! {
        didSet {
            topLogoImageView.imageWithFade = UIImage(named: "logo")
        }
    }
    @IBOutlet weak var offersTitleLabel: UILabel! {
        didSet {
            offersTitleLabel.text = "offers_title_label".localized
        }
    }
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sosBtn: UIButton! {
        didSet {
            sosBtn.makeCircular()
        }
    }
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var returnDateTimeView: UIView!
    @IBOutlet weak var returnDateandTimeTextField: DropDown! {
        didSet {
            returnDateandTimeTextField.arrow.isHidden = true
            returnDateandTimeTextField.setLeftPaddingPoints(45.0)

        }
    }
    
    
    @IBOutlet weak var hintDateTimeLabel: UILabel! {
        didSet {
            hintDateTimeLabel.text = "mapLocation_pickUpAndReturnTime".localized
            hintDateTimeLabel.textColor = .weemDarkGray
          

        }
    }
    @IBOutlet weak var lblStaticBookNow: UILabel!
    @IBOutlet weak var searchForCarView: UIView!
    @IBOutlet weak var searchForCarBtn: UIButton!
    
    @IBOutlet weak var offersCollectionView: UICollectionView! {
        didSet {
          self.offersCollectionView.isPagingEnabled = true;
            offersCollectionView.withShimmer = true
            offersCollectionView.layer.cornerRadius = 8
            offersCollectionView.delegate = self
            offersCollectionView.dataSource = self
        }
        
    }
    
    

    @IBOutlet weak var pickupView: TwoTextFieldsView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerStackView: UIStackView!
    static var branchStateTuble:(pickupBranch:Int?,returnBranch: Int?)
    static var isFromSuccesVc = false
    let isArabic = UIApplication.isRTL()
    var outDate: String?
    var inDate : String?
    var outDateDateFormat: Date?
    var inDateDateFormat : Date?
    var inTime: String?
    var outTime: String?
    var datePickerVC: DateTimePickerVC?
    var timeParentView:UIView?
    var timePArentHeightConstraint: NSLayoutConstraint!
    var isFromDatePickerVc = false
    var viewModel = DatePickerViewModel()
    var getbranchesviewModel = BranchesLocationsViewModel()
    var selectedTextField = UITextField()
    private var indexCurrentCell = 0
    private weak var timer: Timer?
    var coachMarker:GLWalkThrough?
    lazy var offersViewModel  = GetOffersViewModel()
    let imageNames = [ "OfferImage" , "SecondOffer"]
    lazy var screenRatio = calculateRatio()
    private let animations = [AnimationType.from(direction: .right, offset: 20.0)]

    //MARK: - View Life Cycle
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickupView.semanticContentAttribute = .forceLeftToRight
        setCoacherMaker()
        
        self.hideKeyboardWhenTappedAround()
        titleLabel.text = "mapLocation_pickUp".localized

        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()

        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = UIColor.lightGray
        self.tabBarController?.tabBar.addSubview(lineView)
       // if CachingManager.locations() == nil {
//            getbranchesviewModel.getBrachesData()
            
     //   }
        
        if !isFromDatePickerVc {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                if self.topLogoImageView.transform.isIdentity {
                    self.topLogoImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.topLogoImageView.image = UIImage(named: "logo")
                    self.topLogoImageView.transform = .identity
                }
            }, completion: nil)
        }

        
//        if !isFromDatePickerVc   {
//            self.topLogoImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
//                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
//                        self.topLogoImageView.image = UIImage(named: "logo")
//                        self.topLogoImageView.transform = .identity
//                    }, completion: nil)
//        }
        
      
    
       

       
        navigationController?.navigationBar.isHidden = true
 
        setPickupAndDropOffBranches()
//        startAutoscrolling()
        setupCollectioViewInstes()
        if isFromDatePickerVc {setDateOnLabel()}
        setupViewModel()
        offersViewModel.getOfferstData()
        //offersCollectionView.reloadData()
        
        getCDPfromFirebaseRemoteConfig { priceEstimateCDP in
            if let cdp = priceEstimateCDP {
                print("Fetched price estimate CDP: \(cdp)")
                CachingManager.store(value: cdp, forKey: CachingKeys.PriceEstimateCDP)
            } else {
                print("Failed to fetch price estimate CDP.")
            }
        }
    }
    
    
    
  
    
    func setCoacherMaker(){
        guard CachingManager.isFirstLogin == nil else {return}
        CachingManager.isFirstLogin = true
        coachMarker = GLWalkThrough()
       // sosBtn.isHidden = false
       // contentView.bringSubviewToFront(sosBtn)
        coachMarker?.dataSource = self
        coachMarker?.delegate = self
        coachMarker?.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
       
        self.hideKeyboardWhenTappedAround()
      
        titleLabel.text = "mapLocation_pickUp".localized

        //First, remove the default top line and background
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = UIColor.lightGray
        self.tabBarController?.tabBar.addSubview(lineView)
       
      
        navigationController?.navigationBar.isHidden = true
        
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.Dashboard), screenClass: String(describing: HomeVC.self))
        setPickupAndDropOffBranches()
//        startAutoscrolling()
        //offersViewModel.getOfferstData()
       // setupCollectioViewInstes()
      //  setupPickupView()
        setupViewModel()
       // handleView()
//
     //  startAutoscrolling()
//        offersCollectionView.reloadData()
        
    }
    
    func setDateOnLabel(){
        let finalInDate = DateUtils.stringFromDate(inDateDateFormat , format: DateFormats.FullDatee)
        let finalOutDate = DateUtils.stringFromDate(outDateDateFormat , format: DateFormats.FullDatee)
        //homeVC.outDate = DateUtils.stringFromDate(Self.pickupDateForPicker)
       // hintDateTimeLabel.text = String(format: "%@ , %@ PM - %@ , %@ PM", (finalOutDate ?? "" ) , (outTime ?? "") , (finalInDate ?? "" ) , (inTime ?? ""))
        hintDateTimeLabel.text = String(format: "%@ , %@  - %@ , %@ ", (finalOutDate ?? "" ) , (outTime ?? "") , (finalInDate ?? "" ) , (inTime ?? ""))
        hintDateTimeLabel.textColor = .weemBlack
    }
    
    private func startAutoscrolling() {
        indexCurrentCell = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

//            guard !self.items.isEmpty else {
//                return
//            }

            if self.indexCurrentCell <  3  {
                let indexPath = IndexPath(item: self.indexCurrentCell, section: 0)
                self.offersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.indexCurrentCell += 1
            } else {
                self.indexCurrentCell = 1
                self.offersCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        timer?.fire()
    }

    func calculateRatio()->(norm:CGFloat,expand:CGFloat){
        if UIDevice().userInterfaceIdiom == .phone {
          switch UIScreen.main.nativeBounds.height {
          case 1334:
            print("iPhone 6/6S/7/8,SE")
            return (0.19,1.55)
          case 1920:
            print("iPhone 6+/6S+")
            return(0.19,1.5)
          case  2208:
            print("iPhone 6+/6S+/7+/8+")
            return (0.19,1.4)
          case 2340:
              print("iPhone 12")
              return (0.17,1.35)
          case 2532:
              print("iphone 13 pro")
              return (0.17,1.35)
          default:
            return (0.165,1.3)
          }
        }
        return (0.165,1.3)
      }


    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
       // offersCollectionView.startShimmerAnimation(withIdentifier: String(describing: OffersCollectionViewCell.self), numberOfRows: 4, numberOfSections: 1)
        headerViewHeight.constant = (isPad) ? 126.885 : view.frame.height*screenRatio.norm //844.0
        ShimmerOptions.instance.backgroundColor = UIColor.weemLightGray
        ShimmerOptions.instance.gradientColor = UIColor.weemGrayBorder
        ShimmerOptions.instance.animationAutoReserse = false
        ShimmerOptions.instance.animationType = .classic
        startShimmerAnimation()
//        homeVC.inDate = DateUtils.stringFromDate(Self.returnDateForPicker)
//        homeVC.outDate = DateUtils.stringFromDate(Self.pickupDateForPicker)
        setPickupAndDropOffBranches()
        [pickupView.txtFieldPickup,pickupView.txtFieldReturn].forEach{
            if !($0?.text?.isEmpty ?? false){$0?.setTextFieldAttributedPlaceholder("")}
        }
        navigationController?.navigationBar.isHidden = true
        setupPickupView()
        handleView()
    }
    
    
    
    private func alertUser(msg:String){
//         let banner = Banner(title: msg, image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
//         banner.dismissesOnTap = true
//         banner.show(duration: 5.0)
        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    //MARK: - Initialization
    
    class func initializeFromStoryboard() -> HomeVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Home, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: HomeVC.self)) as! HomeVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: HomeVC.initializeFromStoryboard())
    }
    
    func getLocale()->String{
        switch Language.currentLanguage{
        case .arabic:
            return "ar"
        case .english:
            return "en"
        case .french:
            return "fr"
        case .chinese:
            return "zh-Hans"
        }
    }
    
    func chooseDate() {
        var customConfig = FastisConfig.default
        customConfig.monthHeader.labelColor = .theebColor
        customConfig.monthHeader.monthLocale = Locale(identifier: getLocale())
        customConfig.monthHeader.labelFont = UIFont.logoutItemFont
        customConfig.weekView.height  = 50
        customConfig.dayCell.dateLabelFont = UIFont.BahijTheSansArabicPlain(fontSize: 17) ?? UIFont.systemFont(ofSize: 17)
        customConfig.weekView.textColor = .weemBlack
        customConfig.weekView.backgroundColor = .white
        customConfig.dayCell.selectedBackgroundColor = .theebColor
        customConfig.dayCell.customSelectionViewCornerRadius = 8
        customConfig.currentValueView.textColor = .theebColor
        customConfig.currentValueView.insets  =  UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        customConfig.currentValueView.locale = .current
        customConfig.controller.barButtonItemsColor  = .theebColor

        customConfig.currentValueView.textFont  = UIFont.BahijTheSansArabicSemiBold(fontSize: 17) ?? UIFont.systemFont(ofSize: 17)
        customConfig.weekView.textFont = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        let fastisController = FastisController(mode: .range, config: customConfig)
        fastisController.isArabic = UIApplication.isRTL()
        fastisController.title = "datePicker_chooseDate".localized

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
            }
        }
        
        fastisController.secondHandler = {[weak self] val in
//            self?.datePickerVC?.returnDate = nil
//            self?.datePickerVC?.pickupDate =  nil
//            DateTimePickerVC.pickupDateForPicker = nil
//            DateTimePickerVC.returnDateForPicker = nil
            self?.timeParentView?.removeFromSuperview()
        }
        fastisController.present(above: self)
    }
    
//    func constrauctTimeView(onView:UIView){
//         timeParentView = UIView()
//        onView.addSubview(timeParentView!)
//        timeParentView!.anchor(nil, left: onView.leftAnchor, bottom: onView.bottomAnchor, right: onView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -onView.frame.height/3, rightConstant: 0, widthConstant: 0, heightConstant: onView.frame.height/3)
//        if let btmConst = onView.constraints.first(where: { $0.identifier == "btmConst" }) {
//           timePArentHeightConstraint = btmConst
//        }
//    }
    
//    func animateConstraint(_ value:CGFloat){
//        timePArentHeightConstraint.constant = value
//        UIView.animate(withDuration: 0.4, delay: 0,  options: .curveEaseInOut, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let datePickerVC = datePickerVC{
        removeChildVC(mainVc: datePickerVC)
        }
    }
    
    func setPickupAndDropOffBranches(isChooseDate:Bool = false) {
    
        if let returnBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == Self.branchStateTuble.returnBranch}).first as? Branch{
            pickupView.txtFieldReturn.setTextFieldAttributedPlaceholder(Self.isFromSuccesVc ? "mapLocation_selectTReturnLocation".localized:"")
            let loclizedBranchName = isArabic ? returnBranchObject.branchName:returnBranchObject.branchNameTranslated
            pickupView.txtFieldReturn.text = Self.isFromSuccesVc ? nil:loclizedBranchName
        }
        
       if let pickBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == Self.branchStateTuble.pickupBranch}).first as? Branch{
           pickupView.txtFieldPickup.setTextFieldAttributedPlaceholder(Self.isFromSuccesVc ? "mapLocation_selectPickLocation".localized:"")
           let loclizedBranchName = isArabic ? pickBranchObject.branchName:pickBranchObject.branchNameTranslated
           pickupView.txtFieldPickup.text = Self.isFromSuccesVc ? nil:loclizedBranchName

       }
        
        if inDate == nil && inTime == nil && outTime == nil && outDate == nil && isChooseDate{
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.chooseDate()

            }
        }
        
    }
    
  

    //MARK: - Helper Methods
    
    
    func setupCollectioViewInstes() {
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.offersCollectionView.frame.width - 10, height: self.offersCollectionView.frame.height)
     //   flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        offersCollectionView.collectionViewLayout = flowLayout
    
    }
    

    
    func getBranchCodeFromName(_ branchName: String?) -> Int? {
        var branchCode : Int?
        branchCode = nil // Reset branchCode to nil
        
        if let locations = CachingManager.locations() {
            guard let matchedLocation  = locations.filter({
                let filteredBranchName = isArabic ? $0?.branchName: $0?.branchNameTranslated
               return branchName == filteredBranchName}).first as? Branch else {return nil}
            
            return matchedLocation.branchCode
            
        }
        
        return branchCode
    }

    
    func setupPickupView(){
        pickupView.superVC = self
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        TwoTextFieldsView.normalHeight = (isPad) ? 126.885 : view.frame.height*screenRatio.norm
        TwoTextFieldsView.expandableHeight = (isPad) ? 164.9505 : view.frame.height*screenRatio.norm*screenRatio.expand
        pickupView.txtFieldPickup.optionArray.removeAll()//to empty the selection
        pickupView.txtFieldReturn.optionArray.removeAll()
        pickupView.headerViewHeigh = headerViewHeight
        pickupView.complitionBtnReturn = chooseAntoherReturnLocationBtnAction//button return action
        pickupView.txtFieldReturn.delegate = self
        pickupView.txtFieldPickup.delegate = self
        returnDateandTimeTextField.delegate = self
    }
    
    func handleView() {
        
        
        lblStaticBookNow.text = "checkOutVC_bookow".localized
        pickupView.lblstaticReturn.text = "mapLocation_differentCity".localized
        searchForCarBtn.setTitle("mapLocation_serechForCar".localized, for: .normal)
        if Self.branchStateTuble.pickupBranch == Self.branchStateTuble.returnBranch || Self.branchStateTuble.returnBranch == nil {
           // removeInputView(view: returnLocationView)
            pickupView.isSelected = false
        }else if  Self.branchStateTuble.pickupBranch != Self.branchStateTuble.returnBranch {
          //  addInputView(view: returnLocationView, atIndex: 1)
            pickupView.isSelected = true
        }
    }
    
    func removeInputView(view: UIView) {
        
        containerStackView.removeArrangedSubview(view)
        view.isHidden = true
    }
    
    func addInputView(view: UIView, atIndex index: Int) {
        
        containerStackView.insertArrangedSubview(view, at: index)
        view.isHidden = false
    }
    
    func setupViewModel() {
        let inTime24 = inTime//DateUtils.convertPmTo24(time: inTime ?? "")
        let outTime24 = outTime//DateUtils.convertPmTo24(time: outTime ?? "")
        
        viewModel.pushViewController  = { [weak self] vc in
            guard let self = self else {return}
            CustomLoader.customLoaderObj.startAnimating()
            self.viewModel.getPriceEstimationJson(getCarsVC: FleetVC.initializeFromStoryboard(), outBranch: self.getBranchCodeFromName(self.pickupView.txtFieldPickup.text ?? ""), inBranch: self.getBranchCodeFromName((self.pickupView.txtFieldReturn.text == "") ? self.pickupView.txtFieldPickup.text ?? "": self.pickupView.txtFieldReturn.text ?? "") , outDate: self.outDate, inDate: self.inDate, outTime: outTime24, inTime: inTime24, vehicleType: "")
                
           // self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        offersViewModel.reloadCollectionView = { [weak self] in
            self?.stopShimmerAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self?.offersCollectionView.reloadData()
                self?.applyAnimation()
            }
            
        }
        
        viewModel.navigate = { [weak self] vc in
            CustomLoader.customLoaderObj.stopAnimating()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        getbranchesviewModel.stopAnimation = { [weak self]  in
        CustomLoader.customLoaderObj.stopAnimating()
                    let mapVC = BranchesLocationsVC.initializeFromStoryboard()
                    mapVC.superVC = self
            mapVC.isSelectedFromHome = self?.pickupView.isSelected ?? false
            if self?.selectedTextField == self?.pickupView.txtFieldPickup {
                        mapVC.titleString = "mapLocation_selectPickLocation".localized
            } else if self?.selectedTextField == self?.pickupView.txtFieldReturn {
                        mapVC.titleString =  "mapLocation_selectTReturnLocation".localized
                    }
            self?.present(mapVC , animated: true)
    }
//        offersViewModel.applyAnimation = { [weak self] in
//
//            self?.applyAnimation()
//
//        }
        
    }
    
    func applyAnimation() {
        
        guard let offersCollectionView = offersCollectionView  else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
          //  self.items = Array(repeating: nil, count: 5)
            self.offersCollectionView.reloadData()
            self.offersCollectionView.performBatchUpdates({
                UIView.animate(views: self.offersCollectionView.orderedVisibleCells,
                               animations: self.animations, completion: {
  
                    })
            }, completion: nil)
        }
    }
    
    func callNumber(phoneNumber:String) {

     if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

       let application:UIApplication = UIApplication.shared
       if (application.canOpenURL(phoneCallURL)) {
           application.open(phoneCallURL, options: [:], completionHandler: nil)
       }
     }
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: offersCollectionView.frame.width / 1.5, height: self.offersCollectionView.frame.height)
    }
    
    //MARK: - Actions
    
    
    @IBAction func sosBtnAction(_ sender: Any) {
        
        self.callNumber(phoneNumber: "920000572")
    }
    
    @IBAction func btnNotificationPressed(_ sender: UIButton) {
        let notificationsHistoryVC = NotificationsHistoryVC.initializeFromStoryboard()
        navigationController?.pushViewController(notificationsHistoryVC, animated: true)
    }
    
    @IBAction func searchForCarButtonActoin(_ sender: Any) {
        
        if inDate == nil || inTime == nil || outTime == nil || outDate == nil || Self.branchStateTuble.pickupBranch == nil  {
            self.alertUser(msg: "please_fill_data".localized)
        }else {
            if pickupView.isSelected && Self.branchStateTuble.returnBranch == nil{
                self.alertUser(msg: "mapLocation_selectTReturnLocation".localized)
            } else {
            let getCarsVC = FleetVC.initializeFromStoryboard()
            viewModel.pushViewController?(getCarsVC)
            }
           // viewModel.getPriceEstimation(outBranch: getBranchCodeFromName(pickupView.txtFieldPickup.text), inBranch: getBranchCodeFromName(pickupView.txtFieldReturn.text) ?? getBranchCodeFromName(pickupView.txtFieldPickup.text) , outDate: outDate, inDate: inDate, outTime: outTime, inTime: inTime, vehicleType: "")
        }
        
 
        
        
    }
    
    
     func chooseAntoherReturnLocationBtnAction(_ sender: UIButton) {
        pickupView.isSelected = !pickupView.isSelected
         if !pickupView.isSelected{
             HomeVC.branchStateTuble.returnBranch = nil
         }
//        if  chooseReturnBranchBtn.isSelected {
//            addInputView(view:returnLocationView , atIndex: 1)
//
//        } else {
//            removeInputView(view: returnLocationView)
//
//        }
        
    }
    

}

extension HomeVC:  UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        [pickupView.txtFieldPickup,pickupView.txtFieldReturn].forEach{
            if !($0?.text?.isEmpty ?? false){$0?.setTextFieldAttributedPlaceholder("")}
        }
        textField.inputView = UIView()
        textField.resignFirstResponder()
        if textField == returnDateandTimeTextField {
            chooseDate()
            return
        }
        selectedTextField =  textField
        if  let cachedLocations = CachingManager.locations() {
            getbranchesviewModel.branches = cachedLocations
            let mapVC = BranchesLocationsVC.initializeFromStoryboard()
            mapVC.superVC = self
            mapVC.isSelectedFromHome = self.pickupView.isSelected ?? false
            if self.selectedTextField == self.pickupView.txtFieldPickup {
                mapVC.titleString = "mapLocation_selectPickLocation".localized
            } else if self.selectedTextField == self.pickupView.txtFieldReturn {
                mapVC.titleString =  "mapLocation_selectTReturnLocation".localized
            }
            self.present(mapVC , animated: true)
        } else {
            
            CustomLoader.customLoaderObj.startAnimating()
            getbranchesviewModel.getBrachesData()
        }
        
    }
    
    
}

extension HomeVC : UICollectionViewDelegate  {
    
    
}

extension HomeVC : UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return offersViewModel.offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: OffersCollectionViewCell.self), for: indexPath) as! OffersCollectionViewCell
        let offer = offersViewModel.offers[indexPath.row]
        cell.showOffer(offer: offer)
       /// cell.offerImageView.image = UIImage(named:self.imageNames[indexPath.row])
        
      
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
 
        
        let offer = offersViewModel.offers[indexPath.row]
        let infoPopup = AboutDetailVc.initializeFromStoryboard()
        let popupVC = PopupVC.initializeFromStoryboard()
    
      //  infoPopup.contentString = offer?.offerDescription
        infoPopup.contentString = offer?.slug
        infoPopup.fromHome = true
        popupVC.embeddedViewController = infoPopup
        self.present(popupVC, animated: true)
        
    }

}


extension UIImageView{
 var imageWithFade:UIImage?{
        get{
            return self.image
        }
        set{
            UIView.transition(with: self,
                              duration: 3.5, options: .transitionCrossDissolve, animations: {
                                self.image = newValue
            }, completion: nil)
        }
    }
}

extension HomeVC: GLWalkThroughDataSource,GLWalkThroughDelegate {
    func numberOfItems() -> Int {
        2
    }
    
    func configForItemAtIndex(index: Int) -> GLWalkThroughConfig {
        let tabbarPadding:CGFloat = Helper.shared.hasTopNotch ? 92 : 60
        let overlaySize:CGFloat = Helper.shared.hasTopNotch ? 60 : 50
        let leftPadding:CGFloat = Helper.shared.hasTopNotch ? 10 : 5
        switch index {
        case 0:
            var config = GLWalkThroughConfig()
            let returnViewFrame = pickupView.convert(pickupView.returnDifferentView.bounds, to: contentView)
            config.title = "mapLocation_differentCity".localized
            config.subtitle = "mapLocation_ReturnAnyWhere".localized
            config.frameOverWindow = CGRect(x: returnViewFrame.minX, y: returnViewFrame.minY+tabbarPadding, width: 300, height: returnViewFrame.height)
            config.position = .topCenter
            config.isSkipEnabled = false
            return config

//        case 1:
//            let sosFrame = sosBtn.frame
//            var config = GLWalkThroughConfig()
//            config.title = "SOS"
//            config.subtitle = "Select the location to where you want the car"
//            config.frameOverWindow = Helper.shared.hasTopNotch ? sosFrame:CGRect(x: sosFrame.origin.x, y: sosFrame.origin.y - (tabbarPadding/2), width: sosFrame.size.width, height: sosFrame.size.height)
//            config.position = .bottomCenter
//            return config
        case 1:
            guard let frame = getTabbarFrame(index: 0) else {
                return GLWalkThroughConfig()
            }
            var config = GLWalkThroughConfig()
            config.title = "mapLocation_ReturnYourCars".localized
            config.subtitle = "mapLocation_TrackYourBookink".localized
            config.frameOverWindow = CGRect(x: frame.origin.x + leftPadding+8, y: view.frame.size.height, width: overlaySize, height: overlaySize)
            config.position = .bottomCenter
            return config
       
//        case 3:
//
//            var config = GLWalkThroughConfig()
//            config.title = "ChatBot"
//            config.subtitle = "Ask a Service, Query, Plan to Bot"
//            config.nextBtnTitle = "Ask a Query"
//
////            config.frameOverWindow = CGRect
//            config.position = .bottomCenter
//            return config
        default:
            return GLWalkThroughConfig()
        }
    }
    
    func didSelectNextAtIndex(index: Int) {
        if index == 2 {
            coachMarker?.dismiss()
           // sosBtn.isHidden = true
        }
    }
    
    func didSelectSkip(index: Int) {
       // sosBtn.isHidden = true
        coachMarker?.dismiss()
    }
    
    func getTabbarFrame(index:Int) -> CGRect? {
        if let bar = self.tabBarController?.tabBar.subviews {
            var idx = 0
            var frame = CGRect()
            for view in bar {
                if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                    print(view.description)
                    if idx == index {
                        frame =  view.frame
                    }
                    idx += 1
                }
            }
            return frame
        }
        return nil
    }
}

struct Helper {
    static var shared = Helper()
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

//MARK: - CDP Remote config

extension HomeVC {
    func getCDPfromFirebaseRemoteConfig(completion: @escaping (String?) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        // Fetch and activate remote config values
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                let priceEstimateCDP = remoteConfig["price_estimate_cdp"].stringValue
                completion(priceEstimateCDP)
            } else {
                print("Failed to fetch remote config: \(error?.localizedDescription ?? "No error available.")")
                completion(nil)
            }
        }
    }
}
