//
//  PopularCollectionViewCell.swift
//  tvOsSampleApp
//
//  Created by Firoze Moosakutty on 25/07/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import TVUIKit
import SDWebImage

class PopularCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var progressBar: UIProgressView!{
        didSet{
            progressBar.isHidden = true
            progressBar.progressTintColor = ThemeManager.currentTheme().focusedColor
            progressBar.trackTintColor = ThemeManager.currentTheme().descriptionTextColor
//            progressBar.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var progressBarHeight: NSLayoutConstraint!{
        didSet{
            progressBarHeight.constant = 15
        }
    }
    @IBOutlet weak var videoImageView: UIImageView!{
        didSet {
               videoImageView.layer.cornerRadius = 10
                videoImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                videoImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var moreButton: UIButton!{
        didSet{
            moreButton.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            nameLabel.font = UIFont(name: "ITCAvantGardePro-Bk", size: 24)
        }
    }
  
    @IBOutlet weak var videoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var liveLabel: UILabel!{
        didSet{
            liveLabel.layer.cornerRadius = 8
            liveLabel.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let width =  UIScreen.main.bounds.width / 4.5
        let height = (9 * (width - 30)) / 16
        
        self.videoImageHeight.constant = height
      
        // self.layoutIfNeeded()
    }
    internal var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    /// public property to store the text for the title image
    internal var titleImage: String! {
        didSet {
            titleImageView.sd_setImage(with: URL(string: titleImage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!),placeholderImage:UIImage(named: "placeHolder"))
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.moreButton.isFocused
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    fileprivate  let scaleFactor: CGFloat = 1.1
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView == self {
            self.videoImageView.layer.borderWidth = 6.0
            self.videoImageView.layer.borderColor = UIColor.white.cgColor
        } else {
            self.videoImageView.layer.borderWidth = 0.0
            self.videoImageView.layer.shadowRadius = 0.0
            self.videoImageView.layer.shadowOpacity = 0
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    internal func setupUI() {
        titleLabel = UILabel()
        titleImageView = UIImageView()
        titleLabel.isHidden = true
        titleImageView.isHidden = true
    }
    
    fileprivate var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .white
            titleLabel.font = titleLabel.font.withSize(30)
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            
            addSubview(titleLabel)
            titleLabel.isHidden = true
        }
    }
    fileprivate var titleImageView: UIImageView! {
        didSet {
//            titleImageView.adjustsImageWhenAncestorFocused = true
            addSubview(titleImageView)
        }
    }
    
}

