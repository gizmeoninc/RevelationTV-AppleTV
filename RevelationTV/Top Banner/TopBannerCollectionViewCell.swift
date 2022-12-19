//
//  TopBannerCollectionViewCell.swift
//  RevelationTV
//
//  Created by Firoze Moosakutty on 28/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

class TopBannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topBannerImageView: UIImageView!
    
    @IBOutlet weak var topBannerWidth: NSLayoutConstraint!
    
    @IBOutlet weak var topBannerHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
