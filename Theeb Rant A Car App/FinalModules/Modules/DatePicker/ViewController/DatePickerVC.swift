//
//  DatePickerVC.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 18/07/1443 AH.
//

import UIKit

class DatePickerVC: BaseViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
        
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.setTitle("date_picker_done".localized, for: .normal)
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text =  viewModel.pickerTitle ?? "date_picker_title".localized
        }
    }
    
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectDateAndDismiss))
            backgroundView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    // MARK: - Variables
    
    lazy var viewModel = DatePickerrViewModel()
    
    
    // MARK: - Initialization
    
    class func initializeFromStoryboard() -> DatePickerVC {
        
        let storyboard = UIStoryboard(name: StoryBoards.Popup, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: DatePickerVC.self)) as! DatePickerVC
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        GoogleAnalyticsManager.logScreenView(screenName:AnalyticsKeys.SelectDate, screenClass: String(describing: DatePickerVC.self))
        AppsFlyerManager.logScreenView(screenName:AnalyticsKeys.SelectDate, screenClass: String(describing: DatePickerVC.self))
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupViewModel()
    }
    
    
    // MARK: - Helper Methods
    
    func setDidSelectDateHandler(_ selectDateCompletion:((_ date: Date) -> Void)?) {
        
        viewModel.didSelectDate = selectDateCompletion
    }
    
    func setPickerDate(_ date: Date?) {
        
        viewModel.pickerDate = date
    }
    
    func setMinimumDate(_ date: Date?) {
        
        viewModel.minimumDate = date
    }
    
    func setMaximumDate(_ date: Date?) {
        
        viewModel.maximumDate = date
    }
    
    func setPickerTitle(_ pickerTitle: String?) {
        
        viewModel.pickerTitle = pickerTitle
    }

    
    // MARK: - Setup
    
    func setupView() {
        
        setupDatePicker()
    }

    func setupViewModel() {
        
        viewModel.presentViewController = { [unowned self] (vc) in
            
            self.present(vc, animated: true, completion: nil)
        }
        
        viewModel.dismiss = { [unowned self] in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        viewModel.setPickerDate = { [unowned self] (date) in
            
            guard let date = date else { return }
            
            self.datePicker.date = date
        }
        
        viewModel.currentPickerDate = { [unowned self] in
            
            return self.datePicker.date
        }
    }
    
    func setupDatePicker() {
        
        datePicker.timeZone = TimeZone(abbreviation: "UTC")
        datePicker.minimumDate = viewModel.minimumDate
        datePicker.maximumDate = viewModel.maximumDate
        
        if let pickerDate = viewModel.pickerDate {
            datePicker.date = pickerDate
        }
    }
    
    
    // MARK: - Actions

    @objc func selectDateAndDismiss() {
        
        viewModel.selectDateAndDismiss(date: datePicker.date)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        viewModel.selectDateAndDismiss(date: datePicker.date)
    }
}
