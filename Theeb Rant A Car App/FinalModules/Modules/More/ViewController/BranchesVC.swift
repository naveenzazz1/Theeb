//
//  BranchesVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 04/04/2022.
//

import UIKit
import Alamofire

protocol BranchLocatinDelegate:AnyObject{
    func setSelectedCity(city:String)
}

class BranchesVC: UIViewController {

    //vars
    weak var branchDelegate:BranchLocatinDelegate?
//    var cityRagionDict = [String:[String]]()
//    var selectedKey = ""{
//        didSet{
//            cityCollectionView.reloadData()
//        }
//    }
    
   //outlets
//    @IBOutlet weak var cityCollectionView: UICollectionView!
//    @IBOutlet weak var ragionCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBranchesLocation()
      //  handleViews()
    }
    
    func loadBranchesLocation(){
        let locationVc = BranchesLocationsVC.initializeFromStoryboard()
        locationVc.isFromMore = true
        branchDelegate = locationVc
        addChildViewController(locationVc, onView: containerView)
       // cityRagionDict = locationVc.viewModel.cityRagionDict

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.TheebBranches, screenClass: String(describing: BranchesVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.TheebBranches, screenClass: String(describing: BranchesVC.self))
    }
    
//    func handleViews(){
//        selectedKey = cityRagionDict.keys.first ?? ""
//        let albumNib = UINib(nibName: CityCell.identifier, bundle: nil)
//        [cityCollectionView,ragionCollectionView].forEach{
//            $0?.delegate = self
//            $0?.dataSource = self
//            $0?.register(albumNib, forCellWithReuseIdentifier: CityCell.identifier)
//        }
//    }
    
    class func initializeFromStoryboard() -> BranchesVC {
        
        let storyboard = UIStoryboard(name: "MoreContent", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: BranchesVC.self)) as! BranchesVC
    }

}


