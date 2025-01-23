//
//  TwoTextFieldsView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 12/04/2022.
//

import UIKit

class TwoTextFieldsView:UIView{
    
    //vars
    var superVC:UIViewController?
    static var normalHeight:CGFloat = 0
    static var expandableHeight:CGFloat = 0
    var isSelected = false{
        didSet{
            toggleview()
            if !isSelected {
                HomeVC.branchStateTuble.returnBranch = nil
                txtFieldReturn.setTextFieldAttributedPlaceholder( "mapLocation_selectTReturnLocation".localized)
                txtFieldReturn.text = ""
                btnClearReturn.isHidden = !isSelected
            }
        }
    }
    var headerViewHeigh: NSLayoutConstraint?
    
    //txtfield didselect and button return action
    let isArabic = UIApplication.isRTL()
    var pickUpTxtFieldDidSelect:((String, Int, Int) -> Void)?
    var returnTxtFieldDidSelect:((String, Int, Int) -> Void)?
    var complitionBtnReturn:((UIButton)->Void)?
    
    
    //outlets
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var returnDifferentView: UIView!
    @IBOutlet weak var btnClearReturn: UIButton!
    @IBOutlet weak var btnClearPickup: UIButton!
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var lblstaticReturn: UILabel!
    @IBOutlet weak var txtFieldReturn: DropDown!{
        didSet {
            handleDropDownReturn()
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtFieldPickup: DropDown!{
        didSet{
            handlePickUpDidSet()
        }
    }
    @IBOutlet weak var imgRetrn: UIImageView!
    @IBOutlet weak var imgLine22: UIImageView!
    @IBOutlet weak var viewLine: UIView!
    
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
        btnReturn.addTarget(self, action: #selector(btnReturnPressed(_:)), for: .touchUpInside)
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.weemGrayBorder.cgColor
        containerView.layer.borderWidth = 0.5
        
        [txtFieldReturn,txtFieldPickup].forEach{
           // $0?.delegate = self
            $0?.beginEditingCompletion = {[weak self] isShow in
                self?.showORHideStackView(show:isShow)
            }
            $0?.isSearchEnable = true
        }
        [txtFieldReturn,imgRetrn,viewLine,imgLine22].forEach {
            $0?.isHidden = !isSelected
        }

    }
    
    func toggleview(){
        [txtFieldReturn,imgRetrn,viewLine,imgLine22].forEach {
            $0?.isHidden = !isSelected
        }
       // let viewHeight = superVC?.view.frame.height ?? 120
        if let headerViewHeigh = headerViewHeigh{
            headerViewHeigh.constant = isSelected ? Self.expandableHeight:Self.normalHeight
        }

        centerConstraint.priority = isSelected ? UILayoutPriority(250):UILayoutPriority(1000)
        let img = UIImage(named: isSelected ? "Checkbox1":"UnCheckbox")
        btnReturn.setImage(img, for: .normal)
    }
    
    func handleDropDownReturn(){
        txtFieldReturn.setTextFieldAttributedPlaceholder( "mapLocation_selectTReturnLocation".localized)
        txtFieldReturn.arrow.isHidden = true
        txtFieldReturn.isSearchEnable = true
        txtFieldReturn.setRightPaddingPoints(16, view: nil)
      
        if let locations =  CachingManager.locations() {
            self.txtFieldReturn.optionArray = locations.map({ return (isArabic ? $0?.branchName:$0?.branchNameTranslated) ?? ""})
        }
      //  txtFieldReturn.delegate = superVC as? UITextFieldDelegate
        txtFieldReturn.selectedRowColor = .clear
        txtFieldReturn.didSelect {  [weak self] (text, index, id) in
            self?.returnTxtFieldDidSelect?(text, index, id)
            self?.btnClearReturn.isHidden = false
            self?.txtFieldReturn.setTextFieldAttributedPlaceholder("")

        }
    }
    
    func hideTextFieldLists(){
        [txtFieldPickup,txtFieldReturn].forEach{
            $0?.hideList()
        }
    }
    
    func handlePickUpDidSet(){
        
        txtFieldPickup.setRightPaddingPoints(20, view: nil)
        txtFieldPickup.arrow.isHidden = true
        txtFieldPickup.isSearchEnable = true
        txtFieldPickup.setTextFieldAttributedPlaceholder( "mapLocation_selectPickLocation".localized)
        if let locations =  CachingManager.locations() {
            
            self.txtFieldPickup.optionArray = locations.map({ return (isArabic ? $0?.branchName:$0?.branchNameTranslated) ?? ""})
            
            
        }
//        txtFieldPickup.delegate  = self
      //  txtFieldPickup.delegate = superVC as? UITextFieldDelegate
        txtFieldPickup.selectedRowColor = .clear
        txtFieldPickup.didSelect {  [weak self] (text, index, id) in
            self?.pickUpTxtFieldDidSelect?(text, index, id)
            self?.btnClearPickup.isHidden = false
            self?.txtFieldPickup.setTextFieldAttributedPlaceholder("")
//            self?.viewModel.setPickupBranchId(withIndex: index)
//            self?.chooseLocationView.isHidden = false
//            self?.branchNameLabel.text = text
//            self?.stackContainers.isHidden = false
        }
        //txtFieldPickup.placeholder  = "mapLocation_pickUp".localized
        
    }
    
    
    
    @objc func btnReturnPressed(_ btn:UIButton){
        complitionBtnReturn?(btn)
    }
    
    func showORHideStackView(show:Bool){
        if let superVC = superVC as? BranchesLocationsVC{
            superVC.stackContainers.isHidden = !show
        }
    }
    
    @IBAction func btnClearPickeupPressed(_ sender: UIButton) {
        let isPickup = (sender == btnClearPickup)
        if isPickup {
            txtFieldPickup.text = ""
            txtFieldPickup.setTextFieldAttributedPlaceholder( "mapLocation_selectPickLocation".localized)
            if let superVC = superVC as? BranchesLocationsVC {
                superVC.chooseLocationView.isHidden = true
            }
        }else{
            txtFieldReturn.setTextFieldAttributedPlaceholder( "mapLocation_selectTReturnLocation".localized)
            txtFieldReturn.text = ""
        }
        sender.isHidden = true
    }
    
}

//extension TwoTextFieldsView:UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//         self.superVC?.view.endEditing(true)
//           return false
//       }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return false
//    }
//
//}
