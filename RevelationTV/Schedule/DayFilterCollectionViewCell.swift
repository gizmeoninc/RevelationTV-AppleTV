//
//  DayFilterCollectionViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 02/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit

class DayFilterCollectionViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.textColor = .white
            nameLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
        }
    }
    var dayItem: String? {        didSet{
            if dayItem != nil{
                self.nameLabel.text = dayItem
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 2
       
        // Initialization code
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.isFocused{
            self.backgroundColor = ThemeManager.currentTheme().ButtonBorderColor
        }
        else{
            self.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            
        }
    }
}
