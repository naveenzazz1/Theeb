//
//  KeyBoardHandler.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 26/04/1443 AH.
//

import UIKit
import IQKeyboardManagerSwift

class KeyboardHandler: NSObject {
    
    static let shared: KeyboardHandler = {
        return KeyboardHandler()
    }()
    
    func enableHandlingKeyboard() {
        
        setHandlingKeyboard(enable: true)
    }
    
    func disableHandlingKeyboard() {
        
        setHandlingKeyboard(enable: false)
    }
    
    private func setHandlingKeyboard(enable: Bool) {
    
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

}
