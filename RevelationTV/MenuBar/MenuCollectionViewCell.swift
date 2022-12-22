//
//  MenuCollectionViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 09/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var menuLabel: UILabel!{
        didSet{
            menuLabel.textColor = .white
            menuLabel.font = UIFont(name: ThemeManager.currentTheme().fontDefault, size: 25)
        }
    }
    @IBOutlet weak var seperatorLine: UIView!{
        didSet{
            seperatorLine.isHidden = true
        }
    }
    var menuItem: String? {
        didSet{
            if menuItem != nil{
                self.menuLabel.text = menuItem
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
        override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
            super.didUpdateFocus(in: context, with: coordinator)
            if context.nextFocusedView == self {
                self.menuLabel.textColor = ThemeManager.currentTheme().buttonTextColor
                self.seperatorLine.isHidden = false
        
            } else {
                self.menuLabel.textColor = .white
                self.seperatorLine.isHidden = true
            }
        }
}
