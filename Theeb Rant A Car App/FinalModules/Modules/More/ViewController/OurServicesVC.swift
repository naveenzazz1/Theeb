//
//  OurServicesVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 21/08/1443 AH.
//

import UIKit

class OurServicesVC: BaseViewController , UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets

    
    /*
    
     
     
     "more_service_rent_car_title".localized
     "more_service_rent_car_content".localized
     
     
     
     */

    var modles =  [
        OurServiceModel(title: "ourservices_accident_assitance_services".localized, imageName:"serviceAccedented",contentTuple:("more_accedintServiceTitle".localized,"more_accedintServiceContent".localized)),
                   
        OurServiceModel(title: "ourservices_bussiness_sector".localized, imageName: "Business Sectored", contentTuple: ("more_businessSectorTitle".localized,"more_businessSectorContent".localized)),
        
        OurServiceModel(title: "ourservices_car_sales".localized, imageName: "Car Salesed", contentTuple: ("more_service_car_sales_title".localized,"more_service_car_sales_content".localized)),
        
        OurServiceModel(title:"ourservices_cross_border_service".localized , imageName: "Cross Border Serviceed", contentTuple: ("more_service_cross_border_title".localized,"more_service_cross_border_content".localized)),
        
        OurServiceModel(title:  "ourservices_limo_service".localized , imageName: "Limo Serviceed", contentTuple: ("more_service_limo_title".localized, "more_service_limo_content".localized)),
        
        OurServiceModel(title: "ourservice_onedestination_service".localized, imageName: "One Destination Serviceed", contentTuple: ("more_service_one_destination_title".localized, "more_service_one_destination_content".localized)),
        
        OurServiceModel(title: "ourservice_raha_service".localized, imageName: "Raha Serviceed", contentTuple: ("more_service_raha_title".localized, "more_service_raha_content".localized)),
        
            OurServiceModel(title: "ourservice_rent_car".localized, imageName: "Car Rented",contentTuple: ("more_service_rent_car_title".localized,      "more_service_rent_car_content".localized))

    ]
    
    @IBOutlet weak var servicesCollectionView : UICollectionView! {
        didSet {
            servicesCollectionView.delegate = self
            servicesCollectionView.dataSource = self
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupCollectioViewInstes()
        title = "our_service_theeb_services".localized
        // Do any additional setup after loading the view.
        servicesCollectionView.reloadData()
    }
    
    
    // MARK: -Intialization
    
    
    class func initializeFromStoryboard() -> OurServicesVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.More, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: OurServicesVC.self)) as! OurServicesVC
    }
    
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = TransparentNavigationController(rootViewController: OurServicesVC.initializeFromStoryboard())
        
        return navigationController
    }
    
    
    // MARK: - Helper Methods
    
    
    func setupCollectioViewInstes() {
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.servicesCollectionView.frame.width / 2 - 10, height: 150)
      //  flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0.0
        servicesCollectionView.collectionViewLayout = flowLayout
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.OurServices, screenClass: String(describing: OurServicesVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.OurServices, screenClass: String(describing: OurServicesVC.self))
    }
    
    

}

// MARK: - UICollection View Delegate

extension OurServicesVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        
        let aboutVC = AboutDetailVc.initializeFromStoryboard()
        let model = modles[indexPath.item]
        aboutVC.contentString =  model.contentTuple.1
        aboutVC.titleStrig = model.contentTuple.0
      
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10.0, height: 150)
    }
}

// MARK: - UICollection View DataSource

extension OurServicesVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  modles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CarTypesCollectionViewCell.self), for: indexPath) as! CarTypesCollectionViewCell
        
        let service = modles[indexPath.row]
        cell.showService(service)
     
        
        return cell
    }
    
    
    
    
    
    
}



