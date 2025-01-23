//
//  CheckoutVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 28/07/1443 AH.
//

import UIKit
import AlamofireImage
import FlagPhoneNumber
import JVFloatLabeledTextField



class CheckoutVC : BaseViewController {
  

   
    @IBOutlet var insuranceView: UIView!
    @IBOutlet weak var editBrn: UIButton! {
        didSet {
            editBrn.setTitle("checkout_editbtn_title".localized, for: .normal)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var insurenceLblView: UIView!
    @IBOutlet weak var addonsLblView: UIView!
    @IBOutlet weak var removeadditionBtn: UIButton! {
        didSet {
            removeadditionBtn.setTitle("car_details_remove_btn".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var upgradeInsuranceBtn: UIButton! {
        didSet {
            upgradeInsuranceBtn.setTitle("checkout_upgrade_btn_title".localized, for: .normal)
        }
    }


    @IBOutlet weak var viewHeightCondtranits: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
//    {
//        didSet {
//            containerStackView.isHidden = true
//        }
//    }
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addonsView: UIView!
    @IBOutlet weak var extraReturningHoursLbl: UILabel! {
        didSet {
            extraReturningHoursLbl.text = MemberUtility.instance.freeHours
        }
    }
    @IBOutlet weak var returnBranchLabel: UILabel! {
        didSet {
            //guard   let returnBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == viewModel.outBranch}).first as? BranchModel else {return}
            guard   let returnBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == viewModel.inBranch}).first as? Branch else {return}
            returnBranchLabel?.text = isArabic ? returnBranchObject.branchName:returnBranchObject.branchNameTranslated
         
        }
    }
    @IBOutlet weak var returnDateTimeLabel: UILabel! {
        didSet {
             
        }
    }
    @IBOutlet weak var freeKilosTitleLabel: UILabel!
    @IBOutlet weak var membershipDiscountLbl: UILabel!
    @IBOutlet weak var bookNowBtn: LoadingButton!  {
        didSet {
          
        }
    }
    @IBOutlet weak var conformationForDataLabel: UILabel!
    @IBOutlet weak var confirmInfoBtn: UIButton!
    @IBOutlet weak var canCancelBookingBeforreConfirmationlabel: UILabel!
    @IBOutlet weak var cancelPolicyTitleLabel: UILabel!{
        didSet{
            cancelPolicyTitleLabel.text = "fleet_confirmavaiabilty".localized
        }
    }
    @IBOutlet weak var proccedToPaymentHintLabel: UILabel!{
        didSet{
            proccedToPaymentHintLabel.text = "rental_cancelPolcy".localized
            //"fleet_confirmavaiabilty"
        }
    }
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var totalHintLbl: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var vatValueLabel: UILabel!
    @IBOutlet weak var vatHintLabel: UILabel!
    @IBOutlet weak var membershipDiscountValueLabel: UILabel!
    @IBOutlet weak var addonsValueLbl: UILabel!
    @IBOutlet weak var addonsHintLbl: UILabel!
    @IBOutlet weak var insuranceValueLabel: UILabel!
    @IBOutlet weak var insuranceHintLabel: UILabel!
    @IBOutlet weak var deliveryFessValueLabel: UILabel!
    @IBOutlet weak var deliveryFeesHintLabel: UILabel!
    @IBOutlet weak var carRentalValueLabel: UILabel!
    @IBOutlet weak var carRentaValueLabel: UILabel!
    @IBOutlet weak var numbefofPointHintLabel: UILabel!
    @IBOutlet weak var totalFreeValueLabel: UILabel!{
        didSet{
          //  totalFreeValueLabel.text = MemberUtility.instance.getSumKmString(str1: "225", str2: CachingManager.memberDriverModel?.membership.freeKm ?? "0")
            totalFreeValueLabel.text = MemberUtility.instance.getSumKmString(str1: "225", str2: CachingManager.memberDriverModel?.membership?.freeKM ?? "0")
        }
    }
    @IBOutlet weak var totalFreeHintLabel: UILabel! {
        didSet {
            totalFreeHintLabel.text = "chekout_total_free".localized
        }
    }

    @IBOutlet weak var membershipTypeLabel: UILabel!
    @IBOutlet weak var memberShipValueLabel: UILabel!{
        didSet {
            memberShipValueLabel.text = MemberUtility.instance.freeKiloMeters
        }
    }
    @IBOutlet weak var defaultKmsValueLabel: UILabel!{
        didSet{
            defaultKmsValueLabel.text = "\("225") \("km_hint".localized)"
        }
    }
    @IBOutlet weak var defaultKmsHintLabel: UILabel!
    @IBOutlet weak var addOnsTitleLabel: UILabel!
    @IBOutlet weak var addonsNameLabel: UILabel!
    @IBOutlet weak var insuranceNameLabel: UILabel!
    @IBOutlet var txtFieldArr: [UITextField]!
    @IBOutlet weak var txtFieldName: JVFloatLabeledTextField!
    @IBOutlet weak var txtFieldPhone: JVFloatLabeledTextField!
    @IBOutlet weak var txtFieldFlag: FPNTextField!
    
    @IBOutlet weak var txtFieldDateBirsth: JVFloatLabeledTextField!
    @IBOutlet weak var txtFieldEmail: JVFloatLabeledTextField!
    @IBOutlet weak var insuranceTitleLabel: UILabel!
    @IBOutlet weak var extraFeesLbl: UILabel!
    @IBOutlet weak var pickupDateTimeLabel: UILabel!
    @IBOutlet weak var driverStaticLAbel: UILabel!{
        didSet{
            driverStaticLAbel.text = "fleet_DriverInfo".localized
        }
    }
    @IBOutlet weak var pickupBranchLabel: UILabel! {
        didSet {
           // guard   let returnBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == viewModel.inBranch}).first else {return}
            guard   let returnBranchObject =  CachingManager.locations()?.filter({ $0?.branchCode == viewModel.outBranch}).first else {return}
            pickupBranchLabel?.text = isArabic ? returnBranchObject?.branchName:returnBranchObject?.branchNameTranslated
            
        }
    }
    @IBOutlet weak var transmisstionTypeLbl: UILabel!
    @IBOutlet weak var moreFeaturesLbl: UILabel! {
        didSet {
            moreFeaturesLbl.text = "chekout_plus_more".localized
        }
    }
    @IBOutlet weak var numberofSeatsLbl: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView! {
        didSet {
            carImageView.image = nil
            if let imageUrlString =  viewModel.selectedCarObject?.group,
                let imageUrl = URL(string: NetworkConfigration.imageURL + imageUrlString + ".jpg") {
                carImageView.af.setImage(withURL: imageUrl)
            }
        }
    }
    @IBOutlet weak var categoryLbl: UILabel! {
        didSet {
            categoryLbl.text = viewModel.selectedCarObject?.vthDesc
        }
    }
    @IBOutlet weak var stackViewMember: UIStackView!
    @IBOutlet weak var memberView: UIView!
    
    @IBOutlet weak var stackViewDetails: UIStackView!
    // MARK: - Variabels
    let isArabic = UIApplication.isRTL()
    lazy var viewModel = CheckOutViewModel()
    var upgradeParentView:UIView?
    var upgradePArentHeightConstraint: NSLayoutConstraint!
    var upgradeVC: UpgradeInsurenceVC?
    var loadingPlaceholderView = LoadingPlaceholderView()
    var insurancesArr = [InsType]()
    var selectedInsurence:InsType?{
        didSet{
            viewModel.slectedInsurance = isArabic ? selectedInsurence?.desc:selectedInsurence?.nameTranslated
            viewModel.slectedInsuranceCode = selectedInsurence?.code
        }
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoader()

       // handleViews()
        title = "checkout_vc_title".localized
        fetchPriceEstimationData()
        setupViewModel()
        handleProfileView()
//      startShimmerAnimation()

    }
    
    func setupLoader(){
        loadingPlaceholderView.gradientColor = .weemGrayBorder
        loadingPlaceholderView.backgroundColor = .weemLightGray
        ShimmerOptions.instance.backgroundColor = UIColor.weemLightGray
        ShimmerOptions.instance.gradientColor = UIColor.weemGrayBorder
        ShimmerOptions.instance.animationAutoReserse = false
        ShimmerOptions.instance.animationType = .classic
      //  startShimmerAnimation()
        loadingPlaceholderView.cover(stackViewDetails)
        showORHideBtn(true)
        [insuranceNameLabel,addonsNameLabel,carTypeLabel].forEach{
           // loadingPlaceholderView.cover($0)
            $0.startShimmerAnimation()
        }

    }
    
    func showORHideBtn(_ isHide:Bool){
        [upgradeInsuranceBtn,removeadditionBtn].forEach{
            $0?.isHidden = isHide
        }
    }
    
    func formTermsAndCondition(){
        let mainAttibutedString = NSMutableAttributedString(string: "checkOutVC_commitInfo".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)])
        let termsAttributedstring = NSMutableAttributedString(string: "checkOutVC_TermsAndCond".localized, attributes: [NSAttributedString.Key.foregroundColor : UIColor.theebColor, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)])
        
        conformationForDataLabel.attributedText = mainAttibutedString + termsAttributedstring
        
        let gestureView = UIView()
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gestureView)
        NSLayoutConstraint.activate([
            gestureView.trailingAnchor.constraint(equalTo: conformationForDataLabel.trailingAnchor),
            gestureView.leadingAnchor.constraint(equalTo: conformationForDataLabel.leadingAnchor),
            gestureView.bottomAnchor.constraint(equalTo: conformationForDataLabel.bottomAnchor),
            gestureView.topAnchor.constraint(equalTo: conformationForDataLabel.topAnchor)
        ])
        view.bringSubviewToFront(gestureView)
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsGestureTapped)))
    }
    
    @objc func termsGestureTapped(){
        addFadeBackground(true, color: .darkGray)
        title = ""
        let imagePopupView = TextViewPopUp()
     //   imagePopupView.txtView.text = "termsAndCondidtions_Arabic".localized
        imagePopupView.clipsToBounds = true
        imagePopupView.layer.cornerRadius = 12
        imagePopupView.delegate = self
        imagePopupView.tag = 123
        imagePopupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePopupView)
        NSLayoutConstraint.activate([
            imagePopupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagePopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imagePopupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            imagePopupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        imagePopupView.scaleAnimate()
       view.bringSubviewToFront(imagePopupView)
    }
    
    //MARK: - Setup View Model
    
    func handleViews(){
        returnDateTimeLabel.text =  "\("checkout_Return_on".localized) \(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.inDate ?? "")  \( "checkout_at".localized)\(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.inTime ?? "")"
        pickupDateTimeLabel.text =  "\(  "checkout_pickup_on".localized) \(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.outDate ?? "")  \("checkout_at".localized)\(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.outTime ?? "")"
        carTypeLabel.text = "\(viewModel.selectedCarObject?.vehTypeDesc ?? "")"
        numberofSeatsLbl.text =  "\(viewModel.selectedCarObject?.modelNoOfPassenger ?? "")\(" ")\("car_details_seats".localized)"
        transmisstionTypeLbl.text = "\(viewModel.selectedCarObject?.modelTransmissionDesc ?? "")"
        if selectedInsurence?.code  == "" {
          
            insuranceNameLabel.text =  "standard_insurance".localized
        } else  {
            // insuranceNameLabel.text = viewModel.slectedInsurance
            if selectedInsurence?.code?.lowercased() == "cdw" {
                insuranceNameLabel.text =  UIApplication.isRTL() ? "التأمين الجزئي": "Partial Insurance"
            } else if selectedInsurence?.code?.lowercased() == "scdw" {
                insuranceNameLabel.text =  UIApplication.isRTL() ? "تأمين ذيب الاضافي": "THEEB Insurance"
            }
            insuranceNameLabel.textColor = .theebPrimaryColor
            upgradeInsuranceBtn.isHidden = true
        }
       
        if viewModel.slectedextras.count > 0 {
            
            addonsNameLabel.text = isArabic ? viewModel.slectedextras[0]?.nameTranslated ?? "":viewModel.slectedextras[0]?.nameTranslated ?? ""
        } else {
            
            containerStackView.removeInputView(view: addonsView)
            viewHeightCondtranits.constant = 1400
        }
    }
    func setupViewModel() {
        
        viewModel.pushViewController = { [weak self] (vc) in
            
            self?.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        
        viewModel.fillPriceEstimationViewJson = { [weak self] (carmodel) in
            
            let total =  Double(carmodel?.rentalSum ?? "") ?? 0
            let discount = Double(carmodel?.discountAmount ?? "") ?? 0
            let response = self?.viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price
            let rentalSum = String(format: "%.2f", (total + discount))//to add discount instade of delivery
           // let rentalSum = String(format: "%.2f", total)
            self?.carRentalValueLabel.text = "\(rentalSum)\(" ") \(response?.currency ?? "")"
            print(carmodel?.dropOffSum,carmodel?.extrasSum,carmodel?.insuranceSum)
            self?.deliveryFessValueLabel.text  = "\(carmodel?.dropOffSum ?? "" )\(" ") \(response?.currency ?? "")"
            self?.addonsValueLbl.text =  "\(carmodel?.extrasSum ?? "")\(" ") \(response?.currency ?? "")"
            if self?.selectedInsurence?.code == ""  {
                self?.insuranceValueLabel.text = "\( "0.0")\(" ") \(response?.currency ?? "")"
            } else {
                
                self?.insuranceValueLabel.text = "\(carmodel?.insuranceSum ?? "")\(" ") \(response?.currency ?? "")"
            }

//            self?.returnDateTimeLabel.text =  "\("checkout_Return_on".localized) \(response?.inDate ?? "")  \( "checkout_at".localized)\(response?.inTime ?? "")"
//            self?.pickupDateTimeLabel.text =  "\(  "checkout_pickup_on".localized) \(response?.outDate ?? "")  \("checkout_at".localized)\(response?.outTime ?? "")"

            self?.returnDateTimeLabel.text =  "\("checkout_Return_on".localized) \(self?.viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.inDate ?? "")  \( "checkout_at".localized)\(self?.viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.inTime ?? "")"
            self?.pickupDateTimeLabel.text =  "\(  "checkout_pickup_on".localized) \(self?.viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.outDate ?? "")  \("checkout_at".localized)\(self?.viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.outTime ?? "")"
            
     //       insuranceValueLabel.text = "\(carmodel?.insuranceSum ?? "")\(" ") \(viewModel.priceEstimationMappableResponse?.priceResponseModel.currency ?? "")"
          


            if self?.viewModel.slectedInsurance == "" {
                self?.totalValueLabel.text  = "\(carmodel?.totalAmount ?? "")\(" ") \(response?.currency ?? "")"
            } else {
                self?.totalValueLabel.text  = "\(carmodel?.totalAmount ?? "")\(" ") \(response?.currency ?? "")"
            }
            self?.membershipDiscountValueLabel.text = "- \(carmodel?.discountAmount ?? "")\(" ") \(response?.currency ?? "")"
            self?.vatValueLabel.text = "\(carmodel?.vATAmount ?? "")\(" ") \(response?.currency ?? "")"
            
           
        }
        
        viewModel.showLoading = {  [weak self] in
            
            self?.bookNowBtn.showLoading()
        }
        
        viewModel.hideLoadding = {  [weak self] in
            
            self?.bookNowBtn.hideLoading()
        }
        
        viewModel.showContentView = {  [weak self] in
            DispatchQueue.main.async{
            self?.handleViews()
            self?.showORHideBtn(false)
            self?.containerStackView.isHidden = false
            self?.stopShimmerAnimation()
            self?.loadingPlaceholderView.uncover()
            }
        }
     
        viewModel.presentViewController = { [weak self] (vc) in
          
            self?.present(vc, animated: true, completion: nil)
        }
        
        
    }

    func handleProfileView() {
        if  let loginObject = CachingManager.loginObject(){
            carRentaValueLabel.text = "rental_carRental".localized
            totalHintLbl.text = "rental_totalValue".localized
            vatHintLabel.text = "rental_vatValue".localized
            insuranceHintLabel.text = "checkOutVC_insurance".localized
            addonsHintLbl.text = "checkOutVC_addOns".localized
            deliveryFeesHintLabel.text = "renta_Delivery".localized
            membershipDiscountLbl.text = "rental_memberShipDeiscount".localized
            extraFeesLbl.text = "checkOut_extraFeesWillApplied".localized
         
            defaultKmsHintLabel.text = "checkOut_default".localized
            MemberUtility.instance.setMemberLabel(lbl: membershipTypeLabel)
//            {
//                DispatchQueue.main.async {
//                    self.stackViewMember.removeInputView(view: self.memberView)
//                }
//            }
            totalHintLbl.text = "rental_totalValue".localized
            txtFieldName.text = " \(loginObject.firstName ?? "") \(loginObject.lastName ?? "")"
            txtFieldDateBirsth.text = loginObject.dateOfBirth
            txtFieldPhone.placeholder = "sign_up_phone_number_placeholder".localized
            txtFieldName.placeholder = "sign_up_full_name_placeholder".localized
            txtFieldDateBirsth.placeholder = "profile_Edit_birthdate".localized
           // lblStaticEmail.text = "checkOutVC_email".localized
            txtFieldEmail.placeholder = "checkOutVC_email".localized
            txtFieldFlag.setFlag(countryCode: FPNCountryCode.SA)
            txtFieldFlag.text = " "
            txtFieldFlag.font = UIFont.BahijTheSansArabicPlain(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)
            txtFieldPhone.text = loginObject.mobileNo
            txtFieldEmail.text = loginObject.email
            txtFieldArr.forEach{
                $0.layer.cornerRadius = 4
                $0.layer.borderWidth = 0.5
                $0.layer.borderColor = #colorLiteral(red: 0.6060602069, green: 0.6160138249, blue: 0.6244431138, alpha: 1)
                if let txtField = $0 as? JVFloatLabeledTextField{
                    txtField.floatingLabelYPadding = 4
                    txtField.contentVerticalAlignment = .bottom
                }
            }
            insuranceTitleLabel.text = "checkOutVC_insurance".localized
            addOnsTitleLabel.text = "checkOutVC_addOns".localized
            freeKilosTitleLabel.text = "checkOutVC_freeKilos".localized
            canCancelBookingBeforreConfirmationlabel.text = "checkOutVC_canCancel".localized
           // conformationForDataLabel.text = "checkOutVC_commitInfo".localized
            formTermsAndCondition()
            bookNowBtn.setTitle("checkOutVC_bookow".localized, for: .normal)
        }else{
            presentLoginVcForRecache()
           // containerStackView.removeInputView(view: profileView)
        }
    }
    
    //MARK: - Inject Data
    
    func setDataToCheckout(outBranch: Int?,
                        inBranch:Int?,
                        outDate: String?,
                        inDate:String?,
                        outTime: String?,
                        inTime: String?,
                        vehicleType : String?,
                        selectedCarObject :CarGroup?,
                        driverCode : String? = CachingManager.loginObject()?.driverCode) {
      
        viewModel.outBranch = outBranch
        viewModel.inBranch = inBranch
        viewModel.outDate = outDate
        viewModel.inDate = inDate
//        viewModel.outTime = outTime24
//        viewModel.inTime = inTime24
        viewModel.outTime = DateUtils.convertPmTo24(time: outTime ?? "")
        viewModel.inTime = DateUtils.convertPmTo24(time: inTime ?? "")
        
        if isBeforeCurrentDateTime(dateString: outDate ?? "", timeString:  viewModel.outTime ?? "") {
            let updatedText = replaceAMWithPM(text:  outTime ?? "")
            viewModel.outTime = DateUtils.convertPmTo24(time: updatedText)
        }
       
        viewModel.vehicleType = vehicleType
        viewModel.selectedCarObject  = selectedCarObject
        
    }
    
    func replaceAMWithPM(text: String) -> String {
        var updatedText = text
        updatedText = updatedText.replacingOccurrences(of: "AM", with: "PM")
        updatedText = updatedText.replacingOccurrences(of: "ص", with: "م")
        return updatedText
    }

    
    func isBeforeCurrentDateTime(dateString: String, timeString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let combinedDateTime = dateFormatter.date(from: "\(dateString) \(timeString)") else {
            // Date parsing failed
            return false
        }
        
        // Get current date and time
        let currentDate = Date()
        
        // Compare dates
        return combinedDateTime < currentDate
    }

//    // Usage:
//    let outDate = "02/01/2024"
//    let outTime = "8:00 AM"
//
//    let isBeforeCurrent = isBeforeCurrentDateTime(dateString: outDate, timeString: outTime)
//    print("Is before current date and time: \(isBeforeCurrent)")

    func fetchPriceEstimationData() {
        var insuranceQuantity = String()
        var insuranceCode = String()
        var insuranceName = String()
        if  selectedInsurence?.code == "" {
            insuranceQuantity = " "
            insuranceCode  = " "
            insuranceName = ""
        } else {
            insuranceQuantity = "1"
            insuranceCode =   selectedInsurence?.code ?? ""
            insuranceName = selectedInsurence?.desc ?? ""
        }
        var inbranchValue = ""
        var outbranchValue = ""
        

        let optionalInBranch: Int? = viewModel.inBranch
        if let intValue = optionalInBranch {
            inbranchValue = String(intValue)
        } else {
            print("Optional value is nil")
        }
        
        let optionalOutBranch: Int? = viewModel.outBranch
        if let intValue = optionalOutBranch {
            outbranchValue = String(intValue)
        } else {
            print("Optional value is nil")
        }
        
        let extrasArr = convertExtras(viewModel.slectedextras)
        print(extrasArr)
        viewModel.usePriceEstimation(isCustomLoader: false, outBranch: String(viewModel.outBranch ?? 0), inBranch: String(viewModel.inBranch ?? 0), outDate: viewModel.outDate, inDate: viewModel.inDate, outTime: viewModel.outTime, inTime: viewModel.inTime, vehicleType: viewModel.vehicleType, driverCode: CachingManager.loginObject()?.driverCode ?? "", carGroup: viewModel.selectedCarObject?.group  ?? "", selectedInsurance: insuranceName, insuranceCode:insuranceCode , InsuranceQuantitiy:insuranceQuantity, extras: extrasArr )

    }
    
    func convertExtras(_ selectedExtras:[ExtType?])->[ExtrasInsurenceData]{
        var extrasArr = [ExtrasInsurenceData]()
        selectedExtras.forEach {
            let extras = ExtrasInsurenceData(code: $0?.code ?? "", name: $0?.desc ?? "", quantity: "1")
            extrasArr.append(extras)
        }
        return extrasArr
    }
    
    // MARK: - intilaization
    
    class func initializeFromStoryboard() -> CheckoutVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Checkout, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: CheckoutVC.self)) as! CheckoutVC
    }
    
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: CheckoutVC.initializeFromStoryboard())
    }
    
    private func alertUser(title:String = "login_error".localized,msg:String){
        CustomAlertController.initialization().showAlertWithOkButton(title:title,message: msg) { (index, title) in
            print(index,title)
       }
    }
    
    // MARK: - Actions
    
    @IBAction func removeAdditionAction(_ sender: Any) {
   
        viewModel.slectedextras = []
        fetchPriceEstimationData()
        setupLoader()
        containerStackView.removeInputView(view: addonsView)
        viewHeightCondtranits.constant = 1400
    
    }
    
    
    @IBAction func confirmBtnActoin(_ sender: Any) {
    
        confirmInfoBtn.isSelected = !confirmInfoBtn.isSelected
       
        if confirmInfoBtn.isSelected {
            bookNowBtn.dimmed = false
      
        } else {
            bookNowBtn.dimmed = true
      
        }
       // confirmInfoBtn.isSelected  = !bookNowBtn.dimmed
 
        
    }
    
    func presentLoginVcForRecache(){
        CachingManager.removeValue(forKey: CachingKeys.LoggedInUserData)
        let loginVC = LoginRegisterVC.initializeFromStoryboard()
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.loginVC.setisGuest(true)
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func bookNowBtnAction(_ sender: Any) {
        if let loginObject = CachingManager.memberDriverModel{
            if loginObject.stopList == "Y" {
                alertUser(msg: "checkOut_blackList".localized)
                return
            }
        }
        
        let selectedGroup = viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.carGroupPrice?.filter({ $0.carGrop == viewModel.selectedCarObject?.group}).first
        
        var insuranceQuantity = String()
        var insuranceCode = String()
        var insurenceArr = [ExtrasInsurenceData]()
        if  viewModel.slectedInsurance == "" {
            insuranceQuantity = " "
            insuranceCode  = " "
        } else {
            let insurenceData = ExtrasInsurenceData(code:  viewModel.slectedInsuranceCode ?? "", name: "THEEB insurence", quantity: "1")
            insurenceArr.append(insurenceData)
            insuranceQuantity = "1"
            insuranceCode =   viewModel.slectedInsuranceCode ?? ""
        }
        let extrasArr = convertExtras(viewModel.slectedextras)
     let reservationCode = "\(Int(arc4random_uniform(999999999)))"

        
        var inbranchValue = ""
        var outbranchValue = ""
        
        let optionalInBranch: Int? = viewModel.inBranch
        if let intValue = optionalInBranch {
            inbranchValue = String(intValue)
        } else {
            print("Optional value is nil")
        }
        
        let optionalOutBranch: Int? = viewModel.outBranch
        if let intValue = optionalOutBranch {
            outbranchValue = String(intValue)
        } else {
            print("Optional value is nil")
        }
        
        if CachingManager.loginObject() == nil || CachingManager.loginObject()?.driverCode == "" || CachingManager.loginObject()?.firstName?.isEmpty ?? true || CachingManager.loginObject()?.licenseNo?.isEmpty ?? true{
            presentLoginVcForRecache()
            return
        }
        
        viewModel.createReservationJson(firstName: CachingManager.loginObject()?.firstName ?? "", lastName:  CachingManager.loginObject()?.lastName ?? "", reservationCode: reservationCode, outBranch: viewModel.outBranch ?? 0, inBranch: viewModel.inBranch ?? 0, outDate: viewModel.outDate ?? "", inDate: viewModel.inDate ?? "", outTime: viewModel.outTime ?? "", inTime: viewModel.inTime ?? "", driverCode: CachingManager.loginObject()?.driverCode ?? "", driverLicenseNumber: CachingManager.loginObject()?.licenseNo ?? "", cdp: viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.cDP ?? "",
            rateNo:selectedGroup?.rateNo ?? "",resevationNumber: reservationCode,
            rentalSum: viewModel.priceEstimatGroupModelJson?.rentalSum ?? "",
            carGroup: viewModel.selectedCarObject?.group ?? "",
            insurance:insurenceArr, extras: extrasArr)
    }
    
    func appearView() {
         self.insuranceView.alpha = 0
         self.insuranceView.isHidden = false

         UIView.animate(withDuration: 0.9, animations: {
             self.insuranceView.alpha = 1
         }, completion: {
             finished in
             self.insuranceView.isHidden = false
         })
    }
    
    
    @IBAction func upgradeInsuranceandRemoveExtrasAndEditExtraBtnsActions(_ sender: Any) {
        //appearView()
        addFadeBackground(true, color: .darkGray)
        let tuple = constructTimeView(onView: view, val: 0.5)//val is the percentage height of the view
        upgradeParentView = tuple.0
        upgradePArentHeightConstraint = tuple.1
        upgradeVC = UpgradeInsurenceVC.initializeFromStoryboard()
        upgradeVC?.insurancesArr = insurancesArr
        upgradeVC?.selectedInsurence = selectedInsurence
        upgradeVC?.delegate = self
        addChildViewController(upgradeVC, onView: upgradeParentView!)
        animateConstraint(constraint: upgradePArentHeightConstraint, to: 8)

    }
    
}


extension CheckoutVC:UpgradeInsurenceDelegate {
//    func getAction(_ selectedInsurance: String?, insurancCode: String?) {
//      
//        viewModel.slectedInsurance = selectedInsurance
//        viewModel.slectedInsuranceCode = insurancCode
//    }

    func upgradeBtnAction(_ selectedInsurance: String?, insurancCode: String?, selectedInsuranceObject: InsType?) {
        viewModel.slectedInsurance = selectedInsurance
        viewModel.slectedInsuranceCode = insurancCode
        selectedInsurence = selectedInsuranceObject
        if selectedInsurence?.code == "" {
          
            insuranceNameLabel.text =  "standard_insurance".localized
           totalValueLabel.text  = "\(viewModel.priceEstimatGroupModelJson?.totalAmount  ?? "")\(" ") \(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.currency ?? "")"
           insuranceValueLabel.text = "\( "0.0")\(" ") \(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.currency ?? "")"
        } else  {
            viewModel.slectedInsurance = selectedInsurance
            if selectedInsurence?.code?.lowercased() == "cdw" {
                insuranceNameLabel.text =  UIApplication.isRTL() ? "التأمين الجزئي": "Partial Insurance"
            } else if selectedInsurence?.code?.lowercased() == "scdw" {
                insuranceNameLabel.text =  UIApplication.isRTL() ? "تأمين ذيب الاضافي": "THEEB Insurance"
            }
            insuranceNameLabel.textColor = .theebPrimaryColor
            upgradeInsuranceBtn.isHidden = true
            self.insuranceValueLabel.text = "\(self.selectedInsurence?.amount ?? "")\(" ") \(viewModel.priceEstimationMappableResponseJson?.estimationDetails?.price?.currency ?? "")"
            
        //    insuranceValueLabel.text = "\(viewModel.priceEstimationMappableResponse?.priceResponseModel.insuranceModel.insuranceAmount ?? "")\(" ") \(viewModel.priceEstimationMappableResponse?.priceResponseModel.currency ?? "")"
            fetchPriceEstimationData()
            setupLoader()
//            totalValueLabel.text  = "\(viewModel.priceEstimatGroupModel?.totalAmount ?? "")\(" ") \(viewModel.priceEstimationMappableResponse?.priceResponseModel.currency ?? "")"
           
            
        }
        
        btnClosePressed()
    }
    
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.Checkout, screenClass: String(describing: CheckoutVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.Checkout, screenClass: String(describing: CheckoutVC.self))
    }
    
    func btnClosePressed() {
        if let upgradeVC = upgradeVC{
            addFadeBackground(false, color: nil)
            removeChildVC(mainVc: upgradeVC)
            upgradeParentView?.removeFromSuperview()
        }
    }
    
   
    
    
}

extension CheckoutVC:ImagePopUpViewDelegate{
    func btnCloseDelegatePressed(){
       addFadeBackground(false, color: nil)
        title = "checkout_vc_title".localized
        for subview in view.subviews {
            if subview.tag == 123 {
                UIView.animate(withDuration: 0.4, animations: {
                    subview.alpha = 0.0
                }) { (finish) in
                     subview.removeFromSuperview()
                }
            }
        }
    }

}
