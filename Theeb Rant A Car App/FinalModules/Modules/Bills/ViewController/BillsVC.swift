//
//  BillsVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 23/08/1443 AH.
//

import UIKit
import Firebase
class BillsVC: BaseViewController {
    
    weak var loadingCell: BillsTableViewCell?
    
    let paymentFlag = "payment_disabled"
    
    @IBOutlet weak var hintNoBillsLabel: UILabel! {
        didSet {
            
            hintNoBillsLabel.text =  "bills_fine_hint_label".localized
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text =  "bills_all_fine_label".localized
        }
    }
    @IBOutlet weak var noBillsView: UIView! {
        didSet {
            noBillsView.isHidden = true
        }
    }
    @IBOutlet weak var statusSegmentController: UISegmentedControl! {
        didSet {
            statusSegmentController.setTitle("bills_paid_invoice".localized,
                                             forSegmentAt: 0)
            statusSegmentController.setTitle( "bills_un_paid_invoice".localized,
                                              forSegmentAt: 1)
            
        }
    }
    
  
    
    // MARK: - Outlets
    
    var timeParentView:UIView?
    var timePArentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tablevIEW: UITableView! {
        didSet {
            tablevIEW.delegate = self
            tablevIEW.dataSource = self
        }
    }
    
    lazy var viewModel =  BillsViewModel()
    var loadingPlaceholderView = LoadingPlaceholderView()
    var selectedIndex = 0
    var paymentVC: PaymentVC?

    
    
    // MARK: - View Life Cycle

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSegmentView()
       
        title = "bills_screen_title".localized
        //statusSegmentController.addUnderlineForSelectedSegment()
        CustomLoader.customLoaderObj.startAnimating()
        viewModel.getBillsHistoryJson()
        setupViewModel()
        //  setupLoader()
//        tablevIEW.startShimmerAnimation(withIdentifier: String(describing: BillsTableViewCell.self), numberOfRows: 4, numberOfSections: 4)
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // setupSegmentView()
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.Bills, screenClass: String(describing: BillsVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.Bills, screenClass: String(describing: BillsVC.self))
    }
    
    func setupLoader(){
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
        loadingPlaceholderView.cover(tablevIEW)
    }
    // MARK: - Setup ViewModel
    
    func setupViewModel() {
        
        viewModel.presentViewController = {[weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.openPDFWithURL = { [unowned self] (pdfText) in
            
            self.openPDFDocument(with: pdfText)
        }
        
        viewModel.reloadTableData = { [weak self] in
            //self?.tablevIEW.stopShimmerAnimation()
            CustomLoader.customLoaderObj.stopAnimating()
           // self?.loadingPlaceholderView.uncover()
            self?.tablevIEW.reloadData()
            
        }

        
        viewModel.showNoBookingViewWithCount = { [weak self] count in
            if count == 0 {
                self?.noBillsView.isHidden = false
            } else {
                self?.noBillsView.isHidden = true
            }
            
        }
        
    }
    
    // MARK: - intilaization
    
    class func initializeFromStoryboard() -> BillsVC  {
        
        let storyboard = UIStoryboard(name: StoryBoards.Bills, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: BillsVC.self)) as! BillsVC
    }
    
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: BillsVC.initializeFromStoryboard())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    //    setupSegmentView()
    }
    
    
    
    // MARK: - Helper Methods
    
    func setupSegmentView() {
        
        
        statusSegmentController.selectedSegmentIndex = 0
        statusSegmentController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.theebColor, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)], for: .selected)
        statusSegmentController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)], for: .normal)
    if #available(iOS 13.0, *) {
           let dividerImage = UIImage(color: .white, size: CGSize(width: 1, height: 50))
        statusSegmentController.setBackgroundImage(UIImage(named: "W1"), for: .normal, barMetrics: .default)
        statusSegmentController.setBackgroundImage(UIImage(named: "W2"), for: .selected, barMetrics: .default)
        statusSegmentController.setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        statusSegmentController.layer.cornerRadius = 0
        statusSegmentController.layer.masksToBounds = true
       }
        

    }
    
   
    
    func openPDFDocument(with pdfText: String) {
        self.hildeLoadingInisdeCell()
        // Step 1: Decode the Base64 string
            guard let pdfData = Data(base64Encoded: pdfText) else {
                print("Failed to decode Base64 string")
                return
            }
            
            // Step 2: Save the PDF data to a file
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempFileURL = tempDirectory.appendingPathComponent("temp.pdf")
            
            do {
                try pdfData.write(to: tempFileURL)
            } catch {
                print("Failed to write PDF data to file: \(error)")
                return
            }
            
            // Step 3: Open the PDF file using UIDocumentInteractionController
            let documentInteractionController = UIDocumentInteractionController(url: tempFileURL)
            documentInteractionController.delegate = self // Ensure your view controller conforms to UIDocumentInteractionControllerDelegate
            documentInteractionController.presentPreview(animated: true)
      //  UIApplication.shared.open(url)
        
    }
    
    
    
    
    
    // MARK: - Actions
    
    
    @IBAction func segmentedControllerAction(_ sender: Any) {
        if statusSegmentController.selectedSegmentIndex == 1  {
            // viewModel.clearAll()
            viewModel.filterBills()
            
        } else  if statusSegmentController.selectedSegmentIndex == 0 {
            CustomLoader.customLoaderObj.startAnimating()
            viewModel.clearAll()
            viewModel.getBillsHistoryJson()
        }
        
        selectedIndex = statusSegmentController.selectedSegmentIndex
        statusSegmentController.changeUnderlinePosition()
    }
    
    
    
    func setPaymentVc(val:String? , invoiceNumber: String? = nil , reservationNumber: String? = nil){
        let tuble = constructTimeView(onView: view,val: 0.8)
         timeParentView = tuble.0
         timePArentHeightConstraint = tuble.1
        addFadeBackground(true,  color:UIColor.black)
       paymentVC = PaymentVC.initializeFromStoryboard()
        paymentVC?.paymentDelegate = self
        paymentVC?.amount = val ?? ""
        paymentVC?.invoiceNumber = invoiceNumber ?? ""
        paymentVC?.reservationNumber = reservationNumber ?? ""
        paymentVC?.isBooking = false
        view.bringSubviewToFront(timeParentView ?? UIView())
        addChildViewController(paymentVC, onView: (timeParentView) ?? UIView())
        animateConstraint(constraint: timePArentHeightConstraint, to: 8)

    }
    
    
}

// MARK: - UITable View DataSource

extension BillsVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.invoicesJson.isEmpty {return 0}
        return viewModel.numberOfInvoicess() ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BillsTableViewCell.self), for: indexPath) as! BillsTableViewCell
        cell.delegate = self
        if viewModel.invoicesJson.isEmpty {return cell}
        
        let invoice = viewModel.invoice(atIndex: indexPath.row)
        cell.showInvoice(invoice, isUnpaid: (selectedIndex == 1))
        
        cell.viewDetailsAction = {  [weak self] in
            
            self?.viewModel.selectedRentalItem(index: indexPath.row, isInvoicePaid: (self?.selectedIndex == 0))
            
        }
        
        cell.shareButtonAction = { [weak self] in
            
            self?.showLoadingInCell(cell)
            self?.viewModel.downloadInvoice(reservationNo: invoice?.invoiceNo, mode: "I", recieptAgreementNo: "", recieptInvoiceNumber: invoice?.invoiceNo)
            
        }
        
        cell.payNowAction = { [weak self] in
            if !(self?.checkPaymentIsDisable() ?? false) {
                self?.setPaymentVc(val: invoice?.invoiceBalance, invoiceNumber:invoice?.invoiceNo , reservationNumber: "")
            }
        }
        
        
        return cell
        
        
        
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if statusSegmentController.selectedSegmentIndex == 0 {
          

            return 310
            
        } else {
         
            return 380
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectedRentalItem(index: indexPath.row, isInvoicePaid: (selectedIndex == 0))
        
    }
    
}

extension BillsVC: BillsTableViewCellDelegate {
    
    
    func showLoadingInCell(_ cell: BillsTableViewCell) {
        loadingCell = cell
        cell.shareBtn.showLoading()
    }
    
    func hildeLoadingInisdeCell() {
        loadingCell?.shareBtn.hideLoading()
    }
    
    
    
}

// MARK: - UITable View Delegate

extension BillsVC : UITableViewDelegate {}



extension BillsVC:PaymentDelegate{
    func btnClosePressed() {
        if let paymentVC = paymentVC {
            addFadeBackground(false, color: nil)
            removeChildVC(mainVc: paymentVC)
            timeParentView?.removeFromSuperview()
        }
        setupScreenAfterPayment()
    }
    
    func setupScreenAfterPayment(){
        statusSegmentController.selectedSegmentIndex = 0
        viewModel.clearAll()
        viewModel.getBillsHistoryJson()
        CustomLoader.customLoaderObj.startAnimating()
    }
    
}

extension BillsVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
