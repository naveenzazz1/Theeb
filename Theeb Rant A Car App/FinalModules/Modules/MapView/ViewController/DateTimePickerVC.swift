//
//  DateTimePickerVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 11/07/1443 AH.
//

import UIKit
import Fastis
import Firebase

class DateTimePickerVC: BaseViewController {
     
    //vars
    lazy var dateFormatter = DateFormatter()
    var superVc:UIViewController?
    let timeView:RoundedShadowView = {
        let viewTime = RoundedShadowView()
        viewTime.backgroundColor = .clear
        viewTime.tag = 1234
        return viewTime
    }()
    var textDays = ""
    var returnDate: String? = nil
//    var pickupBranchId: String? = nil
//    var returnBranchId: String? = nil
    var pickupBranchCode: String? = nil
    var rerunBranchCode: String? = nil
    var pickupDate: String? = nil
    static var pickupDateForPicker: Date?
    static var returnDateForPicker: Date?
    static var isPickup = true
    var viewModel = DatePickerViewModel()
    var isAutomatic = true
    lazy var carModels = [CarModelObject?]()
//    lazy var returnTimePicker: UIDatePicker = {
//        return setupAccidentDatePicker()
//    }()
//    lazy var pickupTimePicker: UIDatePicker = {
//        return setupPickupTimePicker()
//    }()
    let btnReturn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(btnReturnPressed(_:)), for: .touchUpInside)
        return btn
    }()
    let btnPickUp:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(btnPickUpPressed(_:)), for: .touchUpInside)
        return btn
    }()
    
    //outlets
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lblStaticReturn: UILabel!
    @IBOutlet weak var lblStaticYouCanReturn: UILabel!
    @IBOutlet weak var lblStaticPickUp: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var datePickerContainer: UIView!
    @IBOutlet weak var returnTimeTextField: CustomTextField!
    @IBOutlet weak var pickUpTimeTextField: CustomTextField!
    @IBOutlet weak var returnDateLabel: UILabel! {
        didSet {
            returnDateLabel?.text = returnDate ?? ""
        }
    }
    @IBOutlet weak var pickupDateLabel: UILabel! {
        didSet {
            pickupDateLabel?.text = pickupDate ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    setUpNavigationButtons()
    
        setupViewModel()
        setupViews()
      //  setupLoginChildViewController()
    }
    
    
    //MARK: - Initialization
    
    func setupViews(){
        returnTimeTextField.text = "10:00"
        pickUpTimeTextField.text = "10:00"
        lblStaticReturn.text = "mapLocation_returnTime".localized
        lblStaticPickUp.text = "mapLocation_pickUpTime".localized
        lblStaticYouCanReturn.text = "mapLocation_youCanReturn".localized
        btnConfirm.setTitle("mapLocation_confirmTime".localized, for: .normal)
        lblDays.text = textDays
        returnTimeTextField.addSubview(btnReturn)
        btnReturn.fillSuperview()
        pickUpTimeTextField.addSubview(btnPickUp)
        btnPickUp.fillSuperview()
        [returnTimeTextField,pickUpTimeTextField].forEach{
            $0?.borderColorVal = UIColor.theebPrimaryColor.cgColor
            $0?.textColor = UIColor.theebPrimaryColor
            $0?.borderWidth = 0.8
        }
        
    }
    
    class func initializeFromStoryboard() -> DateTimePickerVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.MapLocationView, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: DateTimePickerVC.self)) as! DateTimePickerVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: DateTimePickerVC.initializeFromStoryboard())
    }

    func showTimePicker(isPickup: Bool,complition:((Date)->())?){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.16){[weak self] in
            Self.isPickup = isPickup
            self?.addPopUpTimePicker(isPickup: isPickup, complition:complition )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAutomatic = true
        showTimePicker(isPickup: true, complition: pickupTime(_:))
    }
    
    func addPopUpTimePicker(isPickup:Bool,complition:((Date)->())?){
        if let superVc = superVc{
            superVc.addFadeBackground(true,  color:UIColor.black)
            superVc.view.addSubview(timeView)
            timeView.tag = 123
            timeView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                timeView.centerYAnchor.constraint(equalTo: superVc.view.centerYAnchor),
                timeView.centerXAnchor.constraint(equalTo: superVc.view.centerXAnchor),
                timeView.heightAnchor.constraint(equalTo: superVc.view.heightAnchor, multiplier: 0.5),timeView.widthAnchor.constraint(equalTo: superVc.view.widthAnchor, multiplier: 0.8)
            ])
            let timeSelector = TimeChooseView(frame: timeView.bounds)
            timeSelector.superVc = superVc
            timeSelector.complition = complition
            DateTimePickerVC.isPickup = isPickup
          //  timeSelector.isPickup = isPickup
            timeView.addSubview(timeSelector)
            timeSelector.fillSuperview()
           // timeSelector.minimumDate = Self.pickupDateForPicker
          //  timeSelector.maximumDate = Self.returnDateForPicker
            timeSelector.setMinAndMaxDateNewLogic()
            timeView.scaleAnimate()
        }
    }
    
    @objc func btnReturnPressed(_ btn:UIButton){
        addPopUpTimePicker(isPickup: false, complition:  returnTime(_:))
        
    }
    
    @objc func btnPickUpPressed(_ btn:UIButton){
        addPopUpTimePicker(isPickup: true, complition:  pickupTime(_:))
    }
    //MARK: - Setups
    
    func setupViewModel() {
        
        viewModel.pushViewController = { [unowned self] (vc) in
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
     
    }

    
    func setupLoginChildViewController() {
        
    
        addChild(retunrnDatePicker())
        retunrnDatePicker().willMove(toParent: self)
        datePickerContainer.addSubview(retunrnDatePicker().view)
        retunrnDatePicker().didMove(toParent: self)
        setupLoginChildView()
        
    }
    
    func setupLoginChildView() {
        
        retunrnDatePicker().view.frame = datePickerContainer.bounds
    }
    
    
    func retunrnDatePicker() -> UIViewController {
        
        var customConfig = FastisConfig.default
        customConfig.monthHeader.labelColor = .theebColor
        customConfig.monthHeader.monthLocale = Locale(identifier: UIApplication.isRTL() ? "ar":"en")
        customConfig.monthHeader.labelFont = UIFont.logoutItemFont
        customConfig.weekView.height  = 50
        customConfig.weekView.textColor = .weemBlack
        customConfig.weekView.backgroundColor = .white
        customConfig.dayCell.selectedBackgroundColor = .theebColor
        customConfig.dayCell.customSelectionViewCornerRadius = 8
        customConfig.dayCell.dateLabelFont = UIFont.BahijTheSansArabicPlain(fontSize: 17) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        customConfig.currentValueView.textColor = .theebColor
        customConfig.currentValueView.insets  =  UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
     
        customConfig.currentValueView.locale = .current
        customConfig.controller.barButtonItemsColor  = .theebColor
        
        customConfig.currentValueView.textFont  = UIFont.BahijTheSansArabicPlain(fontSize: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        customConfig.weekView.textFont = UIFont.BahijTheSansArabicSemiBold(fontSize: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        let fastisController = FastisController(mode: .range, config: customConfig)
        fastisController.initialValue = FastisRange(from: Self.pickupDateForPicker ??  Date(),  to:Self.returnDateForPicker ??  Date())
        return fastisController
    }
 
    func setUpNavigationButtons() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "dffdsdf".localized, style: .plain, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.weemBlue
    }
    
    @objc func returnTime(_ date:Date) {
        
        returnTimeTextField.text = formattedDate(date: date)?.0
        inTime24 = formattedDate(date: date)?.1 ?? ""
        isAutomatic = false

    }
    
    @objc func pickupTime(_ date:Date) {
        
        pickUpTimeTextField.text = formattedDate(date: date)?.0
        outTime24 = formattedDate(date: date)?.1 ?? ""
        if isAutomatic{
        showTimePicker(isPickup: false, complition: returnTime(_:))
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.SelectTime, screenClass: String(describing: DateTimePickerVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.SelectTime, screenClass: String(describing: DateTimePickerVC.self))
        
    }
    
    

    
    func formattedDate(date: Date?) -> (String?,String?)? {
        
        guard let date = date else { return nil }
        
     //   dateFormatter.dateFormat = DateFormats.TimeOnly
        dateFormatter.dateFormat = "h:mm a"
        let formattedDateAm = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate24 = dateFormatter.string(from: date)
        print(formattedDateAm,formattedDate24)
        return (formattedDateAm,formattedDate24)
    }
    
   
    func getDatesFromRemoteConfig() -> Bool{
        var result = false
        let remoteConfig = RemoteConfig.remoteConfig()
        if let daysOffresult = remoteConfig["reservation_disabled"].jsonValue as? [String : AnyObject] {
            if  let datesString = daysOffresult["dates"] {
                for item in datesString as! [String]{
                    if  item == DateUtils.stringFromDate(Self.pickupDateForPicker, format: "yyyy-MM-dd", local: Locale(identifier: "en_US")) {
                        result = true
                    }
                }
            }
        }
        return result
    }
    
    func offDaysAlert(message: String){
        let alertVc = UIAlertController( title: nil, message: message, preferredStyle: .alert)

        let alertOKAction = UIAlertAction(title: "login_OK".localized, style: .destructive, handler: nil)
        alertVc.addAction(alertOKAction)
        present(alertVc, animated: true)
    }
    
    
    func navigateToHome() {
        let result = getDatesFromRemoteConfig()
        if result {
            let remoteConfig = RemoteConfig.remoteConfig()
            if let daysOffresult = remoteConfig["reservation_disabled"].jsonValue as? [String : AnyObject] {
                let message = UIApplication.isRTL() ? daysOffresult["disabled_message_ar"] as? String : daysOffresult["disabled_message_en"] as? String
                offDaysAlert(message: message ?? "")
            }
            return
        }
        
        let landingPageVC = LandingPageVC.initializeFromStoryboard()
        let homeVC = HomeVC.initializeFromStoryboard()
        
        // Set properties for HomeVC
        homeVC.isFromDatePickerVc = true
        homeVC.inDate = DateUtils.stringFromDate(Self.returnDateForPicker)
        homeVC.outDate = DateUtils.stringFromDate(Self.pickupDateForPicker)
        homeVC.inDateDateFormat = Self.returnDateForPicker
        homeVC.outDateDateFormat = Self.pickupDateForPicker
        homeVC.inTime = returnTimeTextField.text
        homeVC.outTime = pickUpTimeTextField.text
        
        // Initialize the navigation stack
        landingPageVC.viewModel.firstVC = homeVC.initializeWithNavigationController()
        
        // Set the root view controller
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            window.rootViewController = landingPageVC
        }
    }

    
//    func navigateToHome() {
//        let result = getDatesFromRemoteConfig()
//        if result {
//            let remoteConfig = RemoteConfig.remoteConfig()
//            let daysOffresult = remoteConfig["reservation_disabled"].jsonValue as! [String : AnyObject]
//            let message = UIApplication.isRTL() ? daysOffresult["disabled_message_ar"] as? String : daysOffresult["disabled_message_en"] as? String
//            offDaysAlert(message: message ?? "")
//            return
//        }
//            let landingPageVC = LandingPageVC.initializeFromStoryboard()
//            let homeVC = HomeVC.initializeFromStoryboard()
//            //  homeVC.returnLocationTextfield?.text = "sdfghjkjhgfdsa"
//            //        HomeVC.branchStateTuble.pickupBranch = pickupBranchId
//            //        HomeVC.branchStateTuble.returnBranch = returnBranchId
//            homeVC.isFromDatePickerVc = true
//            homeVC.inDate = DateUtils.stringFromDate(Self.returnDateForPicker)
//            homeVC.outDate = DateUtils.stringFromDate(Self.pickupDateForPicker)
//            homeVC.inDateDateFormat = Self.returnDateForPicker
//            homeVC.outDateDateFormat = Self.pickupDateForPicker
//            homeVC.inTime = returnTimeTextField.text
//            homeVC.outTime = pickUpTimeTextField.text
//
//            landingPageVC.viewModel.firstVC  =  homeVC.initializeWithNavigationController()
//
//            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  landingPageVC
//
//    }
    
    @objc func editButtonPressed() {
        
        
        
    }

    @IBAction func searchForCarsButtonAction(_ sender: Any) {
        
        navigateToHome()
        
       // viewModel.getPriceEstimation(outBranch: returnBranchId, inBranch: pickupBranchId, outDate: DateUtils.stringFromDate(pickupDateForPicker), inDate: DateUtils.stringFromDate(returnDateForPicker), outTime:returnTimeTextField.text , inTime: pickUpTimeTextField.text, vehicleType: "")

      

        


    }
    
    
  
}
