//
//  CustomHeader.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 14/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol CustomHeaderDelegate: class {
    func customHeader(_ customHeader: CustomHeader, didTapButtonInSection section: Int)
}
class CustomHeader: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var moreButton: UIButton!{
        didSet{
            moreButton.setTitle("More", for: .normal)
            let image = UIImage(named: "plus-icon")?.withRenderingMode(.alwaysTemplate)
            moreButton.setImage(image, for: .normal)
            moreButton.tintColor = UIColor.white
            moreButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            moreButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            moreButton.layer.borderWidth = 3.0
            moreButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            moreButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            moreButton.layer.cornerRadius = 25
            moreButton.titleLabel?.textAlignment = .center
            moreButton.layer.masksToBounds = true
//            moreButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            moreButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            moreButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            moreButton.contentHorizontalAlignment = .left
            moreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);            moreButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

        }
    }
    
    @IBOutlet weak var dividerView: UIView!
    
    @IBOutlet weak var customLabel: UILabel!{
        didSet{
            customLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 40)
            customLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    static let reuseIdentifier = "CustomHeader"
    var sectionNumber: Int!
    weak var delegate: CustomHeaderDelegate?

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.moreButton.isFocused{
            self.moreButton.backgroundColor = ThemeManager.currentTheme().focusedColor
        }
        else{
            self.moreButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

        }
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        delegate?.customHeader(self, didTapButtonInSection: sectionNumber)
    }
    
}
