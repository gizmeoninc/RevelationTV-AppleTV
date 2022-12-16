//
//  ChannelHeader.swift
//  RevelationTV
//
//  Created by sinitha sidharthan on 15/12/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

class channelHeader: UICollectionReusableView {

    
    static let identifier = "HeaderCell"
    public let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        if UIDevice.current.userInterfaceIdiom ==  UIUserInterfaceIdiom.pad
        {
            label.font = UIFont.boldSystemFont(ofSize: 24)

        }else{
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        return label
    }()
    public func configure(){
        addSubview(title)
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = bounds
        
    }
}
