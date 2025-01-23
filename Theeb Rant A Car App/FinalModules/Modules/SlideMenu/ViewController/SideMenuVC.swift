//
//  SideMenuVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 12/06/1443 AH.
//

import UIKit

class SlideMenuVC : UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    // MARK: - Outlets
  //  @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMemberShip: UIButton!
    @IBOutlet weak var btnPoints: UIButton!
    @IBOutlet weak var topSilverConstraint: NSLayoutConstraint!
    @IBOutlet var bottomSlvrViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPointHint: UILabel!{
        didSet{
            lblPointHint.text = "memberShip_NumOfPoints".localized + ": "
        }
    }
    @IBOutlet weak var lblSilverHint: UILabel!{
        didSet{
            lblSilverHint.text = "rental_memberShipTitle".localized + ": "
        }
    }
    @IBOutlet weak var barView: UIView!{
        didSet{
            barView.layer.cornerRadius = barView.frame.height/4
        }
    }
    @IBOutlet weak var lblStaticEqualTo: UILabel!
    @IBOutlet weak var silverView: UIView!
    @IBOutlet weak var imgViewHeader: UIImageView!
    @IBOutlet weak var memberShipTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var lblRemainingPoints: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    @IBOutlet weak var lblSilver: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel! 
    
    @IBOutlet weak var editProfileBtn: UIButton! {
        didSet {
            editProfileBtn.setTitle("profile_btn_edit_title".localized, for: .normal)
        }
    }
    var mappedString = ""
    var placeHolderView:UIView = {
        let pView = UIView()
        pView.backgroundColor = .weemLightGray
        pView.isUserInteractionEnabled = false
        return pView
    }()
    lazy var viewModel = SideMenuViewModel()
    var memberDriverModel:DriverProfile?
    var loadingPlaceholderView = LoadingPlaceholderView()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "\("Release".localized) \(Bundle.main.releaseVersionNumber ?? "" ) Build : \(Bundle.main.buildVersionNumber ?? "")"
        bindUserPorfile()
    }
    
    func setupLoader(){
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
        loadingPlaceholderView.cover(silverView)
        imgViewProfile.addSubview(placeHolderView)
        placeHolderView.fillSuperview()

    }
    
    func setShimmer(){
        [imgViewProfile].forEach{$0?.withShimmer = true}
        startShimmerAnimation()
    }
    
    func fillDate(){
        emailLabel.text = CachingManager.loginObject()?.email ?? ""
        fullNameLabel.text = (CachingManager.loginObject()?.firstName ?? "")! +  " " + ((CachingManager.loginObject()?.lastName) ?? "")
        profileTitleLabel.text = "profile_title_label".localized
        lblRemainingPoints.text = "profile_EarnPoint".localized
        lblRemainingPoints.isHidden = true
        lblStaticEqualTo.text = "profile_EqualsTo".localized + "34.66" + "sar".localized

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewModel()
        setupLoader()
        setupButtons()
       // navigationController?.applyGrayNavigationBar()
       // stackViewBottomConstraint.constant = silverView.frame.height/2
        view.layoutIfNeeded()
       // viewModel.setupUserItems()
       // tableView.reloadData()
       // silverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture)))
    }
    
    func setupButtons() {
        [btnMemberShip,btnPoints].forEach {
            $0?.layer.cornerRadius = 4
        }
        btnPoints.setTitle("profile_points_title".localized, for: .normal)
        btnMemberShip.setTitle("profile_membership_title".localized, for: .normal)
        btnMemberShip.addTarget(self, action: #selector(handleMemperShip), for: .touchUpInside)
        btnPoints.addTarget(self, action: #selector(handleGesture), for: .touchUpInside)
    }
    @objc func handleGesture(){
        let historyVc = AlfursanHistoryVC.initializeFromStoryboard()
        let pointsString = "memberShip_NumOfPoints".localized + " " + (memberDriverModel?.loyality?.totalPoints ?? "")
        historyVc.setMEmberShipData(memberShipType: mappedString, pointsNum: pointsString)
        viewModel.navigateToViewController?(historyVc)
    }
    
    @objc func handleMemperShip(){
        let memberDetailVc = MemberShipVc.initializeFromStoryboard()
        memberDetailVc.memberTitle = memberDriverModel?.membership?.cardType
        viewModel.navigateToViewController?(memberDetailVc)
    }
    
    func handleHeaderImgView(_ img:UIImage?) {
        imgViewHeader.image = UIApplication.isRTL() ? img?.withHorizontallyFlippedOrientation():img
    }
    // MARK: - Setup
    
    func getProfileData(){
       // shouldPresentLoadingView(true)
        guard let loginObject = CachingManager.loginObject() else {return}
        viewModel.getUserProfile(licenseNo: loginObject.licenseNo ?? "",mobile: loginObject.mobileNo ?? "",passportNo: loginObject.iDNo ?? "",email: loginObject.email ?? "")
    }
    
    func setupViewModel() {
//        guard let driverID = CachingManager.loginObject()?.iDNo else {return}
//        viewModel.getDriverMember(driverID:driverID){ memberModel in
//            DispatchQueue.main.async {
//                CachingManager.alforsanID = memberModel?.alfursanID
//                CachingManager.royaltyPointBal = memberModel?.loyality.totalPoints
//                self.setupViews(memberDriverModel: memberModel)
//               // self.stopShimmerAnimation()
//                self.placeHolderView.removeFromSuperview()
//                self.loadingPlaceholderView.uncover()
//                self.viewModel.setupUserItems()
//                self.tableView.reloadData()
//            }
//        }
        
        getProfileData()
        viewModel.navigateToViewController = { [unowned self] (vc) in
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.dismiss = { [unowned self] in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        viewModel.pushViewController = { vc in
            vc.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.present(vc, animated: true)
        
        }
        
        viewModel.alertUSerBeforeDelete = alertUSerWhenDelete
        viewModel.alertUSerBeforeLogout = alertUSerWhenLogout
    }
    
    
    // MARK: - Helper Methods
    
    func alertUSerWhenDelete(){
        let alertVc = UIAlertController( title: nil, message: "profile_item_deleteAcountAlertMsg".localized, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "profile_item_delete".localized, style: .destructive) {[weak self] alert in
            self?.viewModel.deleteUser()
        }
        let alertCancelAction = UIAlertAction(title: "alforsanVC_cancel".localized, style: .default)
        alertVc.addAction(alertOKAction)
        alertVc.addAction(alertCancelAction)
        present(alertVc, animated: true)
    }
    
    func alertUSerWhenLogout(){
        let alertVc = UIAlertController( title: nil, message: "logout_Err_msg".localized, preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "logout".localized, style: .destructive) {[weak self] alert in
            self?.viewModel.logOutAction()
        }
        let alertCancelAction = UIAlertAction(title: "alforsanVC_cancel".localized, style: .default)
        alertVc.addAction(alertOKAction)
        alertVc.addAction(alertCancelAction)
        present(alertVc, animated: true)
    }
    
    func addBeAMember(){
        let beAmemberView = BeAmember()
        beAmemberView.complition = pushAllMembers
        view.addSubview(beAmemberView)
        beAmemberView.anchor(silverView.topAnchor, left: silverView.leftAnchor, bottom: silverView.bottomAnchor, right: silverView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func pushAllMembers(){
        let userStoryBoard = UIStoryboard(name: "MemberShip", bundle: nil)
        guard let navVc = userStoryBoard.instantiateViewController(withIdentifier: "AllMembersVC") as? AllMembersVC else {return}
        viewModel.navigateToViewController?(navVc)
    }
   
    func setupViews(memberDriverModel :DriverProfile?){
        self.memberDriverModel =  memberDriverModel
        CachingManager.memberDriverModel = memberDriverModel
        let alforsanEnabled = memberDriverModel?.loyality?.alfursanEnabled ?? "N"
        btnPoints.isHidden = alforsanEnabled != "Y"
        let cashedLoginObject = CachingManager.loginObject()
        mappedString = setSilverImg() ?? ""
        if cashedLoginObject?.driverImage == nil ||  cashedLoginObject?.driverImage == "" {
            imgViewProfile.image = UIImage(named: "logo")
        } else {
            imgViewProfile.setImageFromBase64(base64String:cashedLoginObject?.driverImage)
        }
        imgViewProfile.layer.cornerRadius = imgViewProfile.frame.height/2
        lblPoints.text = memberDriverModel?.loyality?.totalPoints
        lblSilver.text = mappedString
        fillDate()

    }
    
    func setConstraint(isCollabsed:Bool = true){
        let const = view.frame.height
        [topSilverConstraint,bottomSlvrViewConstraint].forEach{
            $0?.constant = isCollabsed ? (const/10):24
        }
        view.layoutIfNeeded()
    }
    
    func setSilverImg()->String?{
        let isArabic = UIApplication.isRTL()
        memberShipTitle.text = "profile_membership_title".localized
        setConstraint()
        switch memberDriverModel?.membership?.cardType{
        case "فضية" :
            handleHeaderImgView(UIImage(named: "SlverHeader"))
            return isArabic ? "فضية":"Silver"
        case "ذهبية" :
            handleHeaderImgView(UIImage(named: "goldenHeader"))
            return isArabic ? "ذهبية":"Gold"
        case "برونزية":
           handleHeaderImgView(UIImage(named: "bronzHeader"))
            return isArabic ? "برونزية":"Bronze"
        case "عطاء" :
            handleHeaderImgView(UIImage(named: "greenHeader"))
            return isArabic ? "عطاء":"Ata'a"
        case "ماسية":
            handleHeaderImgView(UIImage(named: "diamondHeader"))
            return isArabic ? "ماسية":"Diamond"
        default:
            setConstraint(isCollabsed: false)
            handleHeaderImgView(UIImage(named: "blueHeader"))
            addBeAMember()
            return nil
        }
    }
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> SlideMenuVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.SlideMenuVC, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: SlideMenuVC.self)) as! SlideMenuVC
    }
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: SlideMenuVC.initializeFromStoryboard())
    }
    
    
    
    
    // MARK: -Actions
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
 
       // UIApplication.topViewController()?.present(UINavigationController(rootViewController: UserProfileVC.initializeFromStoryboard()), animated: true, completion: nil)
        let userStoryBoard = UIStoryboard(name: "UserProfile", bundle: nil)
        guard let navVc = userStoryBoard.instantiateViewController(withIdentifier: "UserProfileNAvVC") as? UINavigationController else {return}
    viewModel.pushViewController?(navVc)
    }
    
}

// MARK: - UITableViewDataSource

extension SlideMenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = viewModel.itemName(atIndex: indexPath.row)
        cell.textLabel?.textColor = viewModel.itemColor(atIndex: indexPath.row)
        cell.textLabel?.font = UIFont.BahijTheSansArabicSemiBold(fontSize: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)//viewModel.itemFont(atIndex: indexPath.row)
        cell.imageView?.image = viewModel.itemImage(atIndex: indexPath.row)
        cell.imageView?.tintColor = UIColor.darkGray
        return cell
    }
}
    



// MARK: - UITableViewDelegate

extension SlideMenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectItemAtIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
    }
}
extension SlideMenuVC{
    func bindUserPorfile(){
        
        viewModel.userProfile.listen(on: { [weak self] value in
            DispatchQueue.main.async {
                CachingManager.alforsanID = value?.driverProfile.loyality?.alfursanID
                CachingManager.royaltyPointBal = value?.driverProfile.loyality?.totalPoints
                self?.setupViews(memberDriverModel: value?.driverProfile)
               // self.stopShimmerAnimation()
                self?.placeHolderView.removeFromSuperview()
                self?.loadingPlaceholderView.uncover()
                self?.viewModel.setupUserItems()
                self?.tableView.reloadData()
            }        })
    }
}
