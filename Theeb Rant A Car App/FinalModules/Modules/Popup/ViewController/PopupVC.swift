//
//  PopupVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 18/07/1443 AH.
//
import UIKit

class PopupVC: BaseViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var transparentBackgroundView: UIView!
    
    var embeddedViewController: UIViewController?
    var transparentBackground = true
    var isTutorialStyleEnabeld = false
    
    //MARK: - Initialization
    
    class func initializeFromStoryboard() -> PopupVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Popup, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: PopupVC.self)) as! PopupVC
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupEmbeddedViewFrame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmbeddedViewController()
    }
    
    
    // MARK: - Setup
    
    func setupEmbeddedViewController() {
        
        guard let embeddedViewController = embeddedViewController else { return }
        
        addChild(embeddedViewController)
        embeddedViewController.willMove(toParent: self)
        containerView.addSubview(embeddedViewController.view)
        embeddedViewController.didMove(toParent: self)
        setupEmbeddedViewFrame()
        if isTutorialStyleEnabeld {
            setTutorialStyle()
        }
        else {
            transparentBackgroundView.backgroundColor = transparentBackground ? .black : .weemBlack
            transparentBackgroundView.alpha = transparentBackground ? AlphaStyles.transparent : AlphaStyles.enabled
        }
    }
    
    func setupEmbeddedViewFrame() {
        
        embeddedViewController?.view.frame = containerView.bounds
    }
    
    func setTutorialStyle() {
        
        if let containerView = containerView , let transparentBackgroundView = transparentBackgroundView {
            containerView.backgroundColor = .clear
            transparentBackgroundView.backgroundColor = .weemBlack
            transparentBackgroundView.alpha =  AlphaStyles.transparent
        }
    }
}
