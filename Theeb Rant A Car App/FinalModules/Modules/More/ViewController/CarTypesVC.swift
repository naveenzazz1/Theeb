//
//  CarTypesVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/08/1443 AH.
//

import UIKit

class CarTypesVC: BaseViewController ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var fleetCollectionView: UICollectionView! {
        didSet {
            fleetCollectionView.delegate = self
            fleetCollectionView.dataSource = self
        }
    }
    let apiGroup = DispatchGroup()
    
    var viewModel = MoreFleetViewModel()
    var loadingPlaceholderView = LoadingPlaceholderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
      //  setupLoader()
       // if CachingManager.vechileTypes() != nil {
       

            CustomLoader.customLoaderObj.startAnimating()
        apiGroup.enter()
            viewModel.getAvailableCars()
        apiGroup.enter()
            viewModel.getAvailabelCarModels()
      //  }
       
        navigationController?.navigationBar.backgroundColor = .white
        title = "fleet_theebFleet".localized
        
      //  viewModel.getPriceEstimation()
        setupCollectioViewInstes()
//        if  (CachingManager.vechileTypes() == nil) {
//            viewModel.getAvailabelCarModels()
//        }
        apiGroup.notify(queue: .main) {
            CustomLoader.customLoaderObj.stopAnimating()
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.CarsList, screenClass: String(describing: MoreVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.CarsList, screenClass: String(describing: MoreVC.self))
    }
    
    
    func setupLoader(){
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
        loadingPlaceholderView.cover(fleetCollectionView)
    }
    
    func setupCollectioViewInstes() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: self.fleetCollectionView.frame.width / 2 - 10, height: 150)
      //  flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0.0
        fleetCollectionView.collectionViewLayout = flowLayout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10.0, height: 150)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
      
    //    viewModel.getAvailableCars()
    }
   
   
    func setupViewModel() {
        
        viewModel.pushViewController  = { [weak self] vc in
            
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        viewModel.reloadCollectionView = { [weak self] in
           // self?.loadingPlaceholderView.uncover()
            self?.apiGroup.leave()
           
            self?.fleetCollectionView.reloadData()
        }
    }
    
    
    // MARK: -Intialization
    
    
    class func initializeFromStoryboard() -> CarTypesVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.More, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: CarTypesVC.self)) as! CarTypesVC
    }
    
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = TransparentNavigationController(rootViewController: CarTypesVC.initializeFromStoryboard())
        
        return navigationController
    }
    /*
     1 -> R.drawable.img_car_type_compact
      4 -> R.drawable.img_car_type_family
      5 -> R.drawable.img_car_type_economy
      10 -> R.drawable.img_car_type_luxury
      13 -> R.drawable.img_car_type_pickup
      15 -> R.drawable.img_car_type_full_size
      16 -> R.drawable.img_car_type_intermediate
      17 -> R.drawable.img_car_type_luxury_elite
      20 -> R.drawable.img_car_type_standard
      21 -> R.drawable.img_car_type_suv_sport_utility
      22 -> R.drawable.img_car_type_special_need
      26 -> R.drawable.img_car_type_crossover
     */
    func getCarImg(code:String)->UIImage{
        print(code,"sssss")
        var desc = "CarFleetIcon"
        switch code{
        case "1":
            desc = "compact"
        case "4":
            desc = "family"
        case "5":
            desc = "economy"
        case "10":
            desc = "luxury"
        case "13":
            desc = "pickup"
        case "15":
            desc = "full size"
        case "16":
            desc = "intermediate"
        case "17":
            desc = "luxury elite"
        case "20":
            desc = "standard"
        case "21":
            desc = "suv sprt ut vehicle"
        case "22":
            desc = "special need"
        case "26":
            desc = "crossover"
        default:
            desc = "CarFleetIcon"

        }
        return UIImage(named: desc) ?? UIImage(named: "CarFleetIcon")!
    }
}

// MARK: -UICollection View Delegate


extension CarTypesVC : UICollectionViewDelegate { }

extension CarTypesVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
//        if  CachingManager.vechileTypes() != nil {
//            return  CachingManager.vechileTypes()?.count ?? 0
//        } else {
            return viewModel.vehicleTypes?.count ?? 0
       // }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarTypesCollectionViewCell.self), for: indexPath) as! CarTypesCollectionViewCell
        
//        if  CachingManager.vechileTypes() != nil  {
//            let vechType =  CachingManager.vechileTypes()?[indexPath.row]
//            cell.showType(vechType, true)
//            cell.imgViewCar.image = getCarImg(desc: vechType?.desc ?? "CarFleetIcon")
//        } else {
            let vechType = viewModel.vehicleTypes?[indexPath.row]
            cell.showType(vechType, true)
            //cell.imgViewCar.image = getCarImg(code: vechType?.code ?? "20")
        if vechType?.code == "" {
            cell.imgViewCar?.image = UIImage(named: "TheebLogo")
        } else {
            if  let imageUrl = URL(string: NetworkConfigration.imageURL + (vechType?.code ?? "") + ".png") {
                cell.imgViewCar?.af.setImage(withURL: imageUrl)
            }else{
                cell.imgViewCar?.image = UIImage(named: "TheebLogo")
            }
            //   }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vechType =  viewModel.vehicleTypes?[indexPath.row]
        let getCarsVC = FleetVC.initializeFromStoryboard()
        viewModel.selectedVechType = vechType
        viewModel.getPriceEstimationJSon(getCarsVC: getCarsVC)
        
    }
    
    
    
}





 
