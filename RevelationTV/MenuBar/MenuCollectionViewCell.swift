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
                self.menuLabel.textColor = .white
        
            } else {
                self.menuLabel.textColor = .gray
            }
        }
}
