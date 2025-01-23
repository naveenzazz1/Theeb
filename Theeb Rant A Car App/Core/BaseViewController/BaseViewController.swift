//
//  BaseViewController.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 11/07/1443 AH.
//



import UIKit
import Firebase
class BaseViewController: UIViewController {

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackBarButtonItem()
        setupNavigationBarTitle()
        localizeStrings()
    }
    
    
  
    
    
    
    // MARK: - Setup
    
    func setupNavigationBarTitle() {
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.weemBlack,
                          NSAttributedString.Key.font: (UIFont.BahijTheSansArabicSemiBold(fontSize: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold))
        
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
    }
    
    func setupBackBarButtonItem() {
        
        if self.navigationController?.viewControllers.first == self {

            navigationItem.leftBarButtonItem = nil

        } else {
            
//            let backImg = LocalizedImage().localizedBackImg()
//            navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImg?.imageLocalized()
            //UIApplication.isRTL() ? UIImage(named: "rightArrowNew"):UIImage(named: "leftArrowNew")
            let img = UIImage(named: "Back Arrow")
           let btnLeft =  UIBarButtonItem(image: img,style: .plain,target: self,action: #selector(backAction))
                                          
            btnLeft.tintColor = .black
            
            navigationItem.leftBarButtonItem = btnLeft
        }
        
    }
    
    
    // MARK: - Navigation Bar Style

    func setupNavigationControllerStyle() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGreenColor
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlueColor
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
    }
    
    func resetNavigationControllerStyle() {
        
        self.navigationController?.navigationBar.barTintColor =  .white
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlueColor
    }
    
    
    // MARK: - Actions

    @objc func backAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Localization

    func localizeStrings() {}
}


