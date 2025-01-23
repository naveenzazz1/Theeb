//
//  String + Validation.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 01/05/1443 AH.
//

import UIKit

extension String {
    
    func isValidSaudiOrIqama() -> Bool {
        guard let firstCharacter = self.first, firstCharacter.isNumber else { return false }
        
        let startsWithOneOrTwo = firstCharacter == "1" || firstCharacter == "2"
        let isValidLength = startsWithOneOrTwo && self.count == 10
        let containsOnlyNumbers = self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        
        return startsWithOneOrTwo && isValidLength && containsOnlyNumbers
    }
    
    func isValidPassport() -> Bool {
        return self.count > 7
    }
    
//    func isIDValid() -> (startsWithOneOrTwo: Bool, isValid: Bool) {
//        // Check if the first character is a digit
//        guard let firstCharacter = self.first, firstCharacter.isNumber else {
//            // Assume it's valid if it starts with non-digit characters and its length is greater than 7
//            return (startsWithOneOrTwo: false, isValid: self.count > 7)
//        }
//        
//        // Check if the ID starts with 1 or 2
//        let startsWithOneOrTwo = firstCharacter == "1" || firstCharacter == "2"
//        
//        // Check if the ID length is 10 when it starts with 1 or 2, otherwise check if it's greater than 7
//        let isValidLength = startsWithOneOrTwo ? self.count == 10 : self.count > 7
//        
//        // Check if the ID contains only digits when it starts with 1 or 2
//        let isValidFormat = startsWithOneOrTwo ? self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil : true
//        
//        // Return the validation results
//        return (startsWithOneOrTwo, isValidLength && isValidFormat)
//    }

    
    func sliceFullname()->(String?,String?){
        let loginObject = CachingManager.loginObject()
          var components = self.components(separatedBy: " ")
          if components.count > 0 {
           let firstName = components.removeFirst()
           let lastName = components.joined(separator: " ")
           return (firstName,lastName)
          }
        return(loginObject?.firstName,loginObject?.lastName)
    }
    
    func isValidEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return evaluteWithFormat(emailFormat)
    }
    
    func isValidPassword() -> Bool {
        
        let passwordFormat = "^(?=.*[0-9٠-٩])(?=.*[A-Za-zء-ي]).{6,}$"
        return evaluteWithFormat(passwordFormat)
    }
    
    func isValidMobile() -> Bool {
        
        let mobileFormat = "^[0-9٠-٩]{8,16}$"
        return evaluteWithFormat(mobileFormat)
    }
    
    func isValidDocumentId() -> Bool {
        
        let documentIdFormat = "^(10|١٠)[0-9٠-٩]{8}$"
        return evaluteWithFormat(documentIdFormat)
    }
    
    func isValidResidencyNumber() -> Bool {
        
        let residencyFormat = "^(2|٢)[0-9٠-٩]{9}$"
        return evaluteWithFormat(residencyFormat)
    }
    
    func isValidName() -> Bool {
        
        let userNameFormat = "^[\\u0600-\\u06FFa-zA-Z\\s'’]+$"
        return evaluteWithFormat(userNameFormat)
        
    }
    
    func isValidPaymentCardExpirationCard() -> Bool {
        
        let paymentCardExpirationCardFormat = "(0[1-9]|1[0-2])/[0-9]{2}"
        return evaluteWithFormat(paymentCardExpirationCardFormat)
    }
    
    func evaluteWithFormat(_ format: String) -> Bool {
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", format)
        return emailPredicate.evaluate(with: self)
    }
    
    var html2Attributed: NSAttributedString? {
        do {
          guard let data = data(using: String.Encoding.utf8) else {
            return nil
          }
          return try NSAttributedString(data: data,
                         options: [.documentType: NSAttributedString.DocumentType.html,
                              .characterEncoding: String.Encoding.utf8.rawValue],
                         documentAttributes: nil)
        } catch {
          print("error: ", error)
          return nil
        }
      }
}
