//
//  CarDetailsVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/07/1443 AH.
//

import UIKit
import Lottie
import ViewAnimator
import AudioToolbox

class CarDetailsVC : BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var internalAuthrizationLabel: UILabel! {
        didSet {
            internalAuthrizationLabel.text = "cardetails_internal_authrization".localized
        }
    }
    
    @IBOutlet weak var insurenceTableView: UITableView!{
        didSet{
            insurenceTableView.delegate = self
            insurenceTableView.dataSource = self
        }
    }
    @IBOutlet weak var extrasTableViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var recommendedTheebInsuranceLabel: UILabel! {
//        didSet {
//            recommendedTheebInsuranceLabel.text = "car_details_recommended_imsurance" .localized
//        }
//    }
//    @IBOutlet weak var animationView: UIView! {
//        didSet {
//
////            let animationView = AnimationView(animation: Animation.named(fileName))
////            animationView.backgroundBehavior = .pauseAndRestore
////            animationView.loopMode = .loop
//
////            animationView.animation = Animation.named("Shinyyyyy")
////            animationView.scaleAnimate()
////            animationView.play()
////            animationView!.contentMode = .scaleAspectFill
////            animationView.loopMode = .loop
////           // animationView.backgroundBehavior = .pauseAndRestore
//        //    animationView.loopMode = .loop
//
//        }
//    }
    @IBOutlet weak var carModelNameLbl: UILabel!
//    @IBOutlet weak var additionalInsuranceHintLabel: UILabel! {
//        didSet {
//            additionalInsuranceHintLabel.text = "addtional_insurance_recommended_label".localized
//        }
//    }
//    @IBOutlet weak var selectInsuranceBtn: UIButton! {
//        didSet {
//         // selectInsuranceBtn.isSelected = true
//        }
//    }
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var seatsNumberLabel: UILabel!
    @IBOutlet weak var addOnsHintLabel: UILabel! {
        didSet {
            addOnsHintLabel.text = "car_detils_add_ons".localized
        }
    }
    
    
//    @IBOutlet weak var standardInsuranceView: UIView!
//    
//    
//    @IBOutlet weak var selectStandardInsuranceBtn: UIButton! {
//        didSet {
//            selectStandardInsuranceBtn.isSelected = true
//        }
//    }
//    @IBOutlet weak var additionalInsurance: UIButton! {
//        didSet {
//            additionalInsurance.setTitle("", for: .normal)
//        }
//    }

//    @IBOutlet weak var standardHintLabel: UILabel!{
//        didSet{
//            standardHintLabel.text = "standard_insurance".localized
//        }
//    }
//    @IBOutlet weak var standardInsurancePrice: UILabel! {
//        didSet {
//            standardInsurancePrice.text =
//        "+ " +  "0.0" + "sar".localized
//        }
//    }
//    @IBOutlet weak var standardInsuranceInfo: UIButton!{
//        didSet {
//            standardInsuranceInfo.setTitle("", for: .normal)
//        }
//    }
    
    @IBOutlet weak var insuranceTitleLabel: UILabel! {
        didSet {
            insuranceTitleLabel.text = "standard_insurance".localized
        }
    }
    @IBOutlet weak var accidentHelpLabel: UILabel!
    @IBOutlet weak var roadAssistanceLabel: UILabel!
    @IBOutlet weak var freeServicesLabel: UILabel!
    @IBOutlet weak var vatNotIncludedHintLabel: UILabel! {
        didSet {
            vatNotIncludedHintLabel.text = "car_details_price_hint".localized
        }
    }
    @IBOutlet weak var bookNowBtn: UIButton! {
        didSet {
            
            bookNowBtn.setTitle("car_detials_select_car".localized, for: .normal)
        }
       
    }
    @IBOutlet weak var extrasTableView: UITableView! {
        didSet {
            extrasTableView.delegate = self
            extrasTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet weak var addonsView: UIView!
    
  //  @IBOutlet weak var insurancePricelbl: UILabel!
//    @IBOutlet weak var insuranceNameLbl: UILabel!{
//        didSet{
//            loadingPlaceholderView.gradientColor = .lightGray
//            loadingPlaceholderView.backgroundColor = .weemLightGray
//            loadingPlaceholderView.cover(insuranceNameLbl)
//        }
//    }
    @IBOutlet weak var freeKmsLabel: UILabel!
    @IBOutlet weak var airConditioningLabel: UILabel!
    @IBOutlet weak var numberOfBags: UILabel!
    @IBOutlet weak var numberOfDoorsLabel: UILabel!
    @IBOutlet weak var transferTypeLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var vatNotIncluededUnderPriceLabel: UILabel! {
        didSet {
            
            vatNotIncluededUnderPriceLabel.text  = "car_details_price_hint".localized
        }
    }
    
    
    @IBOutlet weak var stepperStackvIEW: UIStackView!
    @IBOutlet weak var pricePerDayLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel!
    
    // MARK: - View Life Cycle
    let loadingPlaceholderView = LoadingPlaceholderView()
    var isFromMore : Bool?
    let isArabic = UIApplication.isRTL()
    var selectedCarObject :CarGroup?
    var selectedCarPrice: String?
    var selectedExtrsForCheckout = [ExtType?]()
    var insuranceName: String?
    var insuranceprice: String?
    var viewModel = CarDetailsViewModel()
    var viewModelSideMenu = SideMenuViewModel()
    var priceEstimationMappableResponseJson: PriceEstimationMappableResponseJson?
    var selectedInsurence:InsType?
    var checkoutVC:CheckoutVC?

    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.insurancePricelbl.text = ""
        handleViews()
        bindUserPorfile()
        checkStopList()
    //    recommendedTheebInsuranceLabel.flash()
        if isFromMore ?? false {
            insuranceView.isHidden = true
            addonsView.isHidden = true
            bookNowBtn.isHidden = true
            stepperStackvIEW.isHidden = true
        
        }
        title = "car_details_title".localized
        navigationController?.navigationBar.backgroundColor  = .white
        
        pupulateCarData()
       // viewModel.getExtras()
//        animationView.play()
        viewModel.priceEstimationMappableResponseJson = priceEstimationMappableResponseJson
        viewModel.selectedCarObject = selectedCarObject
        viewModel.getInsurenceAndExtras()
        setupVieModel()
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.chooseStandardAction (_:)))
//        let theebinsuranceGeasture = UITapGestureRecognizer(target: self, action:  #selector (self.chooseTheebInusranceAction (_:)))
     //   standardInsuranceView.addGestureRecognizer(gesture)
     //    animationView.addGestureRecognizer(theebinsuranceGeasture)
        vatNotIncludedHintLabel.text = "fleet_mayIncrease".localized
        freeKmsLabel.text = "fleet_includeKm".localized
        accidentHelpLabel.text = "fleet_accedent".localized
        roadAssistanceLabel.text = "fleet_roadside".localized
        freeServicesLabel.text = "fleet_freeService".localized
        insuranceTitleLabel.text = "checkOutVC_insurance".localized
    }
    
    func checkStopList(){
        guard let loginObject = CachingManager.loginObject() else {return}
        viewModelSideMenu.getUserProfile(licenseNo: loginObject.licenseNo ?? "" ,mobile: loginObject.mobileNo ?? "" ,passportNo: loginObject.iDNo ?? "" ,email: loginObject.email ?? "")
//            viewModelSideMenu.getDriverMember(driverID:driverID){ memberModel in
//                CachingManager.memberDriverModel = memberModel
//            }
    }

    func handleViews(){
        let albumNib = UINib(nibName: "InsurenceCell", bundle: nil)
        insurenceTableView.register(albumNib, forCellReuseIdentifier: InsurenceCell.identifier)
        insurenceTableView.startShimmerAnimation(withIdentifier: String(describing: InsurenceCell.self), numberOfRows: 3, numberOfSections: 1)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkoutVC = CheckoutVC.initializeFromStoryboard()
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.CarDetails, screenClass: String(describing: CarDetailsVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.CarDetails, screenClass: String(describing: CarDetailsVC.self))
    }
    
//    @objc func chooseStandardAction(_ sender:UITapGestureRecognizer){
//        
//            selectStandardInsuranceBtn.isSelected = true
//            selectInsuranceBtn.isSelected = false
//         recommendedTheebInsuranceLabel.stopFlash()
//    }
//    
//    @objc func chooseTheebInusranceAction(_ sender:UITapGestureRecognizer){
//        
//       // recommendedTheebInsuranceLabel.flash()
//        selectInsuranceBtn.isSelected = true
//        selectStandardInsuranceBtn.isSelected = false
//    }
    
    // MARK: - Setup ViewModel
    
    func setupVieModel()  {
        
        viewModel.reloadTableData = { [weak self] in
                self?.selectedInsurence = self?.viewModel.insurence(atIndex: 0)
                self?.extrasTableView.reloadData()
                self?.insurenceTableView.reloadData()
                self?.insurenceTableView.stopShimmerAnimation()
                self?.applyAnimation()
                self?.extrasTableViewHeight.constant = (max(self?.extrasTableView.contentSize.height ?? 100,120)) * 1.25
                self?.view.layoutIfNeeded()
            
        }
        
        viewModel.showInsuranceName = {  [weak self] in
            DispatchQueue.main.async{//susbected crach solving
                guard let self = self else {return}
                self.insuranceprice = self.viewModel.insurancesJson.first?.amount
           //     self.insurenceTableView.reloadData()
          //      self.insurancePricelbl.text =  "\("+ ")\(String(describing: self.insuranceprice ?? ""))" +  "sar".localized
                self.loadingPlaceholderView.uncover()
        //        self.insuranceNameLbl.text = (self.isArabic ? self.viewModel.insurancesJson.first?.desc:self.viewModel.insurancesJson.first?.nameTranslated) ?? ""
            }
            
        }
        
        
    }
    
    func applyAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[weak self] in
            guard let self = self else {return}
            let cells = self.extrasTableView.visibleCells(in: 1)
            UIView.animate(views: cells, animations: [AnimationType.rotate(angle: 180), AnimationType.zoom(scale: 20)])
        }
       
    }
    
    
    
    // MARK: - intilaization
    
    class func initializeFromStoryboard() -> CarDetailsVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Fleet, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: CarDetailsVC.self)) as! CarDetailsVC
    }
    
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: CarDetailsVC.initializeFromStoryboard())
    }
    
    
    // MARK: - Poupulate Car Data
    
    func pupulateCarData() {
        
        carImageView.image = nil
        if let imageUrlString = selectedCarObject?.group,
           let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") {
            carImageView.af.setImage(withURL: imageUrl)
        }
     
        carModelNameLbl.text = selectedCarObject?.vehTypeDesc ?? ""
        seatsNumberLabel.text  = "\(String(describing: selectedCarObject?.modelNoOfPassenger  ?? "" ))" +   "car_details_seats" .localized
        transferTypeLabel.text = selectedCarObject?.modelTransmissionDesc ?? ""
        carTypeLabel.text = selectedCarObject?.vthDesc ?? ""
        numberOfBags.text = "\(String(describing:  selectedCarObject?.modelNoOfPassenger ?? ""))" +   "car_details_bags".localized
   //     insurancePricelbl.text =  "\("+ ")\(String(describing: insuranceprice ?? ""))" +  "sar".localized
        pricePerDayLabel.text = selectedCarPrice ?? ""
        
        numberOfDoorsLabel.text  = "\(String(describing:  selectedCarObject?.modelNoOfDoors ?? ""))" +  "car_details_doors".localized
        
//        if selectedCarObject?.modelGpsAvaliable == "N" {
//            gpsLabel.text = "car_details_gps_not_avaliable".localized
//        } else {
//            gpsLabel.text = "car_details_gps_avaliable".localized
//        }
        gpsLabel.text = selectedCarObject?.modelFuelDesc ?? ""
        
    }
    
    //MARK: - Inject Data
    
    func setDataToCarDetails(outBranch: Int?,
                        inBranch:Int?,
                        outDate: String?,
                        inDate:String?,
                        outTime: String?,
                        inTime: String?,
                        vehicleType : String?,
                        driverCode : String? = CachingManager.loginObject()?.driverCode) {
      
        viewModel.outBranch = outBranch
        viewModel.inBranch = inBranch
        viewModel.outDate = outDate
        viewModel.inDate = inDate
        viewModel.outTime = outTime
        viewModel.inTime = inTime
        viewModel.vehicleType = vehicleType
        
        
    }
    
    // MARK: - Actions
    
    
//    @IBAction func selectStandardInsuranceBtnAction(_ sender: Any) {
//    
//        selectStandardInsuranceBtn.isSelected = true
//        selectInsuranceBtn.isSelected = false
//
//       
//
//    }
    
    @IBAction func bookNowBtnAction(_ sender: Any) {
        
        
        if CachingManager.loginObject() == nil || CachingManager.loginObject()?.driverCode == ""  {
            
            let loginVC = LoginRegisterVC.initializeFromStoryboard()
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.loginVC.setisGuest(true)
            self.present(loginVC, animated: true, completion: nil)
            
            
        } else{
            
            
            if isFromMore ?? false {
                
                
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
            } else {

               // let selectedExtra =  viewModel.extrasJson.filter { $0.1 ==  true}
               
                
//                var inbranchValue = ""
//                var outbranchValue = ""
//
//                let optionalInBranch: Int? = viewModel.inBranch
//                if let intValue = optionalInBranch {
//                    inbranchValue = String(intValue)
//                } else {
//                    print("Optional value is nil")
//                }
//
//                let optionalOutBranch: Int? = viewModel.outBranch
//                if let intValue = optionalOutBranch {
//                    outbranchValue = String(intValue)
//                } else {
//                    print("Optional value is nil")
//                }
                guard let checkoutVC = checkoutVC else {return}
                checkoutVC.setDataToCheckout(outBranch: viewModel.outBranch, inBranch: viewModel.inBranch, outDate: viewModel.outDate, inDate: viewModel.inDate, outTime: viewModel.outTime, inTime: viewModel.inTime, vehicleType: viewModel.vehicleType, selectedCarObject: selectedCarObject)
                checkoutVC.viewModel.slectedextras = selectedExtrsForCheckout
                 checkoutVC.viewModel.insurancePrice = insuranceprice
                checkoutVC.insurancesArr = viewModel.insurancesJson
                checkoutVC.selectedInsurence = selectedInsurence
//                if selectInsuranceBtn.isSelected {
//                    checkoutVC.viewModel.slectedInsurance = viewModel.insurancesJson.first?.nameTranslated
//                    checkoutVC.viewModel.slectedInsuranceCode = viewModel.insurancesJson.last?.code
//
//                } else {
//                    checkoutVC.viewModel.slectedInsurance =   ""
//                    checkoutVC.viewModel.slectedInsuranceCode = viewModel.insurancesJson.first?.code
//               //TODO to be enhance the slectedInsuranceCode instade of last and first chosse
//                }
                
               
                checkoutVC.selectedInsurence = selectedInsurence
                self.navigationController?.pushViewController(checkoutVC, animated: true)
                self.checkoutVC = nil
            }
          
        }
        
    
    }
    
//    @IBAction func selectInsuranceBtnAction(_ sender: Any) {
//        
//      
//
//                 selectInsuranceBtn.isSelected = true
//                 recommendedTheebInsuranceLabel.flash()
//                 selectStandardInsuranceBtn.isSelected = false
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//    
//     
//    }
}
//MARK: UITableViwDataSource

extension CarDetailsVC : UITableViewDelegate {
    
    
}
//MARK: UICollectionViwDataSource

extension CarDetailsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView{
        case extrasTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExrtrasTableViewCell.self), for: indexPath) as! ExrtrasTableViewCell
            cell.selectButton.isSelected = false
            cell.showExtra(viewModel.extra(atIndex: indexPath.row))
//            cell.selectExtraButtonAction = { [weak self] in
//                self?.selectedExtra?.1.toggle()
//                if self?.selectedExtra?.1  ?? false{
//                    self?.selectedExtrsForCheckout.append(self?.selectedExtra?.0)
//                }
//                self?.viewModel.reloadTableData?()
//            }
            return cell
        case insurenceTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InsurenceCell.self), for: indexPath) as! InsurenceCell
            let insurence = viewModel.insurence(atIndex: indexPath.item)
            cell.selectionStyle = .none
            cell.setupCell(insurence: insurence, isRecomend: insurence.code == "SCDW", isSelect: insurence == selectedInsurence)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == extrasTableView ? (viewModel.numberOfExtras() ?? 0):(viewModel.numberOfInsurence() ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == insurenceTableView{
            let insurenceCode = viewModel.insurence(atIndex: indexPath.item).code
            let viewHeight = view.frame.height
            return insurenceCode == "SCDW" ? viewHeight/9 : viewHeight/13
        }
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.extrasTableView {
            
             var selectedExtra = viewModel.extra(atIndex: indexPath.row)
            selectedExtra.1.toggle()
            if selectedExtra.1 {
                if !selectedExtrsForCheckout.contains(selectedExtra.0){
                    self.selectedExtrsForCheckout.append(selectedExtra.0)
                }
            } else {
                if let idx = selectedExtrsForCheckout.firstIndex(where: { $0 == selectedExtra.0 }) {
                    selectedExtrsForCheckout.remove(at: idx)
                }
            }
            viewModel.replaceExtras(selectedExtra)
            extrasTableView.reloadData()

        }else{
            guard let checkoutVC = checkoutVC else {return}
            selectedInsurence = viewModel.insurence(atIndex: indexPath.row)
            insurenceTableView.deselectRow(at: indexPath, animated: false)
            insurenceTableView.reloadData()
        }
        
    }
    
    
}

extension CarDetailsVC{
    func bindUserPorfile(){
        
        viewModelSideMenu.userProfile.listen(on: { value in
            guard let profileData = value?.driverProfile else {return}
            DispatchQueue.main.async {
                CachingManager.memberDriverModel = profileData
            }
            
        })
    }
}
