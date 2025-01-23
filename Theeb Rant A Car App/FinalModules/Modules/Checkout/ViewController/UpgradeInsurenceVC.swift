//
//  UpgradeInsurenceVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 09/06/2022.
//

import UIKit

protocol UpgradeInsurenceDelegate{
  func btnClosePressed()
    func upgradeBtnAction(_ selectedInsurance: String?, insurancCode: String?, selectedInsuranceObject: InsType?)
}

class UpgradeInsurenceVC: UIViewController {

    @IBOutlet weak var insurenceTableView: UITableView!
    @IBOutlet weak var insuranceTitleLabel: UILabel! {
        didSet{
            insuranceTitleLabel.text = "fleet_insurance".localized
        }
    }
    
    @IBOutlet weak var upgradeBtn: UIButton! {
        didSet {
            upgradeBtn.setTitle("checkout_upgrade_btn_title".localized, for: .normal)
        }
    }

    var delegate:UpgradeInsurenceDelegate?
    var selectedInsurence:InsType?
    let isArabic = UIApplication.isRTL()
    var insurancesArr = [InsType]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(dismissGesture)
        handleViews()
    }
    
    class func initializeFromStoryboard() -> UpgradeInsurenceVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Checkout, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: UpgradeInsurenceVC.self)) as! UpgradeInsurenceVC
    }
    
    func handleViews(){
        insurenceTableView.delegate = self
        insurenceTableView.dataSource = self
        let albumNib = UINib(nibName: "InsurenceCell", bundle: nil)
        insurenceTableView.register(albumNib, forCellReuseIdentifier: InsurenceCell.identifier)
        insurenceTableView .reloadData()
    }

    @IBAction func btnClosePressed(_ sender: UIButton) {
      
        delegate?.btnClosePressed()
    }
    
    
    @IBAction func upgradeBtnAction(_ sender: Any) {
        delegate?.upgradeBtnAction(isArabic ? selectedInsurence?.desc:selectedInsurence?.nameTranslated, insurancCode: selectedInsurence?.code, selectedInsuranceObject: selectedInsurence)
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        var initialTouchPoint = CGPoint.zero

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
                delegate?.btnClosePressed()
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        @unknown default:
            break
        }
        
    }
    
    
}

extension UpgradeInsurenceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insurancesArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InsurenceCell.self), for: indexPath) as? InsurenceCell
        let insurence = insurancesArr[indexPath.row]
        cell?.selectionStyle = .none
        cell?.setupCell(insurence: insurence, isRecomend: insurence.code == "SCDW", isSelect: insurence == selectedInsurence)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let insurenceCode = insurancesArr[indexPath.row].code
            let viewHeight = view.frame.height
            return insurenceCode == "SCDW" ? viewHeight/5 : viewHeight/7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInsurence = insurancesArr[indexPath.row]
        insurenceTableView.deselectRow(at: indexPath, animated: false)
        insurenceTableView.reloadData()
    }
}
