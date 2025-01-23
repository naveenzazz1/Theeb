//
//  ShowBillVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 22/10/1443 AH.
//

import UIKit
import WebKit

class ShowBillVC: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    var urlToGo: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(fileURLWithPath: urlToGo ?? "")))

    }
    
    
    

  
    // MARK: -Intialization
    
    class func initializeFromStoryboard() -> ShowBillVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Bills, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: ShowBillVC.self)) as! ShowBillVC
    }
    
}
