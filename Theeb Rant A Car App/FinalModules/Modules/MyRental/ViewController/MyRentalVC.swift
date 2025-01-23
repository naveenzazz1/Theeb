//
//  MyRentalVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/07/1443 AH.
//

import UIKit
import AlamofireImage
import Firebase
class MyRentalVC : UIViewController {
    
    let paymentFlag = "payment_disabled"
    
    @IBOutlet weak var bookNowNoBookingsTitleLabel: UIButton! {
        didSet {
            bookNowNoBookingsTitleLabel.setTitle("checkOutVC_bookow" .localized,for: .normal)
        }
     
    }
    @IBOutlet weak var hintNoRentedCarsTitleLabel: UILabel! {
        didSet {
            hintNoRentedCarsTitleLabel.text =  "myrental_no_bboking_hint_label".localized
        }
    }
    @IBOutlet weak var norentedCarsTitleLabel: UILabel! {
        didSet {
            norentedCarsTitleLabel.text =  "myrental_no_bookings_empty" .localized
        }
    }
    // MARK: - Outlets
    @IBOutlet weak var noAvailableCarsView: UIView! {
        didSet  {
            noAvailableCarsView.isHidden = true
        }
    }
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var contractsBtn: UIButton!
    @IBOutlet weak var upaidBillsBtn: UIButton!
    @IBOutlet weak var bookingsBtn: UIButton!
    @IBOutlet weak var rentalTableView: UITableView! {
        didSet  {
          //  rentalTableView.isHidden = true
            addGestures()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var topSegmentedController: UISegmentedControl! {
        didSet {
            topSegmentedController.setTitle("rental_all".localized,
                                         forSegmentAt: 0)
            topSegmentedController.setTitle( "rental_Booking".localized,
                                         forSegmentAt: 1)
            topSegmentedController.setTitle("profile_item_contracts".localized,
                                         forSegmentAt: 2)
            topSegmentedController.setTitle("rental_invoice".localized,
                                         forSegmentAt: 3)
         
        }
    }
    // MARK: - Outlets
    var isFinished = false
    lazy var viewModel = GetRentalHistoryViewModel()
    var timeParentView:UIView?
    var timePArentHeightConstraint: NSLayoutConstraint!
    var paymentVC: PaymentVC?
    var selectedSgmntIndex = 0
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
  
        super.viewDidLoad()

        setupSegmentView()
        titleLabel.text = "landing_page_my_booking_item".localized
        if CachingManager.loginObject()?.driverCode == nil || CachingManager.loginObject()?.driverCode == ""  {
            self.rentalTableView.isHidden = true

        } else {
            setupSegmentView()
            // viewModel.getReservationHistory()
            setupViewModel()
            viewModel.rentalCase = .all(val: nil)
            viewModel.getAllMyRentalData()
            
            rentalTableView.startShimmerAnimation(withIdentifier: String(describing: BookingHistoryTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
        }
    
        
        
    }
    
 

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//         setupSegmentView()
//        viewModel.rentalCase = .all(val: nil)
//        semulateSegmntAction(index: selectedSgmntIndex)
//        navigationController?.applyGrayNavigationBar()
//
//
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.MyRentals, screenClass: String(describing: MyRentalVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.MyRentals, screenClass: String(describing: MyRentalVC.self))
        semulateSegmntAction(index: 0)
        navigationController?.applyGrayNavigationBar()
    }
    
    

    
 
    // MARK: - Helper Methods
    
    func setupSegmentView() {
        
        topSegmentedController.selectedSegmentIndex = 0
        topSegmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.theebColor, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)], for: .selected)
        topSegmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)], for: .normal)
    if #available(iOS 13.0, *) {
           let dividerImage = UIImage(color: .white, size: CGSize(width: 1, height: 50))
        topSegmentedController.setBackgroundImage(UIImage(named: "W1"), for: .normal, barMetrics: .default)
        topSegmentedController.setBackgroundImage(UIImage(named: "W2"), for: .selected, barMetrics: .default)
        topSegmentedController.setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        topSegmentedController.layer.cornerRadius = 0
        topSegmentedController.layer.masksToBounds = true
       }
        
    
   }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //  navigationController?.applyGrayNavigationBar()
        // navigationController?.applyTransparentNavigationBar()
        
        navigationController?.applyGrayNavigationBar()
    }
    
    func addGestures(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        rentalTableView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        rentalTableView.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
            switch swipeGesture.direction {
            case .right:
                if selectedSgmntIndex == topSegmentedController.numberOfSegments - 1 {
                    return
                }
                selectedSgmntIndex += 1
                print(selectedSgmntIndex)
                
            case .left:
                if selectedSgmntIndex == 0 {
                    return
                }
                selectedSgmntIndex -= 1
                print(selectedSgmntIndex)

            default:
                break
            }
            
            semulateSegmntAction(index: selectedSgmntIndex)
            topSegmentedController.selectedSegmentIndex = selectedSgmntIndex
        }
    }
    
    //MARK: - Initialization
    
    class func initializeFromStoryboard() -> MyRentalVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.MyRentalHistory, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: MyRentalVC.self)) as! MyRentalVC
    }
    
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: MyRentalVC.initializeFromStoryboard())
    }
    
    
    // MARK: - Setup ViewModel
    
    func setupViewModel() {
        rentalTableView.isHidden = false
        viewModel.presentViewController = {[weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.reloadTableData = { [weak self] in
            self?.rentalTableView.isHidden = false
            self?.rentalTableView.stopShimmerAnimation()
            self?.isFinished = true
            let countedArr = self?.viewModel.getAll()
            self?.noAvailableCarsView.isHidden = (countedArr != 0)
            self?.rentalTableView.reloadData()
            
        }
        
        viewModel.showNoBookingViewWithCount = { [weak self] count in
            var isHide = true
            self?.view.bringSubviewToFront(self?.noAvailableCarsView ?? UIView())
            switch self?.viewModel.rentalCase{
//            case .all(val: nil):
//                let countedArr = self?.viewModel.getAll()
//                isHide = (countedArr != 0)
//                self?.noAvailableCarsView.isHidden = isHide
            case .booking(val: _):
                isHide = (self?.viewModel.numberOfBookings() != 0)
                self?.noAvailableCarsView.isHidden = isHide
            case .unpaid(val: _):
                isHide = (self?.viewModel.numberOfInvoices() != 0)
                self?.noAvailableCarsView.isHidden = isHide
            case .contracts(val: _):
                isHide = (self?.viewModel.numberOfContracts() != 0)
                self?.noAvailableCarsView.isHidden = isHide
            default:
                self?.noAvailableCarsView.isHidden = isHide
            }
            if isHide{
                self?.view.bringSubviewToFront(self?.noAvailableCarsView ?? UIView())
            }
        }
    }
    
    
    func makeBtnSelected(_ button : UIButton?) {
        
        button?.isSelected  = true
        button?.backgroundColor = .theebPrimaryColor
        button?.tintColor = .theebPrimaryColor
        button?.setTitleColor(.white, for: .selected)
        
        
    }
    
    func makeBtnUnSelected(_ button : UIButton?) {
        
        button?.isSelected  = false
        button?.backgroundColor = .white
        button?.setTitleColor(.weemDarkGray, for: .normal)
        
        
    }
    
    
    
    func setPaymentVc(val:String? , invoiceNumber: String? = nil , reservationNumber: String? = nil, pickupDateString: String?, returnDateString: String?){
        let tuble = constructTimeView(onView: view,val: 0.8)
         timeParentView = tuble.0
         timePArentHeightConstraint = tuble.1
        addFadeBackground(true,  color:UIColor.black)
        paymentVC = PaymentVC.initializeFromStoryboard()
        paymentVC?.paymentDelegate = self
        paymentVC?.amount = val ?? ""
        paymentVC?.invoiceNumber = invoiceNumber ?? ""
        if let pickupDate = DateUtils.dateFromString(returnDateString),
           let returnDate = DateUtils.dateFromString(pickupDateString) {
            let interval = pickupDate.timeIntervalSince(returnDate)
            let differenceInDays = Int(interval / (24 * 60 * 60)) // Convert seconds to days
            paymentVC?.numberOfDays = differenceInDays
            paymentVC?.isBooking = (invoiceNumber == "") ? true : false
        } else {
            print("Invalid date string") // Handle invalid date strings or nil values
        }
        
        
        paymentVC?.reservationNumber = reservationNumber ?? ""
        view.bringSubviewToFront(timeParentView ?? UIView())
        addChildViewController(paymentVC, onView: (timeParentView) ?? UIView())
        animateConstraint(constraint: timePArentHeightConstraint, to: 8)
    }

    
    // MARK: - Helper Methods
    
    func handleNumberOfRows() -> Int? {
        
        
        if topSegmentedController.selectedSegmentIndex == 2 {
            return viewModel.numberOfContracts() ?? 0
            
        } else if topSegmentedController.selectedSegmentIndex == 1  {
            
            return viewModel.numberOfBookings() ?? 0
            
        } else  if topSegmentedController.selectedSegmentIndex == 3 {
            
            
            return  viewModel.numberOfInvoices() ?? 0
            
        } else {
            
            return  viewModel.getAll() ?? 0
            
        }
        
    }
    
       // MARK: - Actions
    
    func semulateSegmntAction(index:Int){
        noAvailableCarsView.isHidden = true
        view.sendSubviewToBack(noAvailableCarsView)
        //tableView.isHidden = true
        if index == 0 {
            
            viewModel.clearAll()
            viewModel.rentalCase = .all(val: nil)
            viewModel.getAllMyRentalData()
            
            rentalTableView.startShimmerAnimation(withIdentifier: String(describing: BookingHistoryTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
            
            
        }else if index == 1 {
            viewModel.clearAll()
            viewModel.rentalCase = .booking(val: nil)
            
        viewModel.getReservationHistoryJson()
            viewModel.dispatchGroupNotify()
            rentalTableView.startShimmerAnimation(withIdentifier: String(describing: BookingHistoryTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
            
        } else if index == 2 {
            viewModel.clearAll()
            viewModel.rentalCase = .contracts(val: nil)
            viewModel.getInvoicesPaymentAgreementJson(withTransaction: TransactionsType.Agreements, type: AgreementRentalModal.self)
            viewModel.dispatchGroupNotify()
            rentalTableView.startShimmerAnimation(withIdentifier: String(describing: BookingHistoryTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
        } else  {
            viewModel.clearAll()
            viewModel.rentalCase = .unpaid(val: nil)
            viewModel.getInvoicesPaymentAgreementJson(withTransaction: TransactionsType.Invoices, type: InvoicesRentalHistoryModelJson.self)
            viewModel.dispatchGroupNotify()
            rentalTableView.startShimmerAnimation(withIdentifier: String(describing: BookingHistoryTableViewCell.self), numberOfRows: 8, numberOfSections: 1)
            
        }
    }
    @IBAction func topSegmentAction(_ sender: Any) {
        selectedSgmntIndex = topSegmentedController.selectedSegmentIndex
        semulateSegmntAction(index: topSegmentedController.selectedSegmentIndex)
    }
    
    @IBAction func bookNowNoBookingBtnAction(_ sender: Any) {
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController =  LandingPageVC.initializeWithNavigationController()
    }
    
    
    
}





//MARK: UITableViwDataSource

extension MyRentalVC : UITableViewDataSource,UITableViewDelegate {
    
    func checkPaymentIsDisable() -> Bool {
        var result = false
        let remoteConfig = RemoteConfig.remoteConfig()
        if let paymentRequiredDic = remoteConfig[paymentFlag].jsonValue as? [String : AnyObject] {
            if  let is_Disabled = paymentRequiredDic["is_disabled"] as? Bool {
                if is_Disabled {
                    let msg = (UIApplication.isRTL()) ? paymentRequiredDic["disabled_message_ar"] as? String : paymentRequiredDic["disabled_message_en"] as? String
                    let title = (UIApplication.isRTL()) ? paymentRequiredDic["disabled_title_ar"] as? String : paymentRequiredDic["disabled_title_en"] as? String
                    result = true
                    alertUser(title: title ?? "", msg: msg ?? "")
                   // alertUser(title: title ?? "maintenace_alert_title".localized, msg: msg ?? "maintenace_alert_msg".localized)
                }
            }
        }
        return result
    }
    
    private func alertUser(title: String, msg: String){
        CustomAlertController.initialization().showAlertWithOkButton(title: title ,message: msg) { (index, title) in
             print(index,title,msg)
        }
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        handleNumberOfRows() ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookingHistoryTableViewCell.self), for: indexPath) as! BookingHistoryTableViewCell
        cell.hintVatLabel.isHidden = !isFinished
       

        
        if topSegmentedController.selectedSegmentIndex == 2 {
            
            let contract = viewModel.contract(atIndex: indexPath.row)
            
            
            let imageUrl = viewModel.getCarImageFromContracts(contract?.agreementChargeGroup)
            if let fileUrl = URL(string: NetworkConfigration.imageURL + (imageUrl ?? "") + ".jpg"){
                cell.carImageView.af.setImage(withURL: fileUrl)
                // cell.carImageView.setImageFromBase64(base64String:imageUrl)
                
            }
            
            cell.showContact(contract)
            
            cell.viewDetailsAction = { [weak self] in
                
                self?.viewModel.selectedRentalItem(index: indexPath.row,img: cell.carImageView.image)
               
                
            }
            return cell
            
        } else if  topSegmentedController.selectedSegmentIndex == 1 {
            
            let booking = viewModel.booking(atIndex: indexPath.row)
            let rentalTotalAmount = Double(booking?.totalWithTax  ?? "") ?? 0
            let rentalPaidAmount =  Double(booking?.totalPaid  ?? "") ?? 0
            let remainingAmount = rentalTotalAmount - rentalPaidAmount
            cell.payNowAction = { [weak self] in

                if !(self?.checkPaymentIsDisable() ?? false) {
                    self?.setPaymentVc(val:"\(remainingAmount.roundedToTwoDecimalPlaces())", invoiceNumber: "", reservationNumber: booking?.reservationNo ?? "", pickupDateString: booking?.checkOutDate, returnDateString: booking?.checkInDate)
                    self?.paymentVC?.isBooking = true
                }
            }
            
            
            cell.showBooking(booking, status: booking?.reservationStatus)
            cell.viewDetailsAction = { [weak self] in
                
                self?.viewModel.selectedRentalItem(index: indexPath.row,img: cell.carImageView.image)
               
                
            }
            return cell
        } else  {
            
            
            let rentalItem = viewModel.convetAllToRentalItem()?[indexPath.row]
            
            let rentalTotalAmount = Double(rentalItem?.totalAmount  ?? "") ?? 0
            let rentalPaidAmount =  Double(rentalItem?.totalPaid  ?? "") ?? 0
            let remainingAmount = rentalTotalAmount - rentalPaidAmount
            
            if rentalItem?.isBooking == true {
                cell.payNowAction = { [weak self] in
                    if !(self?.checkPaymentIsDisable() ?? false) {
                        self?.setPaymentVc(val: "\(remainingAmount.roundedToTwoDecimalPlaces())", invoiceNumber: "" , reservationNumber: rentalItem?.reservationNumber, pickupDateString: rentalItem?.pickupDate, returnDateString: rentalItem?.returnDate)
                    }
                 
                }
            } else {
                cell.payNowAction = { [weak self] in
                    if !(self?.checkPaymentIsDisable() ?? false) {
                        let totalInvoice = Double(rentalItem?.totalInvoice ?? "") ?? 0
                        let totalPaidInvoice = Double(rentalItem?.totalPaidInvoice ?? "") ?? 0
                        
                        let amountTopay = totalInvoice - totalPaidInvoice
                        
                        self?.setPaymentVc(val: amountTopay.description, invoiceNumber:rentalItem?.invoiceNumber , reservationNumber: "", pickupDateString: rentalItem?.pickupDate, returnDateString: rentalItem?.returnDate)
                    }
                }
            }
          
            
            cell.showRentalItem(rentalItem: rentalItem)
            
            
            cell.viewDetailsAction = { [weak self] in
                
                self?.viewModel.selectedRentalItem(index: indexPath.row,img: cell.carImageView.image)
               
                
            }
            return cell
        }
        
        
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? BookingHistoryTableViewCell
        let img = cell?.carImageView.image
        viewModel.selectedRentalItem(index: indexPath.row,img: img)
    }
    
   
}

extension MyRentalVC:PaymentDelegate{
    func btnClosePressed() {
        if let paymentVC = paymentVC{
            addFadeBackground(false, color: nil)
            removeChildVC(mainVc: paymentVC)
            timeParentView?.removeFromSuperview()
        }
        setupScreenAfterPayment()
    }
    
    func setupScreenAfterPayment(){
        topSegmentedController.selectedSegmentIndex = 0
        semulateSegmntAction(index: 0)
    }
}
