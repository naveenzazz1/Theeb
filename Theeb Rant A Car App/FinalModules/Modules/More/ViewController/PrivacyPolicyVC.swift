//
//  PrivacyPolicyVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 27/06/2022.
//

import UIKit
import WebKit

class PrivacyPolicyVC:BaseViewController{
    
    let isArabic = UIApplication.isRTL()
    var urlString = ""
    var isFromMore = true
    
    let arabicHtmlStr = """
<string name="privacy_policy">سياسة الإستخدام والخصوصية</string>
<string name="privacy_policy_text">
    <ul>
        <li>البيانات المطلوبة لإجراء العمليات التجارية هي الاسم ، تاريخ الميلاد ، رقم الترخيص ، تاريخ انتهاء الصلاحية للوثائق وما إلى ذلك يتم اخذها من عملاء الافراد.\n</li>
        <li>يتم استخدام البيانات التي يتم جمعها من الأفراد فقط لتجنب إدخال البيانات عدة مرات ولتقديم خدمات أفضل للعميل.\n</li>
        <li>يتم الاحتفاظ بالبيانات الشخصية التي يتم جمعها من الأفراد تحت حماية صارمة.\n</li>
        <li>لا يتم مشاركة أي جزء من البيانات أو الوصول إليه من قبل أي كيانات خارجية باستثناء الجهات التنظيمية المعنية المتعلقة بالأعمال / صناعة الخدمات.\n</li>
        <li>لا يتم جمع أو تخزين أي بيانات مالية من قبل شركة ذيب لتأجير السيارات.\n</li>
        <li>يتم تخزين بطاقة الائتمان / الخصم التي لم يتم أخذها كمراجع في شكل مغلق.\n</li>
        <li>يتم عرض جميع البيانات التي تم جمعها من الأفراد ضمن ملف التعريف للمستخدمين المسجلين.\n</li>
    </ul>
</string>
"""
    
    let englishHTmlString = """
<string name="privacy_policy">Privacy Policy</string>
<string name="privacy_policy_text">
    <ul>
        <li>Data required to perform business transactions like Name, DOB, License No, Expiry date etc are only collected from the individual.\n</li>
        <li>Data collected from individual are solely used to avoid data entry multiple times and to give better services to the customer.\n</li>
        <li>Personal data collected from the individuals are kept under strict safeguard.\n</li>
        <li>No part of data is shared or have access by any external entities except concerned regulatory authorities related to business / service industry.\n</li>
        <li>No financial data is collected or stored by Theeb Rent A Car Co.\n</li>
        <li>Credit / Debit card no taken for references are stored in mask format.\n</li>
        <li>All the data collected from individuals are displayed under user profile for registered users.\n</li>
    </ul>
</string>

"""
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if isFromMore{
        // urlString = isArabic ? "https://www.theebonline.com/company-2/policies/privacy-policy/":"https://www.theebonline.com/en/company/policies/privacy-policy/"
            webView.loadHTMLString(isArabic ? arabicHtmlStr:englishHTmlString, baseURL: nil)
            return
            
        }else{
            urlString = "http://dev.theebsaudia.com/media-center/#media-news-page-alkheir-container"
        }
        if let url = URL(string: urlString){
            let urlRequst = URLRequest(url: url)
            webView.load(urlRequst)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.PrivacyPolicy, screenClass: String(describing: PrivacyPolicyVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.PrivacyPolicy, screenClass: String(describing: PrivacyPolicyVC.self))

    }
    
    class func initializeFromStoryboard() -> PrivacyPolicyVC {
        
        let storyboard = UIStoryboard(name: "MoreContent", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: PrivacyPolicyVC.self)) as! PrivacyPolicyVC
    }
}

extension PrivacyPolicyVC:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        CustomLoader.customLoaderObj.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CustomLoader.customLoaderObj.stopAnimating()
    }
}
