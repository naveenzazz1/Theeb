//
//  MemberDetailsVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 29/03/2022.
//

import UIKit

class MemberDetailsVC:BaseViewController{


    //vars
    //var mainArr = [[NSMutableAttributedString]]()
    var paymentDelegate:PaymentDelegate?
    var memberElement:MemberElement = .gold
    var hideClose = false
    let headerTitles = ["memberShip_Benfits".localized, "memberShip_Requirements".localized]
    
    @IBOutlet weak var btnClose: UIButton!{
        didSet{
            btnClose.isHidden = hideClose
        }
    }
    @IBOutlet weak var heightBtnUpgrade: NSLayoutConstraint!
    @IBOutlet weak var lblProcessing: UILabel!
    @IBOutlet weak var lblSilver: GradientLabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUpdarege: ButtonRounded!{
        didSet{
            btnUpdarege.isEnabled = false
        }
    }
    @IBOutlet weak var elemntTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  createSilverArr()
        handleViews()
        handleMEmberStatus()
    }
    
    func handleViews(){
        lblSilver.topColor = memberElement.memberGradientColor.0
        lblSilver.bottomColor = memberElement.memberGradientColor.1
        elemntTableView.delegate = self
        elemntTableView.dataSource = self
        let albumNib = UINib(nibName: "MemberDetailCell", bundle: nil)
        elemntTableView.register(albumNib, forCellReuseIdentifier: MemberDetailCell.identifier)
        elemntTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        elemntTableView.tableFooterView = UIView()
        //elemntTableView.direction = .right
        elemntTableView.showsVerticalScrollIndicator = false
        elemntTableView.reloadData()
        lblSilver.text = memberElement.memberName
        lblProcessing.text = "memberDetailsVC_processing".localized
        btnUpdarege.addTarget(self, action: #selector(btnUpgradePressed(_:)), for: .touchUpInside)
        btnClose.addTarget(self, action: #selector(btnClosePressed(_:)), for: .touchUpInside)
    }
    
    func bronzeStatus(){
        btnUpdarege.isHidden = true
        heightBtnUpgrade.constant = 0
        lblProcessing.isHidden = true
        lblProcessing.text = "memberDetailsVC_automatically".localized
    }
    
    func handleMEmberStatus(){
        if memberElement == .bronz{
            bronzeStatus()
            return
        }
        if memberElement == .diamond || memberElement == .green{
            btnUpdarege.isHidden = true
            heightBtnUpgrade.constant = 0
            return
        }
        let memberObject = CachingManager.memberDriverModel
           // if memberObject?.memberShip.cardType != nil{
        if memberObject?.membership?.cardType != nil {
                lblProcessing.isHidden = true
                btnUpdarege.setTitle("memberDetailsVC_upgrade".localized, for: .normal)
                //switch memberObject?.memberShip.cardType{
            switch memberObject?.membership?.cardType {
                case "فضية" :
                    btnUpdarege.isHidden = memberElement == .silver
                    heightBtnUpgrade.constant = memberElement == .silver ? 0:60
                case "ذهبية" :
                    btnUpdarege.isHidden = memberElement == .gold
                    heightBtnUpgrade.constant = memberElement == .gold ? 0:60
                case "برونزية":
                    bronzeStatus()
                case "عطاء" :
                    btnUpdarege.isHidden = memberElement == .green
                    heightBtnUpgrade.constant = memberElement == .green ? 0:60
                case "ماسية":
                    btnUpdarege.isHidden = true
                    heightBtnUpgrade.constant = 0
                default:
                    break
                }
                return
            }
            if memberObject?.applicantCode == nil{
                btnUpdarege.setTitle("memberDetailsVC_subscribe".localized, for: .normal)
                lblProcessing.isHidden = true
            }else{
                btnUpdarege.setTitle("memberDetailsVC_upgrade".localized, for: .normal)
                lblProcessing.isHidden = false
                btnUpdarege.backgroundColor = .weemGrayBorder
                btnUpdarege.setTitleColor(.darkGray, for: .normal)
                btnUpdarege.isEnabled = false
            }
        
    }
    
    @objc func btnUpgradePressed(_ btn:UIButton){
        let userVC = UserProfileVC.initializeFromStoryboard()
        userVC.isFromMemberShip = true
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    @objc func btnClosePressed(_ btn:UIButton){
        paymentDelegate?.btnClosePressed()
    }

   /*
    func createSilverArr(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 12
        var nsMutArr = [NSMutableAttributedString]()
        var firstNsString = NSMutableAttributedString(string: "• 12% Rent Discount", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• 250 KM Free", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• 50 SR travle authorization - Gulf countries Fees", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• 300 SR travle authorization - Arabic countries Fess", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• Earn 0.5 point from each 100 SR", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• Pay with Theeb points ", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• Pay with Qitaf points ", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        firstNsString = NSMutableAttributedString(string: "• Transfer Points to Alfursan", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        nsMutArr.append(firstNsString)
        
        mainArr.append(nsMutArr)
        let img = UIImage(named: "checkOK")!
        var mutArr = [NSMutableAttributedString]()
        
        var secoundNsString = "".imageToText(img: img)
        secoundNsString.append(NSAttributedString(string: " A valid ID card and driver's license"))
        secoundNsString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range:NSRange(location: 0, length: firstNsString.string.count))
        mutArr.append(secoundNsString)

        secoundNsString = "".imageToText(img: img)
        secoundNsString.append(NSAttributedString(string: " Work ID or 5000 in the bank balance"))
        secoundNsString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range:NSRange(location: 0, length: firstNsString.string.count))
        mutArr.append(secoundNsString)

        secoundNsString = "".imageToText(img: img)
        secoundNsString.append(NSAttributedString(string: " Fulfill one of the following conditions:"))
        secoundNsString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range:NSRange(location: 0, length: firstNsString.string.count))
        mutArr.append(secoundNsString)

        mainArr.append(mutArr)
    }
    */
    
    class func initializeFromStoryboard() -> MemberDetailsVC {
        
        let storyboard = UIStoryboard(name: "MemberShip", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: MemberDetailsVC.self)) as! MemberDetailsVC
    }
    
}

extension MemberDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return memberElement.mainArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberElement.mainArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberDetailCell.identifier, for: indexPath) as? MemberDetailCell else {return UITableViewCell()}
        let cellItem = memberElement.mainArr[indexPath.section][indexPath.row]
        cell.backgroundColor = .clear
        cell.lblTitle.numberOfLines = 3
        cell.lblTitle.text = cellItem.text
        cell.lblTitle.textColor = .darkGray
        cell.imgViewTitle.image = cellItem.0
        cell.isPadding = cellItem.isPadding
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
                return headerTitles[section]
            }
            return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
       // view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
}


