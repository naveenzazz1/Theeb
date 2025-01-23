//
//  MoreVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 10/08/1443 AH.
//

import UIKit

class MoreVC : BaseViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

  
    
    lazy var viewModel =  MoreViewModel()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        title = "more_title".localized
    
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // navigationController?.applyGrayNavigationBar()
  
        viewModel.setupUserItems()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.More, screenClass: String(describing: MoreVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.More, screenClass: String(describing: MoreVC.self))
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
    
    class func initializeFromStoryboard() -> MoreVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.More, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: MoreVC.self)) as! MoreVC
    }
    
    
    
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: initializeFromStoryboard())
        
        return navigationController
    }
    
   
}

// MARK: - UITableViewDataSource

extension MoreVC: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = viewModel.itemName(atIndex: indexPath.row)
        cell.textLabel?.textColor = viewModel.itemColor(atIndex: indexPath.row)
        cell.textLabel?.font = UIFont.BahijTheSansArabicSemiBold(fontSize: 16) ?? UIFont.boldSystemFont(ofSize: 16)//viewModel.itemFont(atIndex: indexPath.row)
        cell.imageView?.image = viewModel.itemImage(atIndex: indexPath.row)
       
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MoreVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectItemAtIndex(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
}
