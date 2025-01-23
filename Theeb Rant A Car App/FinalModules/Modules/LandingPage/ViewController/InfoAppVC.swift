//
//  InfoAppVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 05/04/2022.
//

import UIKit

class InfoAppVC:UIViewController{
    
    //vars
    var imageArr = [UIImage(named: "onBoard"),UIImage(named: "onBoard1"),UIImage(named: "onBoard2")]
    var currentIndex = 0
    
    //outlets
    @IBOutlet weak var helperCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleViews()
    }
    
    func handleViews(){
        let albumNib = UINib(nibName: OneImageCell.identifier, bundle: nil)
        helperCollectionView.delegate = self
        helperCollectionView.dataSource = self
        helperCollectionView.backgroundColor = #colorLiteral(red: 0.3993444443, green: 0.4243307114, blue: 0.449635148, alpha: 1)
        helperCollectionView.register(albumNib, forCellWithReuseIdentifier: OneImageCell.identifier)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       // layout.sectionInset = UIEdgeInsets(top:4,left:4,bottom:4,right:4)
        layout.scrollDirection = .horizontal
        let width =  view.bounds.width
        let height =  helperCollectionView.bounds.height*0.9
        layout.itemSize = CGSize(width:width , height: height)
        layout.minimumInteritemSpacing = 0
        helperCollectionView.collectionViewLayout = layout
        helperCollectionView.reloadData()
    }
    
    class func initializeFromStoryboard() -> InfoAppVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.LandingPage, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: InfoAppVC.self)) as! InfoAppVC
    }
    
}

extension InfoAppVC:UICollectionViewDelegate,UICollectionViewDataSource,OneImageDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneImageCell.identifier, for: indexPath) as? OneImageCell else {return UICollectionViewCell()}
        cell.imgViewMain.image = imageArr[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func actionOfBtnNext(){
        currentIndex += 1
        if currentIndex < imageArr.count{
            helperCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
        }else{
            CachingManager.isFirstLogin = true
            (UIApplication.shared.delegate as! AppDelegate).initWindow()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return containerView.bounds.size
//    }
    
}
