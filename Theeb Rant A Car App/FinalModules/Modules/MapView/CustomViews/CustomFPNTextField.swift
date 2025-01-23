//
//  CustomFPNTextField.swift
//  Theeb Rent A Car App
//
//  Created by ahmed elshobary on 15/07/2024.
//

import Foundation
import UIKit
import FlagPhoneNumber

class CustomFPNTextField: FPNTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeFlagButton()
    }
    
    private func customizeFlagButton() {
        // Set the button size
        flagButton.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        
        // Create a container view for the flag and arrow
        let containerView = UIView(frame: flagButton.frame)
        
        // Create and configure the flag image view
        let flagImageView = UIImageView(image: flagButton.image(for: .normal))
        flagImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        flagImageView.contentMode = .scaleAspectFit
        containerView.addSubview(flagImageView)
        
        // Create and configure the arrow image view
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrowImageView.frame = CGRect(x: 40, y: 0, width: 20, height: 40)
        arrowImageView.contentMode = .scaleAspectFit
        containerView.addSubview(arrowImageView)
        
        // Clear existing subviews and add the container view to the flag button
        flagButton.subviews.forEach { $0.removeFromSuperview() }
        flagButton.addSubview(containerView)
    }
}
