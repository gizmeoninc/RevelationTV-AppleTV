//
//  DemandCollectionViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 01/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
protocol  DemandCollectionViewCellDelegate:class {
    func didSelectWatchlist(passModel :VideoModel?)
    func didSelectPlayIcon(passModel :VideoModel?)
    func didSelectMoreInfo(passModel :VideoModel?)
}
class DemandCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var outerImageView: UIImageView!{
        didSet{
            outerImageView.contentMode = .redraw
        }
    }
    @IBOutlet weak var transparentView: UIView!{
        didSet{
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    @IBOutlet weak var innaerImageView: UIImageView!{
        didSet{
            innaerImageView.layer.cornerRadius = 16
            innaerImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var innerImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var innerImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.numberOfLines = 6
            self.descriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            self.descriptionLabel.font = UIFont.init(name: ThemeManager.currentTheme().fontRegular, size:20)
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            self.nameLabel.textColor = ThemeManager.currentTheme().headerTextColor
            self.nameLabel.font = UIFont.init(name: ThemeManager.currentTheme().fontBold, size:40)

        }
    }
    @IBOutlet weak var playIcon: UIButton!{
        didSet{
            playIcon.setTitle("Play", for: .normal)
            let image = UIImage(named: "icons8-play-26")?.withRenderingMode(.alwaysTemplate)
            playIcon.setImage(image, for: .normal)
            playIcon.tintColor = UIColor.white
            playIcon.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            playIcon.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playIcon.layer.borderWidth = 3.0
            playIcon.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 20)
            playIcon.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            playIcon.layer.cornerRadius = 28
            playIcon.titleLabel?.textAlignment = .center
            playIcon.layer.masksToBounds = true
            playIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playIcon.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playIcon.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playIcon.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    @IBOutlet weak var myListButton: UIButton!{
        didSet{
            myListButton.setTitle("Add to List", for: .normal)
            myListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
            myListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            myListButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            myListButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            myListButton.layer.borderWidth = 3.0
            myListButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 20)
            myListButton.layer.cornerRadius = 28
            myListButton.titleLabel?.textAlignment = .center
            myListButton.layer.masksToBounds = true
            myListButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            myListButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            myListButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            myListButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    
    @IBOutlet weak var myListButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myListButtonWidth: NSLayoutConstraint!
    
    
    
    var fetauredItem: VideoModel? {
        didSet{
            if fetauredItem?.logo_thumb != nil {
                self.outerImageView.sd_setImage(with: URL(string: ((fetauredItem?.logo_thumb)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                self.innaerImageView.sd_setImage(with: URL(string: ((fetauredItem?.logo_thumb)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            } else {
                self.outerImageView.image = UIImage(named: "landscape_placeholder")
                self.innaerImageView.image = UIImage(named: "landscape_placeholder")
            }
            if fetauredItem?.show_name != nil{
                self.nameLabel.text = fetauredItem?.show_name
            }
            if fetauredItem?.synopsis != nil{
                self.descriptionLabel.text = fetauredItem?.synopsis
            }
            
               if self.once {
                   if let video = self.fetauredItem{
                      watchFlag()
               }
               }
             
        }
        
        
        
        }
    
    
    weak var delegate: DemandCollectionViewCellDelegate!
    var addedeWatchList = false
    var watchVideo = false
    var once = true
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .green
        let width = (UIScreen.main.bounds.width/3)
        let height = (width*9)/16
        innerImageViewHeight.constant = height
        innerImageViewWidth.constant = width
        // self.layoutIfNeeded()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if playIcon.isFocused{
            self.playIcon.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.myListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
        else if myListButton.isFocused{
                self.myListButton.backgroundColor = ThemeManager.currentTheme().focusedColor
                self.playIcon.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            
        }
        else{
            self.myListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.playIcon.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func watchListAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            delegate.didSelectWatchlist(passModel: fetauredItem)
        }else{
            if !watchVideo {
              self.watchVideo = true
              self.watchListShow()
                self.myListButton.setImage(UIImage(named: ""), for: .normal)
                self.myListButton.setTitle("Remove from list", for: .normal)
                self.myListButtonWidth.constant = 250
                self.myListButtonHeight.constant = 55
            } else {
              self.watchVideo = false
              self.watchListShow()
                self.myListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
                self.myListButton.setTitle("Add to List", for: .normal)
                self.myListButtonWidth.constant = 210
                self.myListButtonHeight.constant = 55

            }
        }
        
    }
    @IBAction func playAction(_ sender: Any) {
        delegate.didSelectPlayIcon(passModel: fetauredItem)
    }
    var watchFlagModel = [LikeWatchListModel]()

    func watchFlag() {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["show-id"] = String((fetauredItem?.show_id!)!)
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
      ApiCommonClass.getWatchFlag(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            self.watchVideo = !self.watchVideo

          }
        } else {
          DispatchQueue.main.async {
            self.watchFlagModel = responseDictionary["data"] as! [LikeWatchListModel]
            if self.watchFlagModel.count != 0 {
              if let watch_flag =  self.watchFlagModel[0].watchlist_flag {
                if watch_flag == 1  {
                  self.watchVideo = true
                    self.myListButton.setImage(UIImage(named: ""), for: .normal)
                    self.myListButton.setTitle("Remove from list", for: .normal)
                    self.myListButtonWidth.constant = 250
                    self.myListButtonHeight.constant = 55
                } else {
                  self.watchVideo = false
                    self.myListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
                    self.myListButton.setTitle("Add to List", for: .normal)
                    self.myListButtonWidth.constant = 210
                    self.myListButtonHeight.constant = 55

                }
              }
            }
          }
        }
      }
    }
    func watchListShow() {
        var parameterDict: [String: String?] = [ : ]
        parameterDict["show-id"] = String((fetauredItem?.show_id!)!)
        
        if watchVideo{
            parameterDict["watchlistflag"] = "1"
            parameterDict["deletestatus"] = "0"
        } else {
            parameterDict["watchlistflag"] = "0"
            parameterDict["deletestatus"] = "1"
        }
        
        parameterDict["userId"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        ApiCommonClass.WatchlistShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    self.watchVideo = !self.watchVideo
                }
            } else {
                DispatchQueue.main.async {
                    if self.watchVideo  {
                        self.myListButton.setImage(UIImage(named: ""), for: .normal)
                        self.myListButton.setTitle("Remove from list", for: .normal)
                        self.myListButtonWidth.constant = 250
                        self.myListButtonHeight.constant = 55
                        self.delegate.didSelectWatchlist(passModel: self.fetauredItem)
//                            self.addedeWatchList = true
                    } else {
                        self.myListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
//                            self.addedeWatchList = false
                        self.delegate.didSelectWatchlist(passModel: self.fetauredItem)
                        self.myListButton.setTitle("Add to List", for: .normal)
                        self.myListButtonWidth.constant = 210
                        self.myListButtonHeight.constant = 55
                    }
                    
                }
            }
        }
        
    }
    
    
}
    
