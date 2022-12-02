//
//  OnDemandCollectionViewCell.swift
//  RevelationTV
//
//  Created by Firoze Moosakutty on 29/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
protocol  OnDemandCollectionViewCellDelegate:class {
//    func didSelectWatchlist(passModel :VideoModel?)
    func didSelectPlayIcon(passModel :VideoModel?)
    func didSelectMoreInfo(passModel: VideoModel?)
}
class OnDemandCollectionViewCell: UICollectionViewCell {
    
    var once = true

    
    @IBOutlet weak var outerImageView: UIImageView!{
        didSet{
            outerImageView.contentMode = .redraw
        }
    }
    
    @IBOutlet weak var innerImageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var innerImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var innerImageView: UIImageView!{
        didSet{
            innerImageView.layer.cornerRadius = 16
            innerImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var transparentView: UIView!{
        didSet{
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    @IBOutlet weak var showDescriptionLabel: UILabel!{
        didSet{
            showDescriptionLabel.numberOfLines = 3
            self.showDescriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            self.showDescriptionLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size:25)
          }
    }
    
    @IBOutlet weak var showTitleLabel: UILabel!{
        didSet{
            self.showTitleLabel.textColor = ThemeManager.currentTheme().headerTextColor
            self.showTitleLabel.font = UIFont.init(name: ThemeManager.currentTheme().fontBold, size:40)
//            self.showTitleLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size:40)

        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.setTitle("Play", for: .normal)
            let image = UIImage(named: "icons8-play-26")?.withRenderingMode(.alwaysTemplate)
            playButton.setImage(image, for: .normal)
            playButton.tintColor = UIColor.white
            playButton.backgroundColor = ThemeManager.currentTheme().ButtonBorderColor
            playButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playButton.layer.borderWidth = 3.0
            playButton.titleLabel?.font =  UIFont.init(name:"ITCAvantGardePro-Bk", size: 25)
            playButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            playButton.layer.cornerRadius = 10
            playButton.titleLabel?.textAlignment = .center
            playButton.layer.masksToBounds = true
            playButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    
    @IBOutlet weak var MoreInfoButton: UIButton!{
        didSet{
            MoreInfoButton.setTitle("More Info", for: .normal)
            MoreInfoButton.setImage(UIImage(named: "plus-icon"), for: .normal)
            MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
            MoreInfoButton.layer.borderWidth = 3.0
            MoreInfoButton.titleLabel?.font =  UIFont(name:"ITCAvantGardePro-Bk", size: 25)
            MoreInfoButton.layer.cornerRadius = 10
            MoreInfoButton.titleLabel?.textAlignment = .center
            MoreInfoButton.layer.masksToBounds = true
            MoreInfoButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    
    @IBOutlet weak var moreInfoButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoButtonWidth: NSLayoutConstraint!
    
    @IBAction func playAction(_ sender: Any) {
        delegate.didSelectPlayIcon(passModel: fetauredItem)
    }
    
    @IBAction func moreInfoAction(_ sender: Any) {
        delegate.didSelectMoreInfo(passModel: fetauredItem)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ThemeManager.currentTheme().buttonColorDark
//        let width = (UIScreen.main.bounds.width/3)
//        let height = (width*9)/16
//        innerImageViewHeight.constant = height
//        innerImageViewWidth.constant = width
        // self.layoutIfNeeded()
    }
    
    weak var delegate: OnDemandCollectionViewCellDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    var fetauredItem: VideoModel? {
        didSet{
            if fetauredItem?.logo_thumb != nil {
                self.outerImageView.sd_setImage(with: URL(string: ((fetauredItem?.logo_thumb)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                self.innerImageView.sd_setImage(with: URL(string: ((fetauredItem?.logo_thumb)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            } else {
                self.outerImageView.image = UIImage(named: "landscape_placeholder")
                self.innerImageView.image = UIImage(named: "landscape_placeholder")
            }
            if fetauredItem?.show_name != nil{
                self.showTitleLabel.text = fetauredItem?.show_name
            }
            if fetauredItem?.synopsis != nil{
                self.showDescriptionLabel.text = fetauredItem?.synopsis
            }
            
               if self.once {
                   if let video = self.fetauredItem{
//                      watchFlag()
               }
            }
        }
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if playButton.isFocused{
            self.playButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.playButton.layer.borderWidth = 0
            self.MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.MoreInfoButton.layer.borderWidth = 3.0
        }
        else if MoreInfoButton.isFocused{
                self.MoreInfoButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.MoreInfoButton.layer.borderWidth = 0
                self.playButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            self.playButton.layer.borderWidth = 3.0
        }
        else{
            self.MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.MoreInfoButton.layer.borderWidth = 3.0
            self.playButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            self.playButton.layer.borderWidth = 3.0
        }
    }
    
}
