//
//  ReminderListingTableViewCell.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 17/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol ReminderListingTableViewCellDelegate:class {
    func didSelectOnDemand(passModel :VideoModel?)
    func didSelectReminder(passModel :VideoModel?)
}
class ReminderListingTableViewCell: UITableViewCell {
    @IBOutlet weak var scheduleCollectionView: UICollectionView!

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            timeLabel.font = UIFont(name: "ITCAvantGardePro-Bk", size: 20)
            timeLabel.textColor = ThemeManager.currentTheme().buttonTextColor
        }
    }
    
    @IBOutlet weak var ImageView: UIImageView!{
        didSet{
            ImageView.layer.cornerRadius = 25
            ImageView.layer.masksToBounds = true
            ImageView.contentMode = .scaleToFill
            ImageView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    var scheduleVideos: [VideoModel]? {
        didSet{
//            scheduleCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.setTitle("On Demand", for: .normal)
            playButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            playButton.layer.borderColor = ThemeManager.currentTheme().buttonTextColor.cgColor
            playButton.layer.borderWidth = 3.0
            playButton.titleLabel?.font =  UIFont(name: "ITCAvantGardePro-Bk", size: 20)
            playButton.layer.cornerRadius = 10
            playButton.titleLabel?.textAlignment = .center
            playButton.titleLabel?.textColor = UIColor.white
            playButton.layer.masksToBounds = true
           
        }
    }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.font = UIFont(name: "ITCAvantGardePro-Bk", size: 30)
            nameLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.font = UIFont(name: "ITCAvantGardePro-Bk", size: 20)
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
            watchlistButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            watchlistButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            watchlistButton.layer.borderWidth = 3.0
            watchlistButton.titleLabel?.font =  UIFont(name: "ITCAvantGardePro-Bk", size: 20)
            watchlistButton.titleLabel?.textColor = UIColor.white
            watchlistButton.layer.cornerRadius = 10
            watchlistButton.titleLabel?.textAlignment = .center
            watchlistButton.layer.masksToBounds = true
            watchlistButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchlistButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchlistButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchlistButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: -12, right: 0)
        }
    }
    override func layoutSubviews() {
       // Set the width of the cell
//       self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width - 40, height: self.bounds.size.height)
       super.layoutSubviews()
   }
    var scheduleItem: VideoModel? {
        didSet{
            
            if  scheduleItem?.thumbnail_350_200 != nil {
                let image =  scheduleItem?.thumbnail_350_200
                if image!.starts(with: "https"){
                    self.ImageView.sd_setImage(with: URL(string: ((scheduleItem?.thumbnail_350_200)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    
                }
                else{
                    self.ImageView.sd_setImage(with: URL(string: showUrl + (scheduleItem?.thumbnail_350_200!)!),placeholderImage:UIImage(named: "landscape_placeholder"))
                    print("image",showUrl + ((scheduleItem?.thumbnail_350_200!)!))
                }
                
            }
            else {
                self.ImageView.image = UIImage(named: "landscape_placeholder")
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
//                self.watchlistButton.setTitle("Remove from list", for: .normal)
                self.watchlistButton.setTitle("Cancel Reminder", for: .normal)
                self.watchlistButton.titleLabel?.font = UIFont(name: "ITCAvantGardePro-Bk", size: 20)
                let image = UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate)
                self.watchlistButton.setImage(image, for: .normal)
                self.watchListButtonWidth.constant = 240
                self.watchListButtonHeight.constant = 55
                watchlistButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                watchlistButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                watchlistButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                watchlistButton.imageEdgeInsets = UIEdgeInsets(top: -15, left: -17, bottom: -15, right: 0)
                self.watchlistButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -35, bottom: 0, right: -40)
            }
            else{
                addReminder = false
                self.watchlistButton.setTitle("Remind Me", for: .normal)
                let image = UIImage(named: "icon-notification-24")?.withRenderingMode(.alwaysTemplate)
                self.watchlistButton.setImage(image, for: .normal)
                self.watchListButtonWidth.constant = 250
                self.watchListButtonHeight.constant = 55
            }
        }
    }

    @IBOutlet weak var showLibrary: UILabel!
    weak var delegate: ReminderListingTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.bounds = bounds.inset(by: margins)
        // Initialization code
        self.mainView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        let width =  (UIScreen.main.bounds.width/4.5)
        let height = (9 * (width)) / 16
        self.imageViewWidth.constant = width - 60
        self.imageViewHeight.constant = height

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
            watchlistButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
        }
        else if self.watchlistButton.isFocused{
            watchlistButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            playButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
        }
        else{
            watchlistButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            playButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
        }
             
    }

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
                    DispatchQueue.main.async { [self] in
                        self.addReminder = !self.addReminder
                        print("remainder",self.addReminder)
                        if self.addReminder  {
                            self.watchlistButton.setImage(UIImage(named: ""), for: .normal)
//                            self.watchlistButton.setTitle("Remove from list", for: .normal)
                            self.watchlistButton.setTitle("Cancel Reminder", for: .normal)
                            self.watchlistButton.titleLabel?.font = UIFont(name: "ITCAvantGardePro-Bk", size: 20)
                            let image = UIImage(named: "closeButton")?.withRenderingMode(.alwaysTemplate)
                            self.watchlistButton.setImage(image, for: .normal)
                            self.watchListButtonWidth.constant = 240
                            self.watchListButtonHeight.constant = 55
                            self.watchlistButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                            watchlistButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                            self.watchlistButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                            watchlistButton.imageEdgeInsets = UIEdgeInsets(top: -15, left: -17, bottom: -15, right: 0)
                            self.watchlistButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -35, bottom: 0, right: -40)
                        }
                        else {
                            self.watchlistButton.setTitle("Remind Me", for: .normal)
                            let image = UIImage(named: "icon-notification-24")?.withRenderingMode(.alwaysTemplate)
                            self.watchlistButton.setImage(image, for: .normal)
                            self.watchListButtonWidth.constant = 250
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ReminderListingTableViewCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleVideos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleListCollectionCell", for: indexPath as IndexPath) as! SheduleListCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            cell.delegate = self
            cell.scheduleItem = scheduleVideos?[indexPath.row]
//        let width = (UIScreen.main.bounds.width) / 2
//        let height = ((width-30) * 9 / 16) * CGFloat(scheduleVideos!.count / 4)
//        scheduleCollectionViewHeight.constant = height + 60
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (scheduleCollectionView.frame.width - ((scheduleCollectionView.frame.width)/3))
        let widthnew =  (UIScreen.main.bounds.width/3)
        let height = ((widthnew)*9)/16
        return CGSize(width: width + 100, height: height + 100 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom:0, right:0)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
extension ReminderListingTableViewCell : SheduleListCollectionViewCellDelegate{
    func didSelectOnDemand(passModel: VideoModel?) {
        delegate.didSelectOnDemand(passModel: passModel)
    }
    
    func didSelectReminder(passModel: VideoModel?) {
        delegate.didSelectReminder(passModel: passModel)
        
    }
    
    
}


    
    


