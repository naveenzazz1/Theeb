//
//  CustomBtnLoader.swift
//  Theeb Rent A Car App
//
//  Created by Moustafa Gadallah on 22/10/1443 AH.
//


import UIKit

class LoadingButton: UIButton {
private var originalButtonText: String?
var activityIndicator: UIActivityIndicatorView!

func showLoading() {
    
    originalButtonText = self.titleLabel?.text
    self.setTitle("", for: .normal)
    self.setAttributedTitle(nil, for: .normal)
    
    if (activityIndicator == nil) {
        activityIndicator = createActivityIndicator()
    }
    
    showSpinning()
}

func hideLoading() {
    self.setTitle(originalButtonText, for: .normal)
    let attributedString = NSMutableAttributedString(string: originalButtonText ?? "")
    self.setAttributedTitle(attributedString, for: .normal)
    activityIndicator.stopAnimating()
}

private func createActivityIndicator() -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = .darkGray
    return activityIndicator
}

private func showSpinning() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(activityIndicator)
    centerActivityIndicatorInButton()
    activityIndicator.startAnimating()
}

private func centerActivityIndicatorInButton() {
    let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
    self.addConstraint(xCenterConstraint)
    
    let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
    self.addConstraint(yCenterConstraint)
}
}
