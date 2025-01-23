//
//  Language.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 01/04/2022.
//

import Foundation


class Language: NSObject {
    
    static var currentLanguage : AppLanguage {
        
        var langStr = "en"

        if let lang = Cache.object(key: "currentLang") as? String {
            langStr = lang
        } else {
            langStr = Locale.current.languageCode!
        }
        //return langStr == "ar" ? .arabic : (langStr == "en" ? .english:.french)
        switch langStr{
        case "ar":
            return .arabic
        case "en":
            return .english
        case "fr":
            return .french
        case "zh-Hans":
            return .chinese
        default:
            return .english
        }
    }
    
   static func setCurrentLanguage(lang : AppLanguage) {
        Cache.set(object: lang.rawValue, forKey: "currentLang")
    }
    
//    static func swichLanguage() {
//
//        switch Language.currentLanguage {
//        case .arabic:
//            self.setCurrentLanguage(lang: .english)
//            break
//        case .english:
//            self.setCurrentLanguage(lang: .arabic)
//            break
//        }
//    }

    
    
    class var isRTL: Bool {
        return (Language.currentLanguage == .english || Language.currentLanguage == .french) || (Language.currentLanguage == .chinese)
    }
}

enum AppLanguage : String ,CaseIterable{
    case arabic = "ar"
    case english = "en"
    case french = "fr"
    case chinese = "zh-Hans"
    
    var langName:String{
        switch self{
        case .arabic:
            return "العربية"
        case .english:
            return "English"
        case .french:
            return "French"
        case .chinese:
            return "Chinese"
        }
    }
    
}
