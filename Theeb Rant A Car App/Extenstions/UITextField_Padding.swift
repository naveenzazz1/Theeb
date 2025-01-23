//
//  UITextField_Padding.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 30/05/1443 AH.
//

import UIKit

extension UITextField {
    
        func setInputViewDatePicker(target: Any, selector: Selector) {
            // Create a UIDatePicker object and assign to inputView
            let screenWidth = UIScreen.main.bounds.width
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth*0.8, height: 200))//1
            datePicker.datePickerMode = .date //2
            // iOS 14 and above
          //  if #available(iOS 14, *) {// Added condition for iOS 14
              datePicker.preferredDatePickerStyle = .wheels
              datePicker.sizeToFit()
           // }
            self.inputView = datePicker //3
            
            // Create a toolbar and assign it to inputAccessoryView
            let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
            let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
            toolBar.setItems([cancel, flexible, barButton], animated: false) //8
            self.inputAccessoryView = toolBar //9
        }
        
        @objc func tapCancel() {
            self.resignFirstResponder()
        }
        
    
    
    func setTextFieldAttributedPlaceholder (_ localizedString: String?) {
        
        attributedPlaceholder = NSAttributedString(string: localizedString ?? "" , attributes: [
            .foregroundColor: UIColor.weemDarkGray,
//            .font: UIFont.montserratRegular(fontSize: 15)!
        ])
       // textField.textAlignment = Language.isRTL ? .left : .right
    }
    
    func localizeTextFieldBtn(btn:UIView){
        if textAlignment == .left{
            leftView = btn
            leftViewMode = .always
        }else{
            rightView = btn
            rightViewMode = .always
        }
    }
    
    func setLeftPaddingPoints(_ amount: CGFloat, view: UIView? = nil) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = view ?? paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat, view: UIView? = nil) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = view ?? paddingView
        self.rightViewMode = .always
    }

}


private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    func isInputMethod() -> Bool {
        if let positionRange = self.markedTextRange {
            if let _ = self.position(from: positionRange.start, offset: 0) {
                return true
            }
        }
        return false
    }
    
    
    @objc func checkMaxLength(textField: UITextField) {
        
        guard !self.isInputMethod(), let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])
        selectedTextRange = selection
    }
}
