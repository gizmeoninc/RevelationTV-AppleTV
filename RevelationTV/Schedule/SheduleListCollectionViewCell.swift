//
//  SheduleListCollectionViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 02/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol SheduleListCollectionViewCellDelegate:class {
    func didSelectOnDemand(passModel :VideoModel?)
    func didSelectReminder(passModel :VideoModel?)
}
class SheduleListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.layer.cornerRadius = 25
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            timeLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
            timeLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.setTitle("On Demand", for: .normal)
            playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            playButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playButton.layer.borderWidth = 3.0
            playButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 20)
            playButton.layer.cornerRadius = 28
            playButton.titleLabel?.textAlignment = .center
            playButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            playButton.layer.masksToBounds = true
           
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
            nameLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            descriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            descriptionLabel.numberOfLines = 6
        }
    }
    
    @IBOutlet weak var watchListButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var watchListButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var watchlistButton: UIButton!{
        didSet{
            watchlistButton.setTitle("Remind Me", for: .normal)
            let image = UIImage(named: "icon-notification-24")?.withRenderingMode(.alwaysTemplate)
            watchlistButton.setImage(image, for: .normal)
            watchlistButton.tintColor = UIColor.white
            watchlistButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            watchlistButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            watchlistButton.layer.borderWidth = 3.0
            watchlistButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 20)
            watchlistButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            watchlistButton.layer.cornerRadius = 28
            watchlistButton.titleLabel?.textAlignment = .center
            watchlistButton.layer.masksToBounds = true
            watchlistButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchlistButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchlistButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchlistButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    var scheduleItem: VideoModel? {
        didSet{
            
            if  scheduleItem?.thumbnail_350_200 != nil {
                let image =  scheduleItem?.thumbnail_350_200
                if image!.starts(with: "https"){
                    self.imageView.sd_setImage(with: URL(string: ((scheduleItem?.thumbnail_350_200)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    
                }
                else{
                    self.imageView.sd_setImage(with: URL(string: showUrl + (scheduleItem?.thumbnail_350_200!)!),placeholderImage:UIImage(named: "landscape_placeholder"))
                }
                
            }
            else {
                self.imageView.image = UIImage(named: "landscape_placeholder")
            }
            if  scheduleItem?.thumbnail != nil {
                let image =  scheduleItem?.thumbnail
                if image!.starts(with: "https"){
                    self.imageView.sd_setImage(with: URL(string: ((scheduleItem?.thumbnail)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    
                }
                else{
                    self.imageView.sd_setImage(with: URL(string: showUrl + (scheduleItem?.thumbnail!)!),placeholderImage:UIImage(named: "landscape_placeholder"))
                }
                
            }
            else {
                self.imageView.image = UIImage(named: "landscape_placeholder")
            }
            if scheduleItem?.video_title != nil{
                self.nameLabel.text = scheduleItem?.video_title
            }
            if scheduleItem?.video_description != nil{
                self.descriptionLabel.text = scheduleItem?.video_description
            }
            if let time = scheduleItem?.starttime{
                let formatter = DateFormatter()
                  formatter.timeZone = TimeZone.current
                  formatter.dateFormat = "h:mm a"
                  formatter.amSymbol = "AM"
                  formatter.pmSymbol = "PM"
                  let startTime = self.convertStringTimeToDate(item: time)
                  let timeStart1 = formatter.string(from: startTime)
                  self.timeLabel.text = timeStart1
                
            }
            if (scheduleItem?.schedule_reminded)!{
                addReminder = true
                self.watchlistButton.setImage(UIImage(named: ""), for: .normal)
                self.watchlistButton.setTitle("Remove from list", for: .normal)
                self.watchListButtonWidth.constant = 250
                self.watchListButtonHeight.constant = 55
                
            }
            else{
                addReminder = false
                self.watchlistButton.setTitle("Remind Me", for: .normal)
                let image = UIImage(named: "icon-notification-24")?.withRenderingMode(.alwaysTemplate)
                self.watchlistButton.setImage(image, for: .normal)
                self.watchListButtonWidth.constant = 220
                self.watchListButtonHeight.constant = 55
            }
          
        }
    }
    weak var delegate: SheduleListCollectionViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        let width =  (UIScreen.main.bounds.width/3)
        self.imageViewWidth.constant = width
        self.imageViewHeight.constant = ((width)*9)/16
        // Initialization code
    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.playButton.isFocused{
            playButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            watchlistButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
        else if self.watchlistButton.isFocused{
            watchlistButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
        else{
            watchlistButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
             
    }
    
    
    
    //Button Action
    @IBAction func onDemandAction(_ sender: Any) {
        delegate.didSelectOnDemand(passModel: scheduleItem)
    }
    
    @IBAction func watchlistAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            delegate.didSelectReminder(passModel: scheduleItem)
        }else{
            self.addToReminderAPI()

        }
        
    }
    
    
    var addReminder = false

   
    
    func addToReminderAPI() {
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "ios-phone"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let shedule_id =  scheduleItem?.id {
            parameterDict["schedule_id"] = String(shedule_id)
            parameterDict["cancel"] = String((scheduleItem?.schedule_reminded)!)
          
        }
       
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(parameterDict)
             ApiCallManager.apiCallREST(mainUrl: GetRemindAPI, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: data) { (responseDictionary: Dictionary) in
                var channelResponse = Dictionary<String, AnyObject>()
                guard let succes = responseDictionary["success"] as? NSNumber  else {
                  return
                }
//
                if succes == 0{
                    DispatchQueue.main.async {
                    }
                }
                else if succes == 1 {
                    DispatchQueue.main.async {
                        self.addReminder = !self.addReminder

                        if self.addReminder  {
                            self.watchlistButton.setImage(UIImage(named: ""), for: .normal)
                            self.watchlistButton.setTitle("Remove from list", for: .normal)
                            self.watchListButtonWidth.constant = 250
                            self.watchListButtonHeight.constant = 55
   
                        } else {
                            self.watchlistButton.setTitle("Remind Me", for: .normal)
                            let image = UIImage(named: "icon-notification-24")?.withRenderingMode(.alwaysTemplate)
                            self.watchlistButton.setImage(image, for: .normal)
                            self.watchListButtonWidth.constant = 220
                            self.watchListButtonHeight.constant = 55
                        }
                        self.delegate.didSelectReminder(passModel: self.scheduleItem)
                    }
                  }
                else {
                  channelResponse["error"]=responseDictionary["message"]
                }
            }

        }
    
    
    
}
