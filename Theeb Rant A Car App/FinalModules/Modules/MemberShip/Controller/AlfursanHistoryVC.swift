//
//  AlfursanHistoryVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 25/04/2024.
//

import UIKit

class AlfursanHistoryVC: BaseViewController {

    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblStaticTheebPoints: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var memberShipLbl: UILabel!
    @IBOutlet weak var staticAlfursanLbl: UILabel!
    @IBOutlet weak var staticTransferTheebPoint: UILabel!
    @IBOutlet weak var btnTransfeer: UIButton!
    @IBOutlet weak var staticAlforsanTransferrLbl: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    var loyaltyTransactions = [LoyaltyConversionTransactions]() {
        didSet{
            historyTableView.reloadData()
        }
    }
    var pointsStr = ""
    var membershipStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTableView()
        setupViews()
        Task{
            await getTokenAndfillDate()
        }
    }
    

    func handleTableView(){
        title = "memberShipVc_Theeb_Points".localized
        historyTableView.delegate = self
        historyTableView.dataSource = self
        let albumNib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        historyTableView.register(albumNib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.tableFooterView = UIView()
    }
    
    func setupViews() {
        pointLbl.text = pointsStr
        memberShipLbl.text = "memberShipVc_Theeb_Points".localized
        btnTransfeer.setTitle("memberShipVc_Transfeer_Point_Btn".localized, for: .normal)
        btnTransfeer.layer.cornerRadius = 8
        btnTransfeer.addTarget(self, action: #selector(pushAlforsanVc), for: .touchUpInside)
        staticTransferTheebPoint.text = "memberShipVc_Transfer_Theep".localized
        staticAlfursanLbl.text = "alforsan_transfeerPoints".localized
        lblStaticTheebPoints.text = "memberShipVc_Theeb_Points".localized
        staticAlforsanTransferrLbl.text = "memberShipVc_History_Theep".localized
        lblBalance.text = LoyalityModel.getPointsRate(isFullString: false)
    }
    
    func setMEmberShipData(memberShipType:String, pointsNum:String) {
        pointsStr = pointsNum
        membershipStr = memberShipType
    }
    
    @objc func pushAlforsanVc(){
        let userStoryBoard = UIStoryboard(name: "MemberShip", bundle: nil)
        guard let navVc = userStoryBoard.instantiateViewController(withIdentifier: "AlforsanVC") as? AlforsanVC else {return}
        navigationController?.pushViewController(navVc, animated: true)
    }
    
    class func initializeFromStoryboard() -> AlfursanHistoryVC {
        let storyboard = UIStoryboard(name: "MemberShip", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: AlfursanHistoryVC.self)) as! AlfursanHistoryVC
    }
    
    private func alertUser(msg:String){
        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
     }
    
    func getTokenAndfillDate() async {
        CustomLoader.customLoaderObj.startAnimating()
        let accessResult = await AlfursanService.instance.getAlfursanAccesTokenasync()
        switch accessResult {
        case .success(let tokenModel):
            await fillDate(accessToken: tokenModel.accessToken)
        case.failure(let err):
            CustomLoader.customLoaderObj.stopAnimating()
            alertUser(msg: err.localizedDescription)
        }
        
    }
    
    func fillDate(accessToken: String?) async {
        guard let accessToken = accessToken, let loginObject = CachingManager.loginObject() else {
            CustomLoader.customLoaderObj.stopAnimating()
            alertUser(msg: "error_Occured_msg".localized)
            return
        }
        let historyResult = await AlfursanService.instance.getElforsanHistory(accessToken: accessToken, lastName: loginObject.lastName, licenseIdNo: loginObject.licenseNo ?? "", mobileNumber: loginObject.mobileNo ?? "", passportNumber: loginObject.iDNo ?? "", email: loginObject.email ?? "", fromDate: "", toDate: "")
        
        switch historyResult {
        case .success(let model):
            sortTransactionArray(arr: model.loyaltyConversionTransactions ?? [LoyaltyConversionTransactions]())
            CustomLoader.customLoaderObj.stopAnimating()
        case .failure(let err):
            CustomLoader.customLoaderObj.stopAnimating()
            alertUser(msg: err.localizedDescription)
        }
    }
    
    func sortTransactionArray(arr: [LoyaltyConversionTransactions]) {
        loyaltyTransactions = arr.sorted { firstLoyaltyTransaction, secoundLoyaltyTransaction in
            let firstDate = DateUtils.dateFromString(firstLoyaltyTransaction.requestDate, format: "yyyyMMdd") ?? Date()
            let secoundDate = DateUtils.dateFromString(secoundLoyaltyTransaction.requestDate, format: "yyyyMMdd") ?? Date()
            return firstDate > secoundDate
        }
    }
}

extension AlfursanHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loyaltyTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {return UITableViewCell()}
        cell.setupCell(transaction: loyaltyTransactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as? HistoryTableViewCell
        cell?.setHeader()
        return loyaltyTransactions.isEmpty ? nil:cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return loyaltyTransactions.isEmpty ? "no_transaction_err".localized:nil
    }
}
