//
//  DatePickerViewModel.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 18/07/1443 AH.
//


import UIKit

class DatePickerrViewModel {

    // MARK: - Variables
    
    var pickerDate: Date?
    var minimumDate: Date?
    var maximumDate: Date?
    var pickerTitle: String?

    var presentViewController: ((_ vc: UIViewController) -> Void)?
    var dismiss: (() -> Void)?
    var setPickerDate: ((_ date: Date?) -> Void)?
    var currentPickerDate: (() -> (Date?))?
    
    var didSelectDate: ((_ date: Date) -> Void)?

    
    // MARK: - Actions

    func selectDateAndDismiss(date: Date) {
        
        dismiss?()
        didSelectDate?(date)
    }
}
