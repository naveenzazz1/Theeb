//
//  LocationListViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 19/06/1443 AH.
//


import UIKit
import CoreLocation

class LocationsListViewModel {

    
    // MARK: - Variables
    var branches: [Branch?]? {
        didSet {
            selectedLocation = selectedLocation ?? branches?.first ?? nil
            reloadList?()
        }
    }
    
    var selectedLocation: Branch? {
        didSet {
            reloadList?()
          //  selectBranchAtIndex?(branches?.firstIndex(of: selectedLocation) ?? 0)
            selectBranchAtIndex?(branches?.firstIndex(of: selectedLocation) ?? 0)
        }
    }


    
    var reloadList: (() -> ())?
    var selectBranchAtIndex: ((_ index: Int) -> ())?

    
    // MARK: - List
    
    func numberOfLocations() -> NSInteger {
        
        return branches?.count ?? 0
    }
    
    

}
