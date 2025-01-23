//
//  GuestLoginVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 05/09/1443 AH.
//

import UIKit

class GuestLoginVC: BaseViewController {

    @IBOutlet weak var loginWithAbsher: LoadingButton! {
        didSet {
            loginWithAbsher.createNafazBtn()
        }
    }
    //@IBOutlet weak var nafazLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton! {
        didSet {
   
            loginBtn.setTitle( "login_button_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var signUpBtn: UIButton! {
        didSet {
            signUpBtn.setTitle( "sign_up_segment_title".localized, for: .normal)
        }
    }
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.text = "guest_login".localized
        }
    }
   
    let  viewModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden  = true

        
        setupViewModel()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginWithAbsher.createNafazBtn()
    
        
    }
    
    
    func setupViewModel() {
        
        viewModel.presentViewController = {  (vc) in
           
            UIApplication.topViewController()?.present(vc, animated: true)
            
        }
        
        viewModel.hideLoaddingForIam = { [weak self] in
            
            self?.loginWithAbsher.hideLoading()
        }
    }
    
    
    @IBAction func loginWithAbsherButtonAction(_ sender: Any) {
   
        loginWithAbsher.showLoading()
        viewModel.fetchIamServiceUrl()
    
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        let loginVC = LoginRegisterVC.initializeFromStoryboard()
        loginVC.isFromRegister = false
     //   self.present(loginVC, animated: true)
        presentDetail(loginVC)
        
    }
    
    @IBAction func signupBtnAction(_ sender: Any) {
        
        let registerVC = LoginRegisterVC.initializeFromStoryboard()
        registerVC.isFromRegister = true
      //  self.present(registerVC, animated: true)
        presentDetail(registerVC)
    }
    
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> GuestLoginVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.LoginRegister, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: GuestLoginVC.self)) as! GuestLoginVC
    }
    
    class func initializeWithNavigationController() -> UINavigationController {
        
        return TransparentNavigationController(rootViewController: GuestLoginVC.initializeFromStoryboard())
    }
    

}
