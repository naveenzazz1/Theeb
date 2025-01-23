//
//  LocationListVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//


import UIKit
import ViewAnimator
class LocationsListVC : UIViewController {
    
    //MARK: - Outlets
    
   
    @IBOutlet weak var locationsCollectionView: UICollectionView!
    
        
    
    //MARK: - Variables
    
    lazy var viewModel = LocationsListViewModel()
    private let animations = [AnimationType.from(direction: .right, offset: 20.0)]
    var locationsArray: [Branch]?

    
    //MARK: -  View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var selectedLocation: Branch? {
        
        return viewModel.selectedLocation
    }
    
    var didTapOnLocation: ((_ location: Branch?) -> ())?

    
    
    //MARK: - Initialization

    class func initializeFromStoryboard() -> LocationsListVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.MapLocationView, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LocationsListVC.self)) as! LocationsListVC
    }
    
    
    class func initializeNavigationController() -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: initializeFromStoryboard())
        
        return navigationController
    }
    
    //MARK: - Setup
    
    func setupViewModel() {
        
        viewModel.reloadList = { [unowned self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.locationsCollectionView.reloadData()
            self.applyAnimation()
                
            }
        }
        
        viewModel.selectBranchAtIndex = { [unowned self] (index) in
            
            guard index < self.viewModel.branches?.count ?? 0 else { return }
                        
            self.selectCardAtIndex(index)
        }
    }
    
    //MARK: - Helper Methods
    
    func setLocations(locations: [Branch?]?) {
        
        viewModel.branches?.removeAll()
        viewModel.branches = locations
        locationsArray = locations as? [Branch]
        self.locationsCollectionView.reloadData()
    }
    
    func setSelectedLocation(_ selectedLocation: Branch?) {
        
        viewModel.selectedLocation = selectedLocation
    }
    
    func selectCardAtIndex(_ index: Int) {
        
        for cell in locationsCollectionView.visibleCells {
            
            let locationCell = cell as! LocationListCollectionViewCell
            let cellIndex = locationsCollectionView.indexPath(for: locationCell)?.row
            
       //    cellIndex == index ? locationCell.setSelectedStyle() : locationCell.setDefaultStyle()
        }
        
        scrollToLocationAtIndex(index)
    }
    
    
    func applyAnimation() {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
          //  self.items = Array(repeating: nil, count: 5)
            self.locationsCollectionView?.reloadData()
            self.locationsCollectionView?.performBatchUpdates({
                UIView.animate(views: self.locationsCollectionView!.orderedVisibleCells,
                               animations: self.animations, completion: {
  
                    })
            }, completion: nil)
        }
    }
    
    func scrollToLocationAtIndex(_ index: Int) {
        
        let direction: UICollectionView.ScrollPosition = UIApplication.isRTL() ? .right : .left
        locationsCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: direction, animated: true)
    }
}
    
    
extension LocationsListVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return locationsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LocationListCollectionViewCell.self), for: indexPath) as! LocationListCollectionViewCell
        
        let location = locationsArray?[indexPath.row]
        cell.showLocation(location: location)
    
       // location == viewModel.selectedLocation ? cell.setSelectedStyle() : cell.setDefaultStyle()
        
        return cell
    }
}


extension LocationsListVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedLocation = locationsArray?[indexPath.row]
        didTapOnLocation?(selectedLocation)
        viewModel.selectedLocation = selectedLocation
    }
}

extension LocationsListVC : UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20.0
        return CGSize(width: view.bounds.width/2.0 + margin, height: collectionView.bounds.height)
    }
}

