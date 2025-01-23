//
//  UserProfileVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/06/1443 AH.
//
import UIKit
import FlagPhoneNumber
import SkyFloatingLabelTextField
import Fastis
import JVFloatLabeledTextField
import XMLMapper


class UserProfileVC: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var viewSubmit: UIView!
    @IBOutlet weak var btnSubmit: ButtonRounded!
    @IBOutlet weak var mainstackView: UIStackView!
    @IBOutlet var memberShipViews: [UIView]!
    @IBOutlet weak var flgTextField: FPNTextField!
    @IBOutlet weak var btnArrowReset: UIButton!
    @IBOutlet weak var lblStaticDriver: UILabel!
    @IBOutlet weak var lblStaticJobId: UILabel!
    @IBOutlet weak var lblStaticID: UILabel!
    @IBOutlet weak var lblStaticLicence: UILabel!
    @IBOutlet weak var lblStaticweNeed: UILabel!
    @IBOutlet weak var lblStaticUpdateDoc: UILabel!
    @IBOutlet weak var lblStaticPassword: UILabel!
    @IBOutlet weak var lblStaticEmail: UILabel!
    @IBOutlet weak var lblStaticDate: UILabel!
    @IBOutlet weak var lblStaticPhone: UILabel!
    @IBOutlet weak var lblStaticFullName: UILabel!
    @IBOutlet weak var txtFieldJobID: JVFloatLabeledTextField!
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    @IBOutlet var viewsArr: [UIView]!
    @IBOutlet weak var txtFieldAddress2: JVFloatLabeledTextField!
    @IBOutlet weak var txtFieldAddress1: JVFloatLabeledTextField!
    @IBOutlet weak var lblStaticAddresses: UILabel!
    @IBOutlet weak var lblStaticGender: UILabel!
    @IBOutlet weak var segmentedGender: UISegmentedControl!
    @IBOutlet weak var txtExpityDate: JVFloatLabeledTextField!
    @IBOutlet weak var txtLicenseNumber: JVFloatLabeledTextField!
    @IBOutlet weak var txtIDVersion: JVFloatLabeledTextField!
    @IBOutlet weak var txtIDNumber: JVFloatLabeledTextField!
    @IBOutlet weak var txtNationality: DropDown!
    
    @IBOutlet weak var txtFieldEmail: JVFloatLabeledTextField!
    @IBOutlet var txtFieldArr: [UITextField]!
    @IBOutlet weak var btnResetPassword: UIButton!
    @IBOutlet weak var txtFieledID: JVFloatLabeledTextField!
    @IBOutlet weak var txtFieldBirhday: JVFloatLabeledTextField! {
        didSet {
            txtFieldBirhday.isEnabled = true
        }
    }
    @IBOutlet weak var txtFieldLicence: JVFloatLabeledTextField!
    @IBOutlet weak var txtFieldMobile: JVFloatLabeledTextField! //FPNTextField
    @IBOutlet weak var txtFieldFirstName: JVFloatLabeledTextField!
    @IBOutlet var hiddenViewsArr: [UIView]!
    
    //MARK: - vars
    let loginIamViewModel = LoginWithIAmViewModel()
    let viewModel = UserProfileViewModel()
    let imagePickerController  =  UIImagePickerController()
    var imgStringId:(String?,String?)?
    var imgStringJobId:(String?,String?)?
    var imgStringLicence:(String?,String?)?
    var imgStringProfile:(String?,String?)?
    var tagBtn = 0
    var isFromMemberShip = false
    var birthdayString = ""
    var driverProfileRS : DriverProfile?{
        didSet{
            enableORDiabletxtFields()
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fillData()
        bindUserPorfile()
        bindYaqeenValidation()
    }
    
    //MARK: - Initialization
    
    func setupViews(){
        title = "profile_btn_edit_title".localized
      //  lblStaticPhone.text = "sign_up_phone_number_placeholder".localized
        txtFieldMobile.placeholder = "sign_up_phone_number_placeholder".localized
       // lblStaticFullName.text = "sign_up_full_name_placeholder".localized
        txtFieldFirstName.placeholder = "sign_up_full_name_placeholder".localized
       // lblStaticID.text = "profile_Edit_ID".localized
        txtFieledID.placeholder =  "profile_Edit_ID".localized
      //  lblStaticDate.text = "profile_Edit_birthdate".localized
        txtFieldBirhday.placeholder = "profile_Edit_birthdate".localized
        txtFieldBirhday.setInputViewDatePicker(target: self, selector: #selector(datePickerChanged))
        txtExpityDate.setInputViewDatePicker(target: self, selector: #selector(expirtyDatePickerChanged))
       // lblStaticEmail.text = "checkOutVC_email".localized
        txtFieldEmail.placeholder = "checkOutVC_email".localized
        lblStaticweNeed.text = "profile_WeNeedVerify".localized
        lblStaticPassword.text = "login_password_place_holder".localized
        lblStaticUpdateDoc.text = "profile_updateDoc".localized
        btnResetPassword.setTitle("forget_password_title_label".localized, for: .normal)
       // lblStaticLicence.text = "profile_licence".localized
        txtFieldLicence.placeholder = "profile_licence".localized
      //  lblStaticJobId.text = "profile_jobLicence".localized
        txtFieldJobID.placeholder = "profile_jobLicence".localized
        lblStaticDriver.text = "fleet_DriverInfo".localized
        segmentedGender.setTitle("profile_Male".localized, forSegmentAt: 0)
        segmentedGender.setTitle("profile_Female".localized, forSegmentAt: 1)
        handleNAtionality()
        txtIDNumber.placeholder = "profile_idNumber".localized
        txtIDVersion.placeholder = "profile_idVersion".localized
        txtLicenseNumber.placeholder = "profile_licenseNumber".localized
        txtExpityDate.placeholder = "profile_licenseExpiryDate".localized
        lblStaticGender.text = "profile_gender".localized
        lblStaticAddresses.text = "profile_addresses".localized
        txtFieldAddress1.placeholder = "profile_addresse1".localized
        txtFieldAddress2.placeholder = "profile_addresse2Optional".localized
        segmentedGender.addTarget(self, action: #selector(segemnetdChange(_:)), for: .valueChanged)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.theebPrimaryColor]
        segmentedGender.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "Back Arrow"), style: .plain, target: self, action: #selector(backBtnPressed))
        leftBarBtn.tintColor = .theebPrimaryColor
        let rightBarBtn = UIBarButtonItem(title: "profile_save".localized, style: .plain, target: self, action: #selector(btnSubmitPressed))
        rightBarBtn.tintColor = UIColor.theebPrimaryColor
        btnArrowReset.setImage(UIImage(named: "ArrowLine"), for: .normal)
        btnArrowReset.tintColor = #colorLiteral(red: 0.6060602069, green: 0.6160138249, blue: 0.6244431138, alpha: 1)
        navigationItem.leftBarButtonItem = leftBarBtn
        navigationItem.rightBarButtonItem = rightBarBtn
        txtFieldArr.forEach{
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = #colorLiteral(red: 0.6060602069, green: 0.6160138249, blue: 0.6244431138, alpha: 1)
            if let txtField = $0 as? JVFloatLabeledTextField{
                txtField.floatingLabelYPadding = 4
                txtField.contentVerticalAlignment = .bottom
            }
        }
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height/2
    }
    
    func alertUser(msg:String){

       CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
            print(index,title)
       }
    }
    
    func getProfileData(){
        shouldPresentLoadingView(true)
        guard let loginObject = CachingManager.loginObject() else {return}
        viewModel.getUserProfile(licenseNo: loginObject.licenseNo ?? "",mobile: loginObject.mobileNo ?? "",passportNo: loginObject.iDNo ?? "",email: loginObject.email ?? "")
    }
//    func getProfileData(){
//       // CustomLoader.customLoaderObj.startAnimating()
//        shouldPresentLoadingView(true)
//        LoginRegisterService().getDriverProfile(idNo: CachingManager.loginObject()?.iDNo ?? "", success: {response in
//            if let responseString = response as? String {
//                var resultString = responseString.replacingOccurrences(of: "DriverImportRS", with: "DriverProfileRS")
//                resultString = resultString.replacingOccurrences(of: "LicenseID", with: "LicenseId")
//                if let reponspobject = XMLMapper<DriverProfileRequestMappable>().map(XMLString: resultString) {
//                    let driverProfile = reponspobject.driverProfileRS
//                    self.driverProfileRS = driverProfile
//                    DispatchQueue.main.async {
//                        self.txtFieldLicence.text = self.buildExtension(driverProfile?.licenseDocExt)
//                        self.txtFieldJobID.text = self.buildExtension(driverProfile?.wordIdDocExt)
//                        self.txtFieledID.text = self.buildExtension(driverProfile?.idDocExt)
//                        self.shouldPresentLoadingView(false)
//                       // CustomLoader.customLoaderObj.stopAnimating()
//                    }
//                }
//            }
//        }, failure: {res , err in
//            self.shouldPresentLoadingView(false)
//        })
//    }
    
    func buildExtension(_ ext:String?)->String?{
        if let _ = ext{
            return "rental_viewDetails".localized
        }
        return nil
    }
    
    func enableORDiabletxtFields(){
//        if driverProfileRS?.FromIAMService == "Y"{
//            [txtFieldFirstName,txtFieldBirhday,txtNationality,txtIDVersion,txtExpityDate].forEach{
//                $0?.isEnabled = false
//                $0?.textColor = UIColor.lightGray
//            }
//        }
    }
    
    func hideViewsForCheckOut(isCheckOut:Bool){
            hiddenViewsArr.forEach{
                $0.isHidden = isCheckOut
            }
    }
    
    func handleNAtionality(){
        txtNationality.placeholder = "profile_Nationality".localized
        txtNationality.arrow.isHidden = true
        txtNationality.isImage = false
       // txtNationality.setRightPaddingPoints(20, view: nil)
        txtNationality.text = "Saudi Arabia"
        if let locations =  fillNAtionalityArr() {
            txtNationality.optionArray = locations
        }
        txtNationality.selectedRowColor = .clear
        txtNationality.didSelect {  [weak self] (text, index, id) in
          print(text)
        }
    }
    
    func fillNAtionalityArr()->[String]?{
        var list = [String]()
        list.append("Afghanistan")
        list.append("Albania")
        list.append("Algeria")
        list.append("American Samoa")
        list.append("Andorra")
        list.append("Angola")
        list.append("Anguilla")
        list.append("Antigua AND Barbuda")
        list.append("Argentina")
        list.append("Armenia")
        list.append("Aruba")
        list.append("Australia")
        list.append("Austria")
        list.append("Azerbaijan")
        list.append("Bahamas")
        list.append("Bahrain")
        list.append("Bangladesh")
        list.append("Barbados")
        list.append("Belarus")
        list.append("Belgium")
        list.append("Belize")
        list.append("Benin")
        list.append("Bermuda")
        list.append("Bhutan")
        list.append("Bolivia")
        list.append("Bonaire")
        list.append("Bosnia-Herzegovina")
        list.append("Botswana")
        list.append("Brazil")
        list.append("British Virgin Islands")
        list.append("Brunei")
        list.append("Bulgaria")
        list.append("Burkina Faso")
        list.append("Burundi")
        list.append("Cambodia")
        list.append("Cameroon Republic")
        list.append("Canada")
        list.append("Cape Verde")
        list.append("Cayman Island")
        list.append("Central African Republic")
        list.append("Chad")
        list.append("Chile")
        list.append("China")
        list.append("Colombia")
        list.append("Comoros")
        list.append("Congo Rep. of")
        list.append("Congo, Dem. Rep. of (Zaire)")
        list.append("Cook Islands")
        list.append("Costa Rica")
        list.append("Cote dlvoire")
        list.append("Croatia")
        list.append("Cuba")
        list.append("Curacao")
        list.append("Cyprus")
        list.append("Czech Republic")
        list.append("Denmark")
        list.append("Djiboti")
        list.append("Dominica")
        list.append("Dominican Republic")
        list.append("Ecuador")
        list.append("Egypt")
        list.append("El Salvador")
        list.append("Equatorial Guinea")
        list.append("Eritrea")
        list.append("Estonia")
        list.append("Ethiopia")
        list.append("Fiji")
        list.append("Finland")
        list.append("France")
        list.append("Frence Polynesia")
        list.append("Gabon")
        list.append("Gambia")
        list.append("Georgia")
        list.append("Germany")
        list.append("Ghana")
        list.append("Gilraltar")
        list.append("Greece")
        list.append("Grenada")
        list.append("Guadaloupe")
        list.append("Guam")
        list.append("Guatelama")
        list.append("Guinea")
        list.append("Guinea-Bissau")
        list.append("Guyana")
        list.append("Haiti")
        list.append("HallEnique")
        list.append("Honduras")
        list.append("Hong Kong")
        list.append("Hungary")
        list.append("Iceland")
        list.append("India")
        list.append("Indonesia")
        list.append("Iran")
        list.append("Iraq")
        list.append("Ireland")
        list.append("Italy")
        list.append("Jamaica")
        list.append("Japan")
        list.append("Jordan")
        list.append("Kazakhstan")
        list.append("Kenya")
        list.append("Kiribati")
        list.append("Korea North")
        list.append("Korea South")
        list.append("Kuwait")
        list.append("Kyrghyzstan")
        list.append("Laos")
        list.append("Latvia")
        list.append("Lebanon")
        list.append("Leichtenstein")
        list.append("Lesotho")
        list.append("Liberia")
        list.append("Libya")
        list.append("Lithuania")
        list.append("Luxembourg")
        list.append("Macau")
        list.append("Madagascar")
        list.append("Malagasy Republic")
        list.append("Malawi")
        list.append("Malaysia")
        list.append("Maldives")
        list.append("Mali")
        list.append("Malta")
        list.append("Marshal Islands")
        list.append("Martinique")
        list.append("Mauritania")
        list.append("Mauritius")
        list.append("Mexico")
        list.append("Moldova")
        list.append("Monaco")
        list.append("Mongolia")
        list.append("Montserrat")
        list.append("Morocco")
        list.append("Mozambique")
        list.append("Mynmar (Burma)")
        list.append("Namibia")
        list.append("Nauru")
        list.append("Nepal")
        list.append("Netherlands")
        list.append("New Zealand")
        list.append("Nicaragua")
        list.append("Niger")
        list.append("Nigeria")
        list.append("Northern Mariana Isl")
        list.append("Norway")
        list.append("Oman")
        list.append("Other")
        list.append("Pakistan")
        list.append("Palestine")
        list.append("Palestine")
        list.append("Panama")
        list.append("Papua New Guinea")
        list.append("Paraguay")
        list.append("Peru")
        list.append("Philippines")
        list.append("Poland")
        list.append("Portugal")
        list.append("Puerto Rico")
        list.append("Qatar")
        list.append("Reunion")
        list.append("Romania")
        list.append("Russia")
        list.append("Rwanda")
        list.append("Saba")
        list.append("Saint Lucia")
        list.append("Samoa")
        list.append("San Marino (in Italy)")
        list.append("Sao Tome")
        list.append("Saudi Arabia")
        list.append("Senegal")
        list.append("Seychelles")
        list.append("Sierra Leone")
        list.append("Singapore")
        list.append("Slovakia Republic")
        list.append("Slovenia")
        list.append("Solomon Island")
        list.append("Somalia")
        list.append("South Africa")
        list.append("Spain")
        list.append("Sri Lanka")
        list.append("St. Ketts-Nevis")
        list.append("St. Vincent AND Grenadines")
        list.append("Sudan")
        list.append("Surinam")
        list.append("Swaziland")
        list.append("Sweden")
        list.append("Switzerland")
        list.append("Syria")
        list.append("Tadjikistan")
        list.append("Taiwan")
        list.append("Tanzania")
        list.append("Thailand")
        list.append("Togo")
        list.append("Tonga")
        list.append("Trinidad AND Tobago")
        list.append("Tunisia")
        list.append("Turkey")
        list.append("Turkmenistan")
        list.append("Tuvalu")
        list.append("UAE")
        list.append("Uganda")
        list.append("UK")
        list.append("Ukraine")
        list.append("United Nations")
        list.append("Uruguay")
        list.append("USA")
        list.append("Uzbekistan")
        list.append("Vanuatu")
        list.append("Vatican City")
        list.append("Venezuela")
        list.append("Vietnam")
        list.append("Yemen")
        list.append("Yugoslavia")
        list.append("Zaire")
        list.append("Zambia")
        list.append("Zimbabwe")
        return list
    }
    
    func fillData(){
        
        let loginObject = CachingManager.loginObject()
        txtFieldFirstName.text = " \(loginObject?.firstName ?? "") \(loginObject?.lastName ?? "")"
        birthdayString = loginObject?.dateOfBirth ?? ""
        txtFieldBirhday.text = birthdayString
        flgTextField.setFlag(countryCode: FPNCountryCode.SA)
        flgTextField.text = " "
        flgTextField.font = UIFont.BahijTheSansArabicPlain(fontSize: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        txtFieldMobile.text = loginObject?.mobileNo
        txtFieldEmail.text = loginObject?.email
        txtIDNumber.text = loginObject?.iDNo
        flgTextField.isEnabled = (loginObject?.iDType != "S" || loginObject?.iDType != "I") && (loginObject?.iDNo?.isValidPassport() ?? false)
        txtNationality.text = loginObject?.nationality
        txtIDVersion.text = loginObject?.idVersino
        txtExpityDate.text = loginObject?.licenseExpiry
        txtLicenseNumber.text = loginObject?.licenseNo
        if let gender = loginObject?.gender{
            segmentedGender.selectedSegmentIndex = gender == "Female" ? 1:0
        }
        if let memberObject = CachingManager.memberDriverModel{
            txtFieldAddress1.text = memberObject.address1
            txtFieldAddress2.text = memberObject.address2
        }
      //  txtFieldLicence.addBtn(tagBtn: UpdateBtnsType.licenceBtn.rawValue, complition: presentGallery(_:))
       // txtFieldJobID.addBtn(tagBtn: UpdateBtnsType.jobIdBtn.rawValue, complition: presentGallery(_:))
        //txtFieledID.addBtn(tagBtn: UpdateBtnsType.idBtn.rawValue, complition: presentGallery(_:))
        if CachingManager.loginObject()?.driverImage == nil ||  CachingManager.loginObject()?.driverImage == "" {
            imgViewProfile.image = UIImage(named: "logo")
        } else {
            imgViewProfile.setImageFromBase64(base64String:CachingManager.loginObject()?.driverImage)
        }
        //imgViewProfile.setImageFromBase64(base64String:loginObject?.driverImage)
        [txtFieldLicence,txtFieldJobID,txtFieledID].forEach{
            $0?.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileData()
        addUpdateBtn(txtFieledID, tagBtn: UpdateBtnsType.idBtn.rawValue, action: #selector(presentGallery(_:)))
        addUpdateBtn(txtFieldLicence, tagBtn: UpdateBtnsType.licenceBtn.rawValue, action: #selector(presentGallery(_:)))
        addUpdateBtn(txtFieldJobID, tagBtn: UpdateBtnsType.jobIdBtn.rawValue, action: #selector(presentGallery(_:)))
        addUpdateBtn(txtNationality, tagBtn: 15, action: #selector(btnArrowPressed(_:)), imgName: "BottomArrow")
        if isFromMemberShip{
            memberShipViews.forEach{mainstackView.removeInputView(view: $0)}
        }else{
            mainstackView.removeInputView(view: viewSubmit)
        }
    }
    
    class func initializeFromStoryboard() -> UserProfileVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.UserProfile, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: UserProfileVC.self)) as! UserProfileVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: UserProfileVC.initializeFromStoryboard())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.Profile, screenClass: String(describing: UserProfileVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.Profile, screenClass: String(describing: UserProfileVC.self))
        
    }
    
    func addUpdateBtn(_ txtField:UITextField,tagBtn:Int,action:Selector,imgName:String? = nil){
        let button = UIButton(type: .custom)
        // button.setImage(UIImage(named: "dropdown_green"), for: .normal)
        if imgName == nil{
            button.setTitle("profile_updateBtn".localized, for: .normal)
        }else{
            button.isUserInteractionEnabled = false
            button.setImage(UIImage(named: imgName!), for: .normal)
        }
        button.setTitleColor(UIColor.theebPrimaryColor, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.tag = tagBtn
        //        button.frame = CGRect(x: CGFloat(txtField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action:action , for: .touchUpInside)
        // txtField.localizeTextFieldBtn(btn: button)
        txtField.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: txtField.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: txtField.trailingAnchor,constant: -16)
        ])
        txtField.bringSubviewToFront(button)
    }
    
    func addImagePopupView(_ txtField:UITextField){
        guard let driverProfileRS = driverProfileRS,!(txtField.text?.isEmpty ?? true) else {return}
        addFadeBackground(true, color: .darkGray)
        let imagePopupView = ImagePopUpView()
        imagePopupView.clipsToBounds = true
        imagePopupView.layer.cornerRadius = 12
        imagePopupView.delegate = self
        imagePopupView.tag = 123
        imagePopupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePopupView)
        NSLayoutConstraint.activate([
            imagePopupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagePopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imagePopupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            imagePopupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        imagePopupView.scaleAnimate()
        view.bringSubviewToFront(imagePopupView)
        switch txtField{
        case txtFieldLicence:
            imagePopupView.imgViewDoc.setImageFromBase64(base64String: driverProfileRS.licenseDoc)
        case txtFieldJobID:
            imagePopupView.imgViewDoc.setImageFromBase64(base64String: driverProfileRS.workIdDoc)
        case txtFieledID:
            imagePopupView.imgViewDoc.setImageFromBase64(base64String: driverProfileRS.idDoc)
        default:
            break
        }
    }
    
    @objc func btnArrowPressed(_ btn:UIButton){
        print(btn.tag)
    }
    
    @objc func backBtnPressed(){
        if isFromMemberShip{
            navigationController?.popViewController(animated: true)
        }else{
        dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func datePickerChanged(){
        if let datePicker = txtFieldBirhday.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            //dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "dd/MM/yyyy"
            birthdayString = dateformatter.string(from: datePicker.date)
            txtFieldBirhday.text = birthdayString
        }
        txtFieldBirhday.resignFirstResponder()
    }
    
    @objc func expirtyDatePickerChanged(){
        if let datePicker = txtExpityDate.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            //dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "dd/MM/yyyy"
            txtExpityDate.text = dateformatter.string(from: datePicker.date)
        }
        txtExpityDate.resignFirstResponder()
    }
    
    func mutateLoginObject(firstName:String? = nil,
                           lastName:String? = nil,
                           dateOfBirth:String? = nil,
                           nationality:String? = nil,
                           licenseId:String? = nil,
                           address1:String? = nil,
                           address2:String? = nil,
                           homeTel:String? = nil,
                           workTel:String? = nil ,
                           mobile:String? = nil,
                           email:String? = nil,
                           idType:String? = nil,
                           idNo:String? = nil,
                           workIdDoc :String? = nil,
                           workIdDocFileExt :String? = nil,
                           gender :String? = nil)
    {
        let loginObject = CachingManager.loginObject()
        loginObject?.firstName = firstName
        loginObject?.lastName = lastName
        loginObject?.dateOfBirth = birthdayString
        loginObject?.gender = gender
        loginObject?.nationality = txtNationality.text
        loginObject?.licenseExpiry = txtExpityDate.text
        loginObject?.idVersino = txtIDVersion.text
        loginObject?.isFromIam = driverProfileRS?.fromIAMService
        if let imgStringProfile = imgStringProfile{
            loginObject?.driverImage = imgStringProfile.0
        }
        CachingManager.removeValue(forKey: CachingKeys.LoggedInUserData)
        CachingManager.setLoginObject(loginObject)
    }
    
    @objc func saveBtnPressed() {
        let name = txtFieldFirstName.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) ?? ""
        let slicename = name.sliceFullname()
        let genderStr = segmentedGender.selectedSegmentIndex == 0 ? "Male":"Female"
       // let loginObject = CachingManager.loginObject() txtIDVersion.text = loginObject?.idVersino
        viewModel.updateDriverAccount(
            firstName: slicename.0 ?? "",lastName: slicename.1 ?? "",
            dateOfBirth: birthdayString,
            nationality: txtNationality.text,
            licenseId: CachingManager.loginObject()?.iDNo,
            licenseIssuedBy: "",
            licenseExpiryDate:txtExpityDate.text ?? CachingManager.loginObject()?.licenseExpiry,
            licenseDoc: imgStringLicence?.0,
            licenseDocFileExt: imgStringLicence?.1,
            address1: txtFieldAddress1.text,
            address2: txtFieldAddress2.text,
            homeTel: "",
            ISDCode1: String(flgTextField.selectedCountry?.phoneCode.dropFirst() ?? ""),
            workTel: "",
            mobile: CachingManager.loginObject()?.mobileNo ?? "",
            email: CachingManager.loginObject()?.email ?? "",
            idType: CachingManager.loginObject()?.iDType ?? "I",
            idNo: CachingManager.loginObject()?.iDNo ?? "",
            idDoc: imgStringId?.0,
            idDocFileExt: imgStringId?.1,
            membershipNo: "",
            operation: "U",
            iDSerialNo: txtIDVersion.text ?? CachingManager.loginObject()?.idVersino,
            workIdDoc: imgStringJobId?.0,
            workIdDocFileExt: imgStringJobId?.1,
            driverImage: imgStringProfile?.0,
            driverImageFileExt: imgStringProfile?.1,
            gender:genderStr ,
            fomIAMService: "",
            arabicName: "",
            passLicExpDate: "",
            password: "")
        mutateLoginObject(firstName: slicename.0,lastName: slicename.1,  dateOfBirth:birthdayString,nationality:txtNationality.text, licenseId: txtFieldLicence.text,  address1:txtFieldAddress1.text, address2:txtFieldAddress2.text, mobile: txtFieldMobile.text?.withoutSpaces, email: txtFieldEmail.text,idNo: txtFieledID.text,gender: genderStr)
       // backBtnPressed()
    }
    
    enum UpdateBtnsType:Int {
        case licenceBtn = 12
        case jobIdBtn = 13
        case idBtn = 14
    }
    
    @objc func segemnetdChange(_ segmnt:UISegmentedControl){
        print(segmnt.selectedSegmentIndex)
    }
    
   @objc func presentGallery(_ btn:UIButton){
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) ?? []
        tagBtn = btn.tag
        present( imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmitPressed(_ sender: ButtonRounded? = nil) {
        if isIDValid(CachingManager.loginObject()?.iDNo ?? "", type: CachingManager.loginObject()?.iDType ?? "").startsWithOneOrTwo &&  isIDValid(CachingManager.loginObject()?.iDNo ?? "", type: CachingManager.loginObject()?.iDType ?? "").isValid {
            viewModel.yaqeenValidation(DriverID: CachingManager.loginObject()?.iDNo ?? "", DriverDOB: convertDateString(birthdayString))
        } else if isIDValid(CachingManager.loginObject()?.iDNo ?? "", type: CachingManager.loginObject()?.iDType ?? "").startsWithOneOrTwo && isIDValid(CachingManager.loginObject()?.iDNo ?? "", type: CachingManager.loginObject()?.iDType ?? "").isValid == false {
            alertUser(msg: "Please enter a valid ID number, passport, or Iqama.".localized)
        } else if isIDValid(CachingManager.loginObject()?.iDNo ?? "", type: CachingManager.loginObject()?.iDType ?? "").startsWithOneOrTwo  == false && isIDValid(CachingManager.loginObject()?.iDNo ?? "", type: CachingManager.loginObject()?.iDType ?? "").isValid {
            saveBtnPressed()
        } else {
            alertUser(msg: "Please enter a valid ID number, passport, or Iqama.".localized)
        }
        
       // viewModel.yaqeenValidation(DriverID: CachingManager.loginObject()?.iDNo ?? "", DriverDOB: convertDateString(birthdayString))
     //   viewModel.subscribeToMemberShip(idNo:"2329321174")
    }
    
    
    func isIDValid(_ id: String, type: String) -> (startsWithOneOrTwo: Bool, isValid: Bool) {
        // Check if the type is S (for start with 1), I (for start with 2), or P (for others)
        let startsWithOneOrTwo = type == "S" || type == "I"
        
        // Check if the ID length is 10 when it starts with 1 or 2, otherwise check if it's greater than 7
        let isValidLength = startsWithOneOrTwo ? id.count == 10 : id.count > 7
        
        // Check if the ID contains only digits when it starts with 1 or 2
        let isValidFormat = startsWithOneOrTwo ? id.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil : true
        
        // Return the validation results
        return (startsWithOneOrTwo, isValidLength && isValidFormat)
    }

    @IBAction func btnEditProfilePressed(_ sender: UIButton) {
        presentGallery(sender)
    }
    
    @IBAction func btnResetPAssword(_ sender: UIButton) {
        let loginObject = CachingManager.loginObject()
        let resetVc = ResetpasswordVC.initializeFromStoryboard()
        resetVc.email = loginObject?.email
        resetVc.isFromUSerProfile = true
        presentDetail(resetVc)
    }
    
}

extension UserProfileVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        addImagePopupView(textField)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension UserProfileVC: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,let mediaURL = info[UIImagePickerController.InfoKey.imageURL] as? URL  else {return }
        let lastPathString = String(mediaURL.lastPathComponent.split(separator: "-").last ?? "")
        let ext = mediaURL.pathExtension
        switch tagBtn{
        case UpdateBtnsType.licenceBtn.rawValue:
            imgStringLicence = (image.serializeImageToString(),ext)
            txtFieldLicence.text = lastPathString
        case UpdateBtnsType.idBtn.rawValue:
            imgStringId = (image.serializeImageToString(),ext)
            txtFieledID.text = lastPathString
        case UpdateBtnsType.jobIdBtn.rawValue:
            imgStringJobId = (image.serializeImageToString(),ext)
            txtFieldJobID.text = lastPathString
        default:
            imgViewProfile.image = image
            imgStringProfile = (image.serializeImageToString(),ext)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension UserProfileVC:ImagePopUpViewDelegate{
    func btnCloseDelegatePressed() {
        addFadeBackground(false, color: nil)
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

     extension JVFloatLabeledTextField{
         var paddingDefult:UIEdgeInsets{
             UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
         }

         open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
             return bounds.inset(by: paddingDefult)
         }

         open override func textRect(forBounds bounds: CGRect) -> CGRect {
             return bounds.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 0, right: 6))
         }
     }

/*
 "profile_Nationality" = "Nationality";
 "profile_idNumber" = "ID Number";
 "profile_idVersion" = "ID Version";
 "profile_licenseNumber" = "License Number";
 "profile_licenseExpiryDate" = "License Expiry Date";
 "profile_gender" = "Gender";
 "profile_addresses" = "Addresses";
 "profile_addresse2Optional" = "Address 2 (Optional)";
 "profile_addresse1" = "Address 1";
 "profile_Male" = "Male";
 "profile_Female" = "Female";
 */

extension UserProfileVC{
    func bindUserPorfile(){
        
        viewModel.userProfile.listen(on: { [weak self] value in
            self?.shouldPresentLoadingView(false)
            if self?.viewModel.userProfile.value != nil {
                self?.driverProfileRS = self?.viewModel.userProfile.value?.driverProfile
                self?.txtFieldLicence.text = self?.buildExtension(self?.viewModel.userProfile.value?.driverProfile.licenseDocExt)
                self?.txtFieldJobID.text = self?.buildExtension(self?.viewModel.userProfile.value?.driverProfile.workIdDocExt)
                self?.txtFieledID.text = self?.buildExtension(self?.viewModel.userProfile.value?.driverProfile.idDocExt)
    
                if self?.viewModel.userProfile.value?.driverProfile.yaqeenVerifiedyn == "Y" {
                    self?.txtFieldBirhday.isEnabled = false
                    self?.txtFieldBirhday.textColor = UIColor.lightGray
                    
                    self?.txtNationality.textColor = UIColor.lightGray
                    self?.txtNationality.isEnabled = false
                    
                    self?.txtExpityDate.textColor = UIColor.lightGray
                    self?.txtExpityDate.isEnabled = false
                    
                    self?.txtFieldFirstName.textColor = UIColor.lightGray
                    self?.txtFieldFirstName.isEnabled = false
                    
                    self?.txtIDVersion.textColor = UIColor.lightGray
                    self?.txtIDVersion.isEnabled = false
                    
                self?.flgTextField.textColor = UIColor.lightGray
                self?.flgTextField.isEnabled = false
                
                } else {
                    self?.txtFieldBirhday.isEnabled = true
                    self?.txtFieldBirhday.textColor = UIColor.black
                    self?.txtNationality.textColor = UIColor.black
                    self?.txtNationality.isEnabled = true
                    
                    self?.txtExpityDate.textColor = UIColor.black
                    self?.txtExpityDate.isEnabled = true
                    
                    self?.txtFieldFirstName.textColor = UIColor.black
                    self?.txtFieldFirstName.isEnabled = true
                    
                    self?.txtIDVersion.textColor = UIColor.black
                    self?.txtIDVersion.isEnabled = true
                
                self?.flgTextField.textColor = UIColor.black
                self?.flgTextField.isEnabled = true
                }
            } else {
                CustomAlertController.initialization().showAlertWithOkButton(message: "error_Occured_msg".localized) { (index, title) in
                     print(index,title)
                }
            }
        })
    }
    
    func bindYaqeenValidation(){
        viewModel.yaqeenResponse.listen(on: { [weak self] value in
            guard let value = value else { return }
            if value.driverImportRS?.success == "Y" {
                self?.checkIsYaqeenCalled(response: value)
            } else {
                self?.alertUser(msg: value.driverImportRS?.varianceReason ?? "")
            }
        })
    }
}

extension UserProfileVC {
    func convertDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy" // Update date format to match input string format
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        // Update the output date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedString = dateFormatter.string(from: date)
        
        return formattedString
    }
}
