//
//  LandingPageVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 08/06/1443 AH.
//


import UIKit
import Firebase

class LandingPageVC: UITabBarController {

    
    // MARK - Constants

    let indicatorHeight: CGFloat = 2.5
    let maintenanceFlag = "app_disabled"



    //MARK: - Variables
    
    override var selectedViewController: UIViewController? {
        didSet {
            viewModel.updateItemsAttributes(forViewControllers: viewControllers,
                                            selectedViewController: selectedViewController)
            moveIndicatorViewToItem(item: selectedViewController?.tabBarItem, animated: true)
        }
    }
    
    lazy var viewModel = LandingPageViewModel()
    lazy var indicatorView = UIImageView(image: UIImage(named: "Bar Green Indicator"))

    
    //MARK: - Initialization
    
    class func initializeFromStoryboard() -> LandingPageVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.LandingPage, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LandingPageVC.self)) as! LandingPageVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: LandingPageVC.initializeFromStoryboard())
    }
    
    
    //MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsManager.logScreenView(screenName: String(describing: AnalyticsKeys.Dashboard), screenClass: String(describing: LandingPageVC.self))
        AppsFlyerManager.logScreenView(screenName: String(describing: AnalyticsKeys.Dashboard), screenClass: String(describing: LandingPageVC.self))
        checkMaintence()
//             alertUser(msg: "maintenace_alert_msg".localized)
      //   }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moveIndicatorViewToItem(item: selectedViewController?.tabBarItem, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //First, remove the default top line and background
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()

        //Then, add the custom top line view with custom color. And set the default background color of tabbar
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        lineView.backgroundColor = UIColor.red
        self.tabBarController?.tabBar.addSubview(lineView)
        self.tabBarController?.tabBar.backgroundColor = UIColor.darkGray
        setupTabBar()
        setupIndicatorView()
    }
    
    
    //MARK: - Setup
    
    func setupTabBar() {
        
        delegate = self
        tabBar.unselectedItemTintColor = .darkGray
        tabBar.barTintColor = UIColor.white
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        viewControllers = viewModel.tabBarViewControllers()
        selectedViewController = viewModel.initialSelectedViewController()
    }
    
    func setupIndicatorView() {
        
        indicatorView.frame.origin.y = tabBar.frame.origin.y
        view.addSubview(indicatorView)
    }

    func resetHomeVcTextField(){
//        if let navVc = viewModel.firstVC as? UINavigationController , let homeVc = navVc.topViewController as? HomeVC{
//        }
        HomeVC.isFromSuccesVc = true
    }
    
    //MARK: - maintenanc check
    func checkMaintence() {
        let remoteConfig = RemoteConfig.remoteConfig()
        if let forceRequiredDic = remoteConfig[maintenanceFlag].jsonValue as? [String : AnyObject] {
            if  let forceRequired = forceRequiredDic["is_disabled"] as? Bool {
                if forceRequired {
                    let msg = (UIApplication.isRTL()) ? forceRequiredDic["disabled_message_ar"] as? String : forceRequiredDic["disabled_message_en"] as? String
                    let title = (UIApplication.isRTL()) ? forceRequiredDic["disabled_title_ar"] as? String : forceRequiredDic["disabled_title_en"] as? String
                    alertUser(title: title ?? "", msg: msg ?? "")
                   // alertUser(title: title ?? "maintenace_alert_title".localized, msg: msg ?? "maintenace_alert_msg".localized)
                }
            }
        }
    }
    
    private func alertUser(title: String, msg: String){
        CustomAlertController.initialization().showAlertWithOkButton(title: title ,message: msg) { (index, title) in
             print(index,title,msg)
             exit(0)
        }
     }
    
    //MARK: - TabBar Indicator View

    func moveIndicatorViewToItem(item: UITabBarItem?, animated: Bool) {
        
        guard let tabBarItems = tabBar.items,
              let item = item,
              var itemIndex: Int = tabBarItems.firstIndex(of: item)
        else { return }
        
        if UIApplication.isRTL() {
            itemIndex = (tabBarItems.count - 1) - itemIndex
        }
        
        let itemWidth = tabBar.bounds.width / CGFloat(tabBarItems.count)

        let indicatorFrame = CGRect(x: CGFloat(itemIndex) * itemWidth,
                                    y: tabBar.frame.origin.y - indicatorHeight,
                                    width: itemWidth,
                                    height: indicatorHeight)
        
        
        UIView.animate(withDuration: animated ? 0.2 : 0) { [weak self] in
            
            guard let self = self else { return }
            
            self.indicatorView.frame = indicatorFrame
        }
    }
}


//MARK: - UITabBarControllerDelegate

extension LandingPageVC: UITabBarControllerDelegate {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        moveIndicatorViewToItem(item: item, animated: true)
    }
}
