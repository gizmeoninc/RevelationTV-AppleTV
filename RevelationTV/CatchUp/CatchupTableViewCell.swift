//
//  CatchupTableViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 08/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol CatchupTableViewCellDelegate:class {
    func didSelectRemindIcon(passModel :VideoModel?)
    func didSelectOnDemandIcon(passModel :VideoModel?)
}
class CatchupTableViewCell: UITableViewCell {
    @IBOutlet weak var videoImageView: UIImageView!{
        didSet{
            videoImageView.contentMode = .scaleAspectFit
            videoImageView.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var videoTitleLabel: UILabel!{
        didSet{
            videoTitleLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
            videoTitleLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            timeLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
            timeLabel.textColor = ThemeManager.currentTheme().headerTextColor
            timeLabel.textAlignment = .left
        }
    }
    
    @IBOutlet weak var remindMeButton: UIButton!{
        didSet{
            remindMeButton.setTitle("Remind Me", for: .normal)
            let image = UIImage(named: "icon-notification-24")?.withRenderingMode(.alwaysTemplate)
            remindMeButton.setImage(image, for: .normal)
            remindMeButton.tintColor = UIColor.white
            remindMeButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            remindMeButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            remindMeButton.layer.borderWidth = 3.0
            remindMeButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            remindMeButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            remindMeButton.layer.cornerRadius = 30
            remindMeButton.titleLabel?.textAlignment = .center
            remindMeButton.layer.masksToBounds = true
            remindMeButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            remindMeButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            remindMeButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            remindMeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.setTitle("On Demand", for: .normal)
            playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            playButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playButton.layer.borderWidth = 3.0
            playButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            playButton.layer.cornerRadius = 30
            playButton.titleLabel?.textAlignment = .center
            playButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            playButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var videoDescriptionLabel: UILabel!{
        didSet{
            videoDescriptionLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 22)
            videoDescriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
        }
    }
    
    weak var delegate: CatchupTableViewCellDelegate!

    var liveGuideArray: VideoModel? {
      didSet{
          if let name = liveGuideArray?.video_title{
              self.videoTitleLabel.text = name
          }
          if let thumbnail = liveGuideArray?.thumbnail_350_200 {
              if thumbnail.starts(with: "https"){
                  self.videoImageView.sd_setImage(with: URL(string: thumbnail),placeholderImage:UIImage(named: "landscape_placeholder"))
              }
              else{
                  self.videoImageView.sd_setImage(with: URL(string: showUrl + thumbnail),placeholderImage:UIImage(named: "landscape_placeholder"))
              }
          }
          else {
              self.videoImageView.image = UIImage(named: "landscape_placeholder")
          }
          if let description = liveGuideArray?.video_description{
              self.videoDescriptionLabel.text = description
          }
          else{
              self.videoDescriptionLabel.text = ""
          }
          if let time = liveGuideArray?.starttime{
              let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "h:mm a"
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                let startTime = self.convertStringTimeToDate(item: time)
                let timeStart1 = formatter.string(from: startTime)
                self.timeLabel.text = timeStart1
          }
        
      }
    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.main.bounds.width / 3
        let height = (width * 9)/16
        self.imageViewWidth.constant = width
        self.imageViewHeight.constant = height
         
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.playButton.isFocused{
            
            self.playButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.remindMeButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }else if self.remindMeButton.isFocused{
            self.remindMeButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
        else{
            self.remindMeButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    //Button Action
    @IBAction func OnDemandAction(_ sender: Any) {
        delegate.didSelectOnDemandIcon(passModel: liveGuideArray)
    }
    
    @IBAction func remindAction(_ sender: Any) {
      
    }
    
}
