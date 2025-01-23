//
//  LoginRegiterViewController.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/04/1443 AH.
//

import UIKit
import Fastis

class LoginRegisterVC : UIViewController {
    

    // MARK: - Outlets
    
    var isFromRegister : Bool? = false
    @IBOutlet weak var regiterUnderLineView: UIView!
    @IBOutlet weak var loginUnderLineView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedController: UISegmentedControl! {
       
        didSet {
            
            segmentedController.setTitle("login_button_title".localized, forSegmentAt: 0)
            segmentedController.setTitle("sign_up_segment_title" .localized, forSegmentAt: 1)
            
        }
    }
    lazy var btnClose:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "Back"), for: .normal)
        btn.addTarget(self, action: #selector(btnClossPressed), for: .touchUpInside)
        return btn
    }()
   
    //MARK: - Variabels
    var iAmResponseObject : IAMServiceRequestBookingResponseObject?
    var driverProfileRS : DriverProfileRS?
    var registratoinObject :  TheebDriverSetNSObject?
    lazy var loginVC = LoginVC.initializeFromStoryboard()
    lazy var registrationVC = RegisterVC.initializeFromStoryboard()
    lazy var viewModel = LoginViewModel()
    let biometricIDAuth = BiometricIDAuth()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        setupView()
        setupSegmentView()
     
    }
    
     
    // MARK: - Helper Methods
    

    
    // MARK: - Helper Methods
    
    func setupSegmentView() {
        
        segmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.theebColor, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)], for: .selected)
        segmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.systemGray, NSAttributedString.Key.font: UIFont.BahijTheSansArabicSemiBold(fontSize: 15) ?? UIFont.systemFont(ofSize: 15)], for: .normal)
    if #available(iOS 13.0, *) {
           let dividerImage = UIImage(color: .white, size: CGSize(width: 1, height: 50))
        segmentedController.setBackgroundImage(UIImage(named: "W1"), for: .normal, barMetrics: .default)
        segmentedController.setBackgroundImage(UIImage(named: "W2"), for: .selected, barMetrics: .default)
        segmentedController.setDividerImage(dividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedController.layer.cornerRadius = 0
        segmentedController.layer.masksToBounds = true
       }
   }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSegmentView()
    }
    
    
    
    // MARK: - Initialization
    
    class func initializeFromStoryboard() -> LoginRegisterVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.LoginRegister, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LoginRegisterVC.self)) as! LoginRegisterVC
    }
    
      // MARK: - Helper Methods
    
    func setupView() {
       
        view.addSubview(btnClose)
        btnClose.anchor(view.topAnchor,left: view.leftAnchor,topConstant: 48,leftConstant: 24,widthConstant: 48,heightConstant: 48)
        view.bringSubviewToFront(btnClose)
        if isFromRegister  ?? false {
            segmentedController.selectedSegmentIndex = 1
            
            setupRegisterChildViewController()
        } else {
            segmentedController.selectedSegmentIndex = 0
            //             if CachingManager.isFaceIdEnabled ?? false {
            //                    handleTouchID()
            //                }
            
            setupLoginChildViewController()
        }
        
    }
    
  
    
    // MARK: - Actions
    
    @objc func btnClossPressed(){
        dissmissDetail()
    }
    
    func setupLoginChildViewController() {
        UIView.transition(with: containerView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.regiterUnderLineView.isHidden = true
       
            self.addChild(self.loginVC)
            self.loginVC.willMove(toParent: self)
            self.containerView.addSubview(self.loginVC.view)
            self.loginVC.didMove(toParent: self)
            self.setupLoginChildView()
        })
    }
    
    func setupLoginChildView() {
        
        loginVC.view.frame = containerView.bounds
    }
    
    func setupRegisterChildViewController() {
            UIView.transition(with: containerView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                self.registrationVC.viewModel.switchToLogin = { [weak self] in
                    
                    self?.segmentedController.selectedSegmentIndex = 0
                    self?.setupLoginChildViewController()
                    self?.alertUser(msg: "error_already_registered".localized)
                    
                }
                self.addChild(self.registrationVC)
                self.loginVC.willMove(toParent: self)
                self.containerView.addSubview(self.registrationVC.view)
                self.registrationVC.didMove(toParent: self)
                self.setupRegistratoinChildView()
            })
    }
    
    
    private func alertUser(msg:String) {

        CustomAlertController.initialization().showAlertWithOkButton(message: msg) { (index, title) in
             print(index,title)
        }
        
    }
    
    func setupRegistratoinChildView() {
        
        if registratoinObject != nil {
            registrationVC.fullNameTextField.text = "\(registratoinObject?.firstName ?? "")\(" ")\(registratoinObject?.lastName ?? "")"
            registrationVC.fullNameTextField.isEnabled = false
            registrationVC.idorIqamaTextField.text = registratoinObject?.idNo
            registrationVC.idorIqamaTextField.isEnabled = false
            registrationVC.emailTextField.text = registratoinObject?.email
            
            registrationVC.viewModel.isFromIam = true
            registrationVC.viewModel.registratoinObject = self.registratoinObject
            registrationVC.viewModel.iAmResponseObject = self.iAmResponseObject
            registrationVC.containerStackvIEW.addInputView(view:registrationVC.forgetPasswordView , atIndex: 4)
            
        }
       
        registrationVC.view.frame = containerView.bounds
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
     
        if segmentedController.selectedSegmentIndex == 0 {
//            if CachingManager.isFaceIdEnabled ?? false {
//                   handleTouchID()
//               }
            setupLoginChildViewController()
        } else {
            
            setupRegisterChildViewController()
            
        }
        
        segmentedController.changeUnderlinePosition()
    
    }
    
    func handleTouchID() {
        
        biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
            guard canEvaluate else {
                alert(title: "Error",
                      message: canEvaluateError?.localizedDescription ?? "Face ID/Touch ID may not be configured",
                      okActionTitle: "Ok!")
                return
            }
            
            biometricIDAuth.evaluate { [weak self] (success, error) in
                guard success else {
                    self?.alert(title: "Error",
                                message: error?.localizedDescription ?? "Face ID/Touch ID may not be configured",
                                okActionTitle: "Ok!")
                    return
                }
                
                self?.viewModel.login2(CachingManager.email() ?? "", password: CachingManager.storedPassword ?? "")
             
             
                
            
             
            }
        }
    }
    
    
    func alert(title: String, message: String, okActionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
    
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParent: nil)
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false

        self.addChild(newViewController)
            self.addSubview(subView: newViewController.view, toView:self.containerView!)

            newViewController.view.alpha = 0
            newViewController.view.layoutIfNeeded()

            UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
                newViewController.view.alpha = 1
                oldViewController.view.alpha = 0
            }) { (finished) in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParent()
                newViewController.didMove(toParent: self)
            }
        }

        //--------------------------------------------------------------------------------


       private func addSubview(subView:UIView, toView parentView:UIView) {
            self.view.layoutIfNeeded()
            parentView.addSubview(subView)

            subView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
            subView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
            subView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive  = true
        }


}

