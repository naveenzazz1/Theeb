//
//  String+MissingUtils.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 30/05/1443 AH.
//

import UIKit

public extension String {
    
    var withoutSpaces: String {
            return self.replacingOccurrences(of: " ", with: "")
        }
    
    var charactersArray: [Character] {
        return Array(self)
    }
    
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            let randomIndex = arc4random_uniform(UInt32(base.count))
            let randomCharacter = base.charactersArray[Int(randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
    
    func rawMobileNumber() -> String {
        
        var rawMobile = self.replacingOccurrences(of: " ", with: "")
        rawMobile = rawMobile.replacingOccurrences(of: "-", with: "")
        return rawMobile
    }
    
    func rawPhoneCode() -> String {
          
          return self.replacingOccurrences(of: "+", with: "")
      }
    
    func toDictionary() -> [String : Any?]? {
        
        let data = Data(self.utf8)
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any?]
            return dictionary
            
        } catch {
            
            return nil
        }
    }
}

// MARK:- Concatenate two attributed String

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}


