//
//  DistenationView.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 24/03/2022.
//

import UIKit

class DistenationView:UIView{
    
    var reservationNum:String?{
        didSet{
            btnCopy.addTarget(self, action: #selector(btnCopyPressed(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var lblBookingValue: UILabel!
    @IBOutlet weak var lblStaticBooking: UILabel!
    @IBOutlet weak var lblStaticExtra: UILabel!{
        didSet {
            lblStaticExtra.text = MemberUtility.instance.freeHours
        }
    }
    @IBOutlet weak var lblHintRental: UILabel!
    @IBOutlet weak var lblReturn: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblSourceBranch: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblStaticRentalInfo: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialSetup()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()

    }
    
    func initialSetup() {
    addSubview(loadXibView(with: bounds))
        lblHintRental.text = "rental_rentaInfo".localized
        lblStaticBooking.text = "fleet_bookingNumber".localized
    }
    
    @objc func btnCopyPressed(_ btn:UIButton){
        UIPasteboard.general.string = reservationNum
        let _ = showToast(message: "checkOut_copiedToClip".localized,isNormal:false)
    }
}
