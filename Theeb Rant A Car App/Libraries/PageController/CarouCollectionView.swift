//
//  CarouCollectionView.swift
//  ETCarouSwift
//
//  Created by Elena Slovushch on 31/01/2020.
//  Copyright © 2020 ElenaSlovushch. All rights reserved.
//

import UIKit

class CarouCollectionView: UICollectionView {

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, imagesCount:Int, contentOffsetX:CGFloat) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.isScrollEnabled = true
        let contentWidth = CGFloat(imagesCount * Int(frame.width))
        self.contentSize = CGSize(width: contentWidth, height: frame.height)
        self.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: false)
        self.isPagingEnabled = true
        self.alwaysBounceHorizontal = false
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        let albumNib = UINib(nibName: "TemplateCell", bundle: nil)
        self.register(albumNib, forCellWithReuseIdentifier: TemplateCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
