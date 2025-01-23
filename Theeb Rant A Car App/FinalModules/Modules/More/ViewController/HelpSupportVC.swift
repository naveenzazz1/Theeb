//
//  HelpSupportVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/08/1443 AH.
//

import UIKit

class HelpSupportVC: BaseViewController {


    @IBOutlet weak var contactWithourTeamLabel: UILabel! {
        didSet {
            contactWithourTeamLabel.text = "help_support_contact_with_team" .localized
        }
    }
    @IBOutlet weak var needourHelpLabel: UILabel! {
        didSet {
            needourHelpLabel.text = "help_suppot_nedd_help".localized
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    
    // MARK: -View Life Cycle
    lazy var viewModel = HelpandSupportViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setupViewModel()
        title = "more_helpandsupport_title".localized
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // navigationController?.applyGrayNavigationBar()
  
        viewModel.setupUserItems()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.HelpAndSupport, screenClass: String(describing: HelpSupportVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.HelpAndSupport, screenClass: String(describing: HelpSupportVC.self))
    }
    
    
    // MARK: - Setup
    
    func setupViewModel() {
        
        viewModel.navigateToViewController = { [unowned self] (vc) in
            
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
              
        }
        
        viewModel.dismiss = { [unowned self] in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        viewModel.pushViewController = { [weak self] (vc) in
            
          
            UIApplication.topViewController()?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        
        }
    }
    
    
    
  
    
    
    // MARK: -Intialization
    
    
    class func initializeFromStoryboard() -> HelpSupportVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.More, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: HelpSupportVC.self)) as! HelpSupportVC
    }
    
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = TransparentNavigationController(rootViewController: HelpSupportVC.initializeFromStoryboard())
        
        return navigationController
    }
    
    

}


// MARK: - UITableViewDataSource

extension HelpSupportVC: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = viewModel.itemName(atIndex: indexPath.row)
        cell.textLabel?.textColor = viewModel.itemColor(atIndex: indexPath.row)
        cell.textLabel?.font = viewModel.itemFont(atIndex: indexPath.row)
        cell.imageView?.image = viewModel.itemImage(atIndex: indexPath.row)
       
        return cell
    }
}


// MARK: - UITableViewDelegate

extension HelpSupportVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectItemAtIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
}
