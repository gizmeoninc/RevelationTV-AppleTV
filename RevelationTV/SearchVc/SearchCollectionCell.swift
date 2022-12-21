//
//  SearchCollectionCell.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 15/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class SearchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var videoNameLabel: UILabel!{
        didSet{
            self.videoNameLabel.font = UIFont(name: ThemeManager.currentTheme().fontDefault, size: 24)
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        imageView.backgroundColor = .clear
        //        imageView.adjustsImageWhenAncestorFocused = true
    }
    fileprivate  let scaleFactor: CGFloat = 1.15
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if context.nextFocusedView == self {
            self.layer.borderWidth = 4.0
            self.layer.borderColor = UIColor.white.cgColor
    
        } else {
            self.layer.borderWidth = 0.0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
