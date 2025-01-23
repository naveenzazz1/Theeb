//
//  TemplateCell.swift
//  Theeb Rent A Car App
//
//  Created by Tariq Maged on 16/03/2022.
//

import UIKit

class TemplateCell: UICollectionViewCell {

    //outlets
    @IBOutlet weak var containerView: TemplateMemberView!
    
    //vars
    static var identifier:String {
       String(describing: TemplateCell.self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = frame.height/16
    }

    func configCell(member:MemberImages,delegate:TemplateMemberViewDelegate?){
        containerView.configTemplateView(member: member)
        containerView.memberElment = member.memberElemnt
        containerView.memberDelegate = delegate
    }
}
