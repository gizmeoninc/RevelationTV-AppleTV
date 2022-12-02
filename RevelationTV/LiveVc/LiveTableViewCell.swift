//
//  LiveTableViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 02/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol LiveTableViewCellDelegate:class {
    func didSelectPlay(passModel :VideoModel?)
}
class LiveTableViewCell: UITableViewCell {
    @IBOutlet weak var livePlayerView: UIView!
    @IBOutlet weak var livePlayerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var livePlayerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var upnextView: UIView!{
        didSet{
            upnextView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
           
        }
    }
    @IBOutlet weak var nowPlayingView: UIView!{
        didSet{
            nowPlayingView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            
        }
    }
    @IBOutlet weak var nowPlayingHeaderView: UIView!{
        didSet{
            nowPlayingHeaderView.backgroundColor = ThemeManager.currentTheme().focusedColor
            nowPlayingHeaderView.layer.cornerRadius = 8
            nowPlayingHeaderView.layer.masksToBounds = true

        }
    }
    @IBOutlet weak var nowPlayingHeaderLabel: UILabel!{
        didSet{
            nowPlayingHeaderLabel.backgroundColor = ThemeManager.currentTheme().focusedColor
            nowPlayingHeaderLabel.textColor = ThemeManager.currentTheme().headerTextColor
            nowPlayingHeaderLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
        }
    }
    @IBOutlet weak var upNextHeaderView: UIView!
    {
        didSet{
            upNextHeaderView.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
            upNextHeaderView.layer.cornerRadius = 8
            upNextHeaderView.layer.masksToBounds = true
           

        }
    }
    @IBOutlet weak var upNextHeight: NSLayoutConstraint!
    @IBOutlet weak var nowPlayingHeight: NSLayoutConstraint!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var placeholderImage: UIImageView!
    @IBOutlet weak var upNextHeaderLabel: UILabel!{
        didSet{
            upNextHeaderLabel.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
            upNextHeaderLabel.textColor = ThemeManager.currentTheme().headerTextColor
            upNextHeaderLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
        }
    }
    @IBOutlet weak var nowplayingTitleLabel: UILabel!{
        didSet{
            nowplayingTitleLabel.textColor = ThemeManager.currentTheme().headerTextColor
            nowplayingTitleLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
        }
    }
    @IBOutlet weak var nowPlayingTimeLabel: UILabel!{
        didSet{
            nowPlayingTimeLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            nowPlayingTimeLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
        }
    }
    @IBOutlet weak var nowPlayingDescriptionLabel: UILabel!{
        didSet{
            nowPlayingDescriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            nowPlayingDescriptionLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            nowPlayingDescriptionLabel.numberOfLines = 6
        }
    }
    @IBOutlet weak var upnextTitleLabel: UILabel!{
        didSet{
            upnextTitleLabel.textColor = ThemeManager.currentTheme().headerTextColor
            upnextTitleLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
        }
    }
    @IBOutlet weak var upnextTimelabel: UILabel!{
        didSet{
            upnextTimelabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            upnextTimelabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
        }
    }
    @IBOutlet weak var upnextDescriptionLabel: UILabel!
    {
        didSet{
            upnextDescriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            upnextDescriptionLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            upnextDescriptionLabel.numberOfLines = 6
        }
    }
    weak var delegate: LiveTableViewCellDelegate!

    
    
    
    
    
    var scheduleVideos: [VideoModel]? {
        didSet{
            if let nowplayingVideoArray = scheduleVideos?[0].now_playing{
                if nowplayingVideoArray.video_title != nil{
                    self.nowplayingTitleLabel.text = nowplayingVideoArray.video_title
                }else{
                    self.nowplayingTitleLabel.text = ""
                }
                if nowplayingVideoArray.video_description != nil{
                    self.nowPlayingDescriptionLabel.text = nowplayingVideoArray.video_description
                }else{
                    self.nowPlayingDescriptionLabel.text = ""
                }
                let formatter = DateFormatter()
                  formatter.timeZone = TimeZone.current
                  formatter.dateFormat = "h:mm a"
                  formatter.amSymbol = "AM"
                  formatter.pmSymbol = "PM"
              
                if  let startTime = nowplayingVideoArray.start_time {
                    let startTimeConverted = self.convertStringTimeToDate(item: startTime)
                    let timeStart = formatter.string(from: startTimeConverted)
                    self.nowPlayingTimeLabel.text = timeStart
                    
                }else{
                    self.nowPlayingTimeLabel.text = ""
                }
                
            }
            
            if let upnextVideoArray = scheduleVideos?[0].up_next{
                if upnextVideoArray.video_title != nil{
                    self.upnextTitleLabel.text = upnextVideoArray.video_title
                }else{
                    self.upnextTitleLabel.text = ""
                }
                if upnextVideoArray.video_description != nil{
                    self.upnextDescriptionLabel.text = upnextVideoArray.video_description
                }else{
                    self.upnextDescriptionLabel.text = ""
                }
                let formatter = DateFormatter()
                  formatter.timeZone = TimeZone.current
                  formatter.dateFormat = "h:mm a"
                  formatter.amSymbol = "AM"
                  formatter.pmSymbol = "PM"
                if  let startTime = upnextVideoArray.start_time {
                    let startTimeConverted = self.convertStringTimeToDate(item: startTime)
                    let timeStart = formatter.string(from: startTimeConverted)
                    self.upnextTimelabel.text = timeStart
                    
                }else{
                    self.upnextTimelabel.text = ""
                }
                
            }
            
        }
    }
    
//    func convertStringTimeToDate(item: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
//        let date = dateFormatter.date(from:item)!
//        return date
//    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        if item.contains("Z"){
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"

        }
        else{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        }
        let date = dateFormatter.date(from:item)!
        return date
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.main.bounds.width
        self.livePlayerViewWidth.constant = width - (width/3)
         let height = (self.livePlayerViewWidth.constant*9)/16
        self.livePlayerViewHeight.constant = height
        self.nowPlayingHeight.constant = height / 2
        self.upNextHeight.constant =  height / 2
//        self.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        // Initialization code
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        self.backgroundColor = ThemeManager.currentTheme().buttonColorDark
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
