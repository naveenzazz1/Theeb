//
//  SettingVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 01/04/2022.
//

import UIKit

class SettingVC:BaseViewController{
    
    //vars
    let viewModel = SettingViewModel()
    
    @IBOutlet weak var tableViewSetting: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fillSettingArr()
        handleViews()
    }
    
    func handleViews(){
        title = "setting_title".localized
        tableViewSetting.delegate = self
        tableViewSetting.dataSource = self
        let albumNib = UINib(nibName: "SettingCell", bundle: nil)
        tableViewSetting.register(albumNib, forCellReuseIdentifier: SettingCell.identifier)
        tableViewSetting.tableFooterView = UIView()
        tableViewSetting.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.Settings, screenClass: String(describing: SettingVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.Settings, screenClass: String(describing: SettingVC.self))
    }
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = TransparentNavigationController(rootViewController: SettingVC.initializeFromStoryboard())
        
        return navigationController
    }
    
    class func initializeFromStoryboard() -> SettingVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.More, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: SettingVC.self)) as! SettingVC
    }
    
    func getLanguageIndex()->Int{
        switch Language.currentLanguage{
        case .english:
            return 0
        case .arabic:
            return 1
        case .french:
            return 2
        case .chinese:
            return 3
        }
    }
}

extension SettingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else {return UITableViewCell()}
        cell.lblSetting.text = viewModel.itemName(atIndex: indexPath.row)
        cell.lblSetting.textColor = viewModel.itemColor(atIndex: indexPath.row)
        cell.lblSetting.font = viewModel.itemFont(atIndex: indexPath.row)
        cell.imgSetting.image = viewModel.itemImage(atIndex: indexPath.row)
        cell.fillSegmnt(sgmntTuble: viewModel.segmntItmes(index: indexPath.row))
        cell.actionSegmented = viewModel.getSegmntAction(index: indexPath.row)
        if indexPath.row == 0 {
       // cell.segmentedSetting.selectedSegmentIndex = getLanguageIndex()
        cell.segmentedSetting.isHidden = true
        }
        if indexPath.row == 1 {
            cell.segmentedSetting.selectedSegmentIndex = CachingManager.isFaceIdEnabled ?? false ? 0 : 1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(LanguageSwitchVC.initializeFromStoryboard(), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
