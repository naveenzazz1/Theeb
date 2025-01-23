//
//  LoginWithIAMVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 04/09/1443 AH.
//

import UIKit
import WebKit
class LoginWithIAMVC: BaseViewController {
    
    var urlToGo: String?
    lazy var viewModel = LoginWithIAmViewModel()
    
    @IBOutlet weak var loadIamWEBView: WKWebView! {
        didSet {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            
            loadIamWEBView.navigationDelegate = self
            loadIamWEBView.uiDelegate = self
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadURL()
        setupViewModel()
        
    }
    
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> LoginWithIAMVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Login, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LoginWithIAMVC.self)) as! LoginWithIAMVC
    }
    
    func setupViewModel() {
        
        viewModel.presentViewController = { [weak self] (vc) in
            
            self?.present(vc, animated: true, completion: nil )
            
        }
        
    }
    
   

    // MARK: -Load URL
    
    func loadURL() {
        
        DispatchQueue.main.async {
            // CustomLoader.customLoaderObj.startAnimating()
            self.urlToGo = self.urlToGo?.replacingOccurrences(of: "&amp;", with: "&")
            self.urlToGo = self.urlToGo?.replacingOccurrences(of: " ", with: "%20")
            
            if let url = URL.init(string: self.urlToGo ?? "")
            { // UIApplication.shared.openURL(url)
                print(url.absoluteURL)
                
                let request = URLRequest.init(url: url)
                self.loadIamWEBView.load(request)
                
            }
        }
    }

    
}




extension  LoginWithIAMVC:WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            completionHandler(nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}


extension LoginWithIAMVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let banner = Banner(title:  NSLocalizedString(error.localizedDescription, comment: ""), subtitle: "", image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
        banner.dismissesOnTap = true
        banner.show(duration: 5.0)
        self.view.endEditing(true)
        DispatchQueue.main.async {
            CustomLoader.customLoaderObj.stopAnimating()
            var flag = false
            
            
            self.navigationController?.popViewController(animated: true)
            flag = true
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        CustomLoader.customLoaderObj.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        
        DispatchQueue.main.async {
            CustomLoader.customLoaderObj.stopAnimating()
        }
        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in
            
            if let userAgent = result as? String {
                print(userAgent)
            }
            
        })
        webView.evaluateJavaScript("location.hash", completionHandler: { result, error in
            
            if let location = result as? String {
                print(location)
            }
            
        })
        
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                   completionHandler: { (html: Any?, error: Error?) in
            let string = html as? String
            if(string ?? "").contains("Data Processed Successfully") {
                DispatchQueue.main.async {
                    
                    
                    DispatchQueue.main.async {
                        CustomLoader.customLoaderObj.startAnimating()
                        
                        
                        self.viewModel.loginWithIamService(idNo:  UserDefaults.standard.object(forKey: "iAMKey") as? String ?? ""  )
                        
                        
                    }
                    
                }
            }
            if(string?.lowercased() ?? "").contains("white label")
            {
                DispatchQueue.main.async {
                    
                    
                    let banner = Banner(title: NSLocalizedString("white_label_error", comment: "") , subtitle: "", image: UIImage(named: "logo"), backgroundColor: UIColor().returnColorBlue())
                    banner.dismissesOnTap = true
                    banner.show(duration: 5.0)
                    
                    self.dismiss(animated: true)
                }
            }
            
        })
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    
    {
        CustomAlertController.initialization().showAlertWithOkButton(message: NSLocalizedString(error.localizedDescription, comment: "")) { (index, title) in
            print(index,title)
        }
        
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            CustomLoader.customLoaderObj.stopAnimating()
            var flag = false
            
            self.navigationController?.popViewController(animated: true)
            flag = true
            
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\(#function)")
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            let headers = response.allHeaderFields
            webView.evaluateJavaScript("document.getElementById(\"my-id\").innerHTML", completionHandler: { (jsonRaw: Any?, error: Error?) in
                
            })
            
        }
        decisionHandler(.allow)
    }
}
