//
//  VideoDetailsScheduleCollectionViewCell.swift
//  RevelationTV
//
//  Created by sinitha sidharthan on 15/12/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit

class VideoDetailsScheduleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ScheduleTimeLabel: UILabel!{
        didSet{
            self.ScheduleTimeLabel.textColor = ThemeManager.currentTheme().buttonTextColor
            self.ScheduleTimeLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
        }
    }
    
  override func awakeFromNib() {
        super.awakeFromNib()
  
        // Initialization code
    }
}
