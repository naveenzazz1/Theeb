//
//  TimeChooseView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 28/03/2022.
//

import UIKit
import Firebase

class TimeChooseView:UIView{
    
    //vars
    
    var bufferHours = 2
    var complition:((Date)->())?
    var startDate = Date()
    var scadule: ScheduleModel?{
        didSet{
            if DateTimePickerVC.isPickup {
                
                lblInstruction.text =  String(format: NSLocalizedString("mapLocation_pickShouldBe", comment: ""), bufferHours) + "\(scadule?.startTime ?? "8:00 AM")  " + "profile_to".localized + " \(scadule?.endTime ?? "10:00 PM")"
            } else {
                lblInstruction.text =  String(format: NSLocalizedString("mapLocation_ReturnShouldBe", comment: ""), bufferHours) + "\(scadule?.startTime ?? "8:00 AM")  " + "profile_to".localized + " \(scadule?.endTime ?? "10:00 PM")"
            }
        }
    }
    var superVc:UIViewController?
    lazy var reqDate = DateTimePickerVC.isPickup ? DateTimePickerVC.pickupDateForPicker:(DateTimePickerVC.returnDateForPicker ?? DateTimePickerVC.pickupDateForPicker)
   
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var lblInstruction: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialSetup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()

    }
    
    func getDatesFromRemoteConfig() -> Int{
        let remoteConfig = RemoteConfig.remoteConfig()
         let bufferHours = remoteConfig["reservation_buffer_hours"].numberValue
        return Int(truncating: bufferHours)
    }
    
    func initialSetup() {
        
        
        addSubview(loadXibView(with: bounds))
        Formatter.time.defaultDate = Calendar.current.startOfDay(for: Date())
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 5
       // timePicker.timeZone = TimeZone(identifier: "Asia/Riyadh")
        lblDays.text = DateTimePickerVC.isPickup ? "mapLocation_selectPickTime" .localized:"mapLocation_selectReturnTime".localized
        btnConfirm.setTitle(DateTimePickerVC.isPickup ? "mapLocation_selectPickTime".localized:"mapLocation_selectReturnTime".localized, for: .normal)
        btnConfirm.addTarget(self, action: #selector(btnConfirmPessed), for: .touchUpInside)
        bufferHours = getDatesFromRemoteConfig()
        if DateTimePickerVC.isPickup {
            
            lblInstruction.text =  String(format: NSLocalizedString("mapLocation_pickShouldBe", comment: ""), bufferHours) + "\(scadule?.startTime ?? "8:00 AM")  " + "profile_to".localized + " \(scadule?.endTime ?? "10:00 PM")"
        } else {
            lblInstruction.text =  String(format: NSLocalizedString("mapLocation_ReturnShouldBe", comment: ""), bufferHours) + "\(scadule?.startTime ?? "8:00 AM")  " + "profile_to".localized + " \(scadule?.endTime ?? "10:00 PM")"
        }
     //   lblInstruction.text =  String(format: NSLocalizedString("mapLocation_ShouldBe", comment: ""), bufferHours) + "\n" + String(format: NSLocalizedString("mapLocation_ReturnShouldBe", comment: ""), bufferHours) + "\(scadule?.startTime ?? "8:00 AM")  " + "profile_to".localized + " \(scadule?.endTime ?? "10:00 PM")"

    }
    
    func setMinAndMaxDateNewLogic(){
        guard let pickUpId = DateTimePickerVC.isPickup ? HomeVC.branchStateTuble.pickupBranch:(HomeVC.branchStateTuble.returnBranch ?? HomeVC.branchStateTuble.pickupBranch),let pickupBranchObject = CachingManager.locations()?.filter({ $0?.branchCode == pickUpId}).first as? Branch else {return}
        scadule = getTodayTiming(scaduleArr: pickupBranchObject.schedule)
        setDateForTimePicker()
    }
    
//    func setDateForTimePicker(){
//        let minTime = Formatter.time.date(from: scadule?.startTime ?? "8:00")!
//        let maxTime = Formatter.time.date(from:scadule?.endTime ?? "22:00")!
//        timePicker.minimumDate = minTime
//        timePicker.maximumDate = maxTime
//        if !DateTimePickerVC.isPickup {
//            if (minTime...maxTime).contains(startDate){
//                timePicker.date = startDate
//            }
//        }
//    }
    
    func setDateForTimePicker() {
        guard let startTime = scadule?.startTime, let endTime = scadule?.endTime else {
            return
        }

        let minTime: Date
        let maxTime: Date

        if endTime == "24:00" {
            // Replace "24:00" with "00:00" and use the next day's date
            let calendar = Calendar.current
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let correctedEndTime = dateFormatter.date(from: "00:00") ?? Date()
            minTime = Formatter.time.date(from: startTime) ?? Date()
            maxTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: tomorrow) ?? Date()
            
            timePicker.minimumDate = minTime
            timePicker.maximumDate = maxTime

            if !DateTimePickerVC.isPickup {
                if (minTime...maxTime).contains(startDate) {
                    timePicker.date = startDate
                }
            }
        } else {
            minTime = Formatter.time.date(from: startTime) ?? Date()
            maxTime = Formatter.time.date(from: endTime) ?? Date()
            
            timePicker.minimumDate = minTime
            timePicker.maximumDate = maxTime

            if !DateTimePickerVC.isPickup {
                if (minTime...maxTime).contains(startDate) {
                    timePicker.date = startDate
                }
            }
        }
    }

    func getCurrentDateInSaudiArabia() -> Date {
        let saudiArabiaTimeZone = TimeZone(identifier: "Asia/Riyadh")
        let now = Date()
        let saudiArabiaDate = Calendar.current.date(byAdding: .second, value: saudiArabiaTimeZone?.secondsFromGMT(for: now) ?? 0, to: now) ?? Date()
        return saudiArabiaDate
    }

   

    
    func differenceInMinutes(from startDate: Date, to endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: startDate, to: endDate)
        
        if let minutes = components.minute {
            return minutes
        }
        
        return 0
    }

    
    func validateBranchTime()->Bool{
        let dateNow = Date()
        let datePicker = timePicker.date
    
        if let reqDate = reqDate{
            let differnceDays = Calendar.current.dateComponents([.day], from: dateNow, to: reqDate).day ?? 0
            let diffDays = DateUtils.subtractDays(startDate: dateNow, endDate: reqDate)
            if max(differnceDays,diffDays) > 0{
                return true
            }else{
                let maxTime = Formatter.time.date(from:scadule?.endTime ?? "22:00")!

                let timeAfter4Hours = Calendar.current.date(byAdding: .hour, value: bufferHours, to: dateNow) ?? dateNow
                print(datePicker , "datePicker \n", "timeAfter4Hours = \(timeAfter4Hours)" )
                if datePicker < dateNow {
                    return false
                }
                print(datePicker >= timeAfter4Hours , datePicker <= maxTime)
                if datePicker >= timeAfter4Hours && datePicker <= maxTime {
                    return true
                    
                }
            }
        }
        return false
    }
    
    
 
    func getTodayTiming(scaduleArr:[ScheduleModel]?)->ScheduleModel?{
        guard let scaduleArr = scaduleArr,  let date = DateTimePickerVC.isPickup ? DateTimePickerVC.pickupDateForPicker:DateTimePickerVC.returnDateForPicker else {return nil}
        let day = Calendar.current.dateComponents([.weekday], from: date).weekday ?? 1
        for i in scaduleArr.indices{
            if scaduleArr[i].dayCode == day {
                return scaduleArr[i]
            }
        }
        return nil
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        var loc = Locale(identifier: "uk")
        for currentView in timePicker.subviews {
            if isLanguageChanged {
                if UIApplication.isRTL(){
                loc = Locale(identifier: "ar")
                timePicker.locale = loc
                currentView.semanticContentAttribute = .forceRightToLeft
                }else{
                loc = Locale(identifier: "en")
                timePicker.locale = loc
                currentView.semanticContentAttribute = .forceLeftToRight
                }
            }
        }
    }
    
    @objc func btnConfirmPessed() {
        if !validateBranchTime(){
            //let _ = showToast(message: DateTimePickerVC.isPickup ? "mapLocation_ShouldBe".localized :"mapLocation_ReturnShouldBe".localized)
            let _ = showToast(message: DateTimePickerVC.isPickup ? String(format: NSLocalizedString("mapLocation_ShouldBe", comment: ""), bufferHours) : String(format: NSLocalizedString("mapLocation_ReturnShouldBe", comment: ""), bufferHours))
            
            return
        }
        startDate = DateTimePickerVC.isPickup ? timePicker.date:Date()
        complition?(timePicker.date)
        superview?.removeFromSuperview()
        
        if let superVc = superVc {
            superVc.addFadeBackground(false, color: nil)
        }
    }
}

