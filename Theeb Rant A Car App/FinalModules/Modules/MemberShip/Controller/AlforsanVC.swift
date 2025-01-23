//
//  AlforsanVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 21/03/2022.
//

import UIKit

class AlforsanVC:BaseViewController{
    
    //vars
    let viewModel = MemberViewModel()
    var userViewModel = UserProfileViewModel()
    let sideViewModel = SideMenuViewModel()
    var isFoursanAvailable = true {
        didSet {
            txtFieldID.isEnabled = !isFoursanAvailable
            if !isFoursanAvailable {
                txtFieldID.becomeFirstResponder()
                alertUser(msg: "alforsan_EnterID".localized)
            }
        }
    }
    var alforsanToken:String?
    
    //outlets
    @IBOutlet weak var btnCancel: ButtonRounded!{
        didSet{
            btnCancel.setTitle("alforsanVC_cancel".localized, for: .normal)
        }
    }
    @IBOutlet weak var btnConfirm: ButtonRounded!{
        didSet{
            btnConfirm.setTitle("alforsanVC_Confirm".localized, for: .normal)
        }
    }
    @IBOutlet weak var lblstatictitle: UILabel!
    @IBOutlet weak var lblStaticSure: UILabel!
    @IBOutlet weak var lblStaticNuoOfPoint: UILabel!
    @IBOutlet weak var lblStaticAlfprsanId: UILabel!
    @IBOutlet weak var alertViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTansfer: ButtonRounded!
    @IBOutlet weak var txtFieldID: CustomTextField!
    @IBOutlet weak var txtFieldPoints: CustomTextField!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var alerView: RoundedShadowView!
//    @IBOutlet weak var userCurrentBalanceField: CustomTextField!
//    @IBOutlet weak var yourPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        alertViewBottomConstraint.constant = -alerView.frame.height
        viewModel.animateTransferView = animateConstraint
        listenToAlforsanUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let alforsanId = CachingManager.alforsanID, !alforsanId.isEmpty{
            txtFieldID.text = alforsanId //"1000000015"
//            Task{
//                await generateAlforsanToken(alforsanId: alforsanId)
//            }
        }else{
            setAlforsan()
        }
    }
    
    func setupViews(){
        lblStaticSure.text = "alforsanVC_AreYouSure".localized
        lblBalance.text = LoyalityModel.getPointsRate()
//        userCurrentBalanceField.text = "\( Double(CachingManager.memberDriverModel?.loyality?.totalPoints ?? "0") ?? 0)"
//        userCurrentBalanceField.textColor = userCurrentBalanceField.textColor?.withAlphaComponent(0.2)
//        yourPointsLabel.textColor = yourPointsLabel.textColor.withAlphaComponent(0.2)
        lblStaticAlfprsanId.text = "alforsanVC_Alfursan_ID".localized
        lblStaticNuoOfPoint.text = "alforsan_NumOfPoints".localized
        btnTansfer.setTitle("alforsanVC_conirmTransform".localized, for: .normal)
       // lblstatictitle.text = "alforsan_transfeerPoints".localized
        title = "alforsan_transfeerPoints".localized

    }
    
    func generateAlforsanTokenAndValditeAforsanID(alforsanId: String?) async{
        CustomLoader.customLoaderObj.startAnimating()
        let tokenStatus = await AlfursanService.instance.getAlfursanAccesTokenasync()
        switch tokenStatus {
        case .success(let model):
            alforsanToken = model.accessToken
            if let alforsanToken = alforsanToken, let alforsanId = alforsanId {
                await validateAlforsanID(alforsanId: alforsanId, accessToken: alforsanToken)
            }
        case.failure(let err):
            alertUser(msg: err.localizedDescription)
            CustomLoader.customLoaderObj.stopAnimating()
        }
    }
    
    func validateAlforsanID(alforsanId: String, accessToken: String) async {
        let alforsanValidationStatus = await AlfursanService.instance.validateMembershipForAlforsan(alforsanId: alforsanId, accessToken: accessToken )
        switch alforsanValidationStatus {
        case .success(let model):
            CachingManager.alforsanID = alforsanId
            let alforsanValid = model.success ?? false
            if !alforsanValid {
                alertUser(msg: model.message ?? "Error occured")
                CustomLoader.customLoaderObj.stopAnimating()
                return
            }
            if let points = txtFieldPoints.text,let driverCode = CachingManager.loginObject()?.driverCode,let passportID = CachingManager.loginObject()?.iDNo, let email = CachingManager.loginObject()?.email, let userID = CachingManager.loginObject()?.licenseNo{
                if isFoursanAvailable {
                    // transfer as alforsanID ia available and valid
                    transferALforsanPoints(points: points, driverCode: driverCode, email: email, passportID: passportID, userID: userID)
                }else{
                    //update the BE with the valid alforsanID and transfer points
                    userViewModel.updateDriverAccount(
                        firstName: CachingManager.loginObject()?.firstName,
                        lastName: CachingManager.loginObject()?.lastName,
                        dateOfBirth: CachingManager.loginObject()?.dateOfBirth ,
                        nationality: CachingManager.loginObject()?.nationality,
                        licenseId: CachingManager.loginObject()?.licenseNo,
                        licenseIssuedBy: nil,
                        licenseExpiryDate: nil,
                        licenseDoc: nil,
                        licenseDocFileExt: nil,
                        address1: nil,
                        address2: nil,
                        homeTel: "",
                        ISDCode1: "",
                        workTel: "",
                        mobile: CachingManager.loginObject()?.mobileNo ?? "",
                        email: CachingManager.loginObject()?.email ?? "",
                        idType: CachingManager.loginObject()?.iDType ?? "I",
                        idNo: CachingManager.loginObject()?.iDNo ?? "",
                        idDoc: nil,
                        idDocFileExt: nil,
                        membershipNo: "",
                        operation: "U",
                        iDSerialNo: CachingManager.loginObject()?.idVersino,
                        workIdDoc: nil,
                        workIdDocFileExt: nil,
                        driverImage: nil,
                        driverImageFileExt: nil,
                        gender: nil ,
                        fomIAMService: "",
                        arabicName: "",
                        passLicExpDate: "",
                        password: nil,
                        isFromAlForsan: true,
                        alfursanID: alforsanId){ [weak self] in
                            self?.transferALforsanPoints(points: points, driverCode: driverCode, email: email, passportID: passportID, userID: userID)
                        }
                }
            }
        case .failure(let err):
            CustomLoader.customLoaderObj.stopAnimating()
            isFoursanAvailable = false
            alertUser(msg: err.localizedDescription)
        }
    }

    func animateConstraint(_ value:CGFloat){
        view.endEditing(true)
        alertViewBottomConstraint.constant = value
        UIView.animate(withDuration: 0.4, delay: 0,  options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func listenToAlforsanUserProfile() {
        sideViewModel.userProfile.listen(on: {[weak self] value in
            CustomLoader.customLoaderObj.stopAnimating()
            guard let self = self else {return}
            lblBalance.text = "alforsan_yourBalance".localized + (value?.driverProfile.loyality?.totalPoints ?? "0" + " ") + "alforsan_pointsWorth".localized
            if let forsanID = CachingManager.alforsanID, !forsanID.isEmpty {
                    txtFieldID.text = forsanID
                     CachingManager.alforsanID = forsanID
                    isFoursanAvailable = true
                }else{
                    isFoursanAvailable = false
                }
        })
    }
    
    func setAlforsan(){
        guard let loginObject = CachingManager.loginObject() else { return }
        CustomLoader.customLoaderObj.startAnimating()
        sideViewModel.getUserProfile(licenseNo: loginObject.licenseNo ?? "",mobile: loginObject.mobileNo ?? "",passportNo: loginObject.iDNo ?? "",email: loginObject.email ?? "")
    }
    
    func transferALforsanPoints(points:String, driverCode:String, email:String, passportID:String, userID:String){
        Task{
            let alforsanTrnasfeer =  await AlfursanService.instance.convertLoyalityPoint(accessToken: alforsanToken ?? "", pointsToTransfeer: Int(points) ?? 0, driverCode: driverCode, loginUser: email, lastName: CachingManager.loginObject()?.lastName, licenseIdNo: userID, mobileNumber: CachingManager.loginObject()?.mobileNo ?? "", passportNumber: passportID, email: email)

            switch alforsanTrnasfeer {
              case .success(let model):
                let isSuccess = model.success ?? false
                CustomLoader.customLoaderObj.stopAnimating()
                CustomAlertController.initialization().showAlertWithOkButton(
                    title: isSuccess ? "alert_success".localized:"login_error".localized,
                    message: isSuccess ? model.message ?? "Successful transfer":model.error ?? "Error occured") {[weak self] (index, title) in
                        print(title,index)
                        self?.navigationController?.popToRootViewController(animated: true)
               }
              case .failure(let err):
                CustomLoader.customLoaderObj.stopAnimating()
                alertUser(msg: err.localizedDescription)
            }
        }
    }
    func alertUser(msg:String){

       CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
            print(index,title)
       }
    }
    
    @IBAction func btnTransferPressed(_ sender: UIButton) {
        let totalPoints = Double(CachingManager.memberDriverModel?.loyality?.totalPoints ?? "0") ?? 0
        let minPoint = Double(CachingManager.memberDriverModel?.loyality?.minimumPoints ?? "0") ?? 0
        let maxPoint = Double(CachingManager.memberDriverModel?.loyality?.maximumPoints ?? "0") ?? 0
        let maxRange = min(maxPoint, totalPoints)
        if let alforsanID = txtFieldID.text,alforsanID.count>=5{
            if let points = Double(txtFieldPoints.text ?? "0"),(points >= minPoint && points <= maxRange){
               viewModel.animateTransferView?(8)
            }else{
                print(minPoint)
                var alertString = String(format: NSLocalizedString("alforsan_Points", comment: ""), Int(minPoint)) + String(Int(maxRange)) + "alforsan_pointsWorth".localized
                if totalPoints == 0 { alertString = "alforsanVC_enoughPoints".localized}
                alertUser(msg: alertString)
            }
        }else{
            alertUser(msg: "alforsan_EnterID".localized)
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        viewModel.animateTransferView?(-alerView.frame.height)
    }
    
    @IBAction func btnConfirmPressed(_ sender: UIButton) {
//        if let alforsanID = txtFieldID.text,let points = txtFieldPoints.text,let driverCode = CachingManager.loginObject()?.driverCode,let passportID = CachingManager.loginObject()?.iDNo, let email = CachingManager.loginObject()?.email, let userID = CachingManager.loginObject()?.licenseNo{
//            viewModel.animateValue = -alerView.frame.height
//            if self.isFoursanAvailable {
//                transferALforsanPoints(points: points, driverCode: driverCode, email: email, passportID: passportID, userID: userID)
//            }else{
        viewModel.animateTransferView?(-alerView.frame.height)
        if let alforsanID = txtFieldID.text{
                Task{
                   await generateAlforsanTokenAndValditeAforsanID(alforsanId: alforsanID)
                }
            }
           
       // }
    }
    
}
