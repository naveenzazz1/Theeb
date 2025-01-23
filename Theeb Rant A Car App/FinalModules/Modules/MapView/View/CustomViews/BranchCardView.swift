//
//  BranchCardView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 04/04/2022.
//

import UIKit

protocol BranchCardViewDelegate{
    func sendLangAndLat(name:String?,lat:String?,lang:String?)
}

class BranchCardView:UIView{
    
    //vars
    var location: Branch?
    var viewModel = BranchesLocationsViewModel()
    var delegate:BranchCardViewDelegate?
    let isArabic = UIApplication.isRTL()


    //outlets
    @IBOutlet weak var stackViewPhone: UIStackView!
    @IBOutlet weak var stackViewMobile: UIStackView!
    @IBOutlet weak var btnMapLocation: UIButton!
    @IBOutlet weak var lblBranchTiltle: UILabel!
    @IBOutlet weak var lblStaticPhone: UILabel!
    @IBOutlet weak var lblStaticWorkingHour: UILabel!
    @IBOutlet weak var lblTimeAway: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblFriday: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFromDays: UILabel!
    @IBOutlet weak var lblFax: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var btnGetDirections: UIButton!
    @IBOutlet weak var lblPhone: UILabel!

    @IBOutlet weak var lblStaticFax: UILabel!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialSetup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    func initialSetup() {
        addSubview(loadXibView(with: bounds))
        lblStaticPhone.text = "checkOutVC_phone".localized
        lblStaticWorkingHour.text = "mapLocation_workingHour".localized
        lblStaticFax.text = "mapLocation_Fax".localized
        lblFromDays.text = "more_BranchDays".localized
       // lblTime.text = "more_BranchTime".localized
       // lblFriday.text = "more_BranchFriday".localized
        [btnGetDirections,btnMapLocation].forEach{
            $0.addTarget(self, action: #selector(btnMapPressed), for: .touchUpInside)
        }
        btnGetDirections.setTitle("more_GetDirections".localized, for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        [stackViewPhone,stackViewMobile].forEach{
          $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func handleTapGesture(){
        if let location = location ,
           let telText = location.telephone1 ?? location.telephone ,
           let url = URL(string: "tel://\(telText)"),
            UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
        }
    }
    
    @objc func btnMapPressed(){
        delegate?.sendLangAndLat(name: isArabic ? location?.branchNameTranslated:location?.branchName, lat: location?.branchLat, lang: location?.branchLong)
        
    }
    
    func fillViews(){
        if let location = location {
            lblBranchTiltle.text = isArabic ? location.branchName:location.branchNameTranslated//reversed data from backend
            lblFax.text = location.fax
            lblPhone.text = location.telephone
            lblMobile.text = location.telephone1
            lblDistance.text = location.distance
            lblTimeAway.text = location.time
            
            if let schaduleArr = location.schedule{
                let scadule = getTwoDaysTiming(scaduleArr: schaduleArr)
                if !scadule.isEmpty{
                lblTime.text = "("+"\(scadule["Sunday"]?.startTime ?? "") " + "profile_to".localized + " \(scadule["Sunday"]?.endTime ?? "")"+")"
                lblFriday.text = "\("more_BranchFriday".localized) ("+"\(scadule["Friday"]?.startTime ?? "") " + "profile_to".localized + " \(scadule["Friday"]?.endTime ?? "")"+")"
                }
            }
        }
    }
    

    func getTwoDaysTiming(scaduleArr:[ScheduleModel]?)->[String:ScheduleModel]{
        var schaduleDir = [String:ScheduleModel]()
        guard let scaduleArr = scaduleArr else {return schaduleDir}
        for i in scaduleArr.indices{
            if scaduleArr[i].dayCode ?? 1 == 7 {//Sunday
                schaduleDir["Sunday"] = scaduleArr[i]
            }
            if scaduleArr[i].dayCode ?? 1 == 6{
                schaduleDir["Friday"] = scaduleArr[i]
            }
        }
        return schaduleDir
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.height/16
    }
}
