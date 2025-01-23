//
//  AllMembersVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 21/03/2022.
//

import UIKit
import SwiftUI

class AllMembersVC:BaseViewController{

    
    //vars
    var scrollIndex = 0
    lazy var widthCollectionItem =  mainCollectionView.bounds.width*0.7
    var timeParentView:UIView?
    var timePArentHeightConstraint: NSLayoutConstraint!
    var memberDetails: MemberDetailsVC?
    let popupVC = PopupVC.initializeFromStoryboard()

    
    //outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleViews()
//
//        let rect  = CGRect(origin: view.bounds.origin, size: CGSize.getSizeForMainConstraintsBasedOnDevice(topSpaceToLeave: 16, bottomSpaceToLeave: view.frame.height/4))
//        let caroUView = CarouView(frame: rect, imageSet: memberArr)
//        caroUView.memberDelegate = self
//        containerView.addSubview(caroUView)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.OurMemberships, screenClass: String(describing: AllMembersVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.OurMemberships, screenClass: String(describing: AllMembersVC.self))
    }
    

    func handleViews(){
        let albumNib = UINib(nibName: "TemplateCell", bundle: nil)
        mainCollectionView.register(albumNib, forCellWithReuseIdentifier: TemplateCell.identifier)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.backgroundColor = .clear
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0,left:8,bottom:0,right:8)
        layout.scrollDirection = .horizontal
        let ratio = calculateRatio()
        let height =  mainCollectionView.bounds.height*ratio
        layout.itemSize = CGSize(width:widthCollectionItem , height: height)
      //  layout.minimumInteritemSpacing = 0
      //  layout.minimumLineSpacing = UIDevice.current.userInterfaceIdiom == .pad ? 10 : 6
        mainCollectionView.collectionViewLayout = layout
        pageControl.numberOfPages = MemberImages.numberOfElemnts()
        title = "rental_memberShipTitle".localized
        if UIApplication.isRTL(){
            pageControl.currentPage = MemberImages.numberOfElemnts() - 1
            //pageControl.transform = CGAffineTransform(scaleX: -1, y: 1);
        }
    }
    
    func setMemberDetailsVc(childVc:UIViewController?){
        let tuble = constructTimeView(onView: view,val: 0.8)
        timeParentView = tuble.0
        timePArentHeightConstraint = tuble.1
        timeParentView?.clipsToBounds = true
        timeParentView?.layer.cornerRadius = 16
        timeParentView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addFadeBackground(true,  color:UIColor.black)
        view.bringSubviewToFront(timeParentView ?? UIView())
        addChildViewController(childVc, onView: (timeParentView) ?? UIView())
        view.layoutIfNeeded()
        animateConstraint(constraint: timePArentHeightConstraint, to: 8)

    }
   
    func calculateRatio()->Double{
  
        if UIDevice().userInterfaceIdiom == .phone {
          switch UIScreen.main.nativeBounds.height {
 
          case 1334:
            print("iPhone 6/6S/7/8")
            return 0.6
          case 1920:
            print("iPhone 6+/6S+")
            return 0.6
          case  2208:
            print("iPhone 6+/6S+/7+/8+")
            return 0.7
       
          default:
            return 0.72
          }
        }
        return 0.72
      }

}



extension AllMembersVC:TemplateMemberViewDelegate{
    func btnLeranPressed(memberElmnt: MemberElement?) {
        memberDetails = MemberDetailsVC.initializeFromStoryboard()
        memberDetails?.paymentDelegate = self
        memberDetails?.memberElement = memberElmnt ?? .silver
        setMemberDetailsVc(childVc: memberDetails)
        //self.navigationController?.pushViewController(memberDetails, animated: true)
    }
    
}

extension AllMembersVC:PaymentDelegate{
    func btnClosePressed() {
        if let memberDetails = memberDetails{
            addFadeBackground(false, color: nil)
            removeChildVC(mainVc: memberDetails)
            timeParentView?.removeFromSuperview()
        }
    }
    
    
}

//UICollectionViewDelegateFlowLayout
extension AllMembersVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemberImages.numberOfElemnts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemplateCell.identifier, for: indexPath) as? TemplateCell else {return UICollectionViewCell()}
        cell.configCell(member: MemberImages.getMember(index: indexPath.item), delegate: self)
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let pageWidth = scrollView.frame.width/1.4
        pageControl.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
     
        }
}
