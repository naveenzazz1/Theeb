//
//  LanguageSwitchVC.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 11/06/2023.
//

import UIKit
class LanguageSwitchVC: BaseViewController {

    //vars
    var langIndex = 0
    
   //outlets
    @IBOutlet weak var languageTableView: TanibleView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleViews()
        langIndex = getLanguageIndex()
        title = "setting_language" .localized
    }
    

    func handleViews(){
        languageTableView.delegate = self
        languageTableView.dataSource = self
        let albumNib = UINib(nibName: "LanguageCell", bundle: nil)
        languageTableView.register(albumNib, forCellReuseIdentifier: LanguageCell.identifier)
        languageTableView.tableFooterView = UIView()
        languageTableView.reloadData()
    }
    
    
    class func initializeFromStoryboard() -> LanguageSwitchVC {
        
        let storyboard = UIStoryboard(name: "More", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LanguageSwitchVC.self)) as! LanguageSwitchVC
    }
    
    func getLanguageIndex()->Int{
        switch Language.currentLanguage{
        case .arabic:
            return 0
        case .english:
            return 1
        case .french:
            return 2
        case .chinese:
            return 3
        }
    }
    
    func switchCurrentLang(lang : AppLanguage){
        Language.setCurrentLanguage(lang: lang)
        (UIApplication.shared.delegate as! AppDelegate).initWindow()
    }

}

extension LanguageSwitchVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppLanguage.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell else {return UITableViewCell()}
        cell.lblLanguage.text = AppLanguage.allCases[indexPath.row].langName
        if indexPath.row == langIndex {
            cell.btnCheckLang.setImage(UIImage(named: "CheckBoxForCarDetails"), for: .normal)
        }else{
            cell.btnCheckLang.setImage(UIImage(named: "UnDefinedIcon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CustomAlertController.initialization().showAlert(title:"login_alert".localized,message: "alert_language".localized, cancelButton: "language_Yes".localized, otherButton: "language_No".localized) { index, str in
            print(str,"\(index)")
            if index == 0 {
                self.switchCurrentLang(lang: AppLanguage.allCases[indexPath.row])
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
