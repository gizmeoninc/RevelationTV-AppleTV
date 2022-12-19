//
//  ShowsOverlayViewController.swift
//  RevelationTV
//
//  Created by Firoze Moosakutty on 09/12/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import Reachability

//@available(tvOS 13.0, *)
protocol  ShowsOverlayViewDelegate:class {
    func didSelectWatchlist(passModel :VideoModel?)
//    func didSelectPlayIcon(passModel :VideoModel?)
//    func didSelectMoreInfo(passModel :VideoModel?)
}
//@available(tvOS 13.0, *)
class ShowsOverlayViewController:UIViewController {
    weak var delegate: ShowsOverlayViewDelegate!
    let reachability = try! Reachability()
    var show_Id = ""
    var ShowData = [ShowDetailsModel]()
    var showVideoList = [VideoModel]()
    var watchVideo = false
    var showFlag = true

    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            mainView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.setImage(UIImage(named: "back Icon"), for: .normal)
            backButton.tintColor = UIColor.white
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var showTitleLabel: UILabel!{
        didSet{
            showTitleLabel.font = UIFont(name:ThemeManager.currentTheme().fontDefault,size: 30)
            showTitleLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    
    @IBOutlet weak var iconImage: UIImageView!{
        didSet{
            iconImage.contentMode = .scaleToFill
            iconImage.tintColor = ThemeManager.currentTheme().buttonTextColor
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.textColor = ThemeManager.currentTheme().headerTextColor
            dateLabel.font = UIFont(name: ThemeManager.currentTheme().fontDefault, size: 18)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            descriptionLabel.font = UIFont(name: ThemeManager.currentTheme().fontDefault, size: 20)
            descriptionLabel.numberOfLines = 6
        }
    }
    
    @IBOutlet weak var favouritesIcon: UIButton!{
        didSet{
            favouritesIcon.tintColor = UIColor.white
            favouritesIcon.setImage(UIImage(named: "favouritesIcon"), for: .normal)
        }
    }
    
    @IBAction func favouritesAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
            self.present(videoDetailView, animated: false, completion: nil)

        }else{
            if !watchVideo {
              self.watchVideo = true
              self.watchListShow()
                self.favouritesIcon.setImage(UIImage(named: "favouritesIconRed"), for: .normal)
            } else {
              self.watchVideo = false
              self.watchListShow()
                self.favouritesIcon.setImage(UIImage(named: "favouritesIcon"), for: .normal)
            }
        }
    }
    func watchListShow() {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["show-id"] = String(self.show_Id)
      parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
      parameterDict["device_type"] = "ios-phone"
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      if watchVideo {
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
                self.favouritesIcon.setImage(UIImage(named: "favouritesIconRed"), for: .normal)
            } else {
                self.favouritesIcon.setImage(UIImage(named: "favouritesIcon"), for: .normal)
            }
          }
        }
      }
    }

    @IBOutlet weak var MoreInfoButton: UIButton!{
        didSet{
            MoreInfoButton.setTitle("More Info", for: .normal)
            MoreInfoButton.setImage(UIImage(named: "plus-icon"), for: .normal)
            MoreInfoButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
            MoreInfoButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            MoreInfoButton.layer.borderWidth = 3.0
            MoreInfoButton.titleLabel?.font =  UIFont(name:"ITCAvantGardePro-Bk", size: 20)
            MoreInfoButton.layer.cornerRadius = 10
            MoreInfoButton.titleLabel?.textAlignment = .center
            MoreInfoButton.layer.masksToBounds = true
            MoreInfoButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: -50, bottom: -12, right: -30)
            MoreInfoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: -50)
        }
    }
    
    @IBOutlet weak var moreInfoButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreInfoButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var playButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var playButtonHeight: NSLayoutConstraint!
    
    @IBAction func moreInfoAction(_ sender: Any) {
        if showFlag == true{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
            let id = Int(ShowData[0].show_id!)
            videoDetailView.show_Id = String(id)
            self.present(videoDetailView, animated: true, completion: nil)
        }
        else{
            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
            signupPageView.selectedvideoItem = self.showVideoList[0].videos![0]
            if let premiumFlag = self.ShowData[0].videos![0].premium_flag{
                    signupPageView.premium_flag = premiumFlag
                }
            self.present(signupPageView, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            playButton.contentMode = .scaleToFill
            playButton.setTitle("Play", for: .normal)
            playButton.setImage(UIImage(named: "icons8-play-26"), for: .normal)
            playButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            playButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
            playButton.tintColor = ThemeManager.currentTheme().headerTextColor
            playButton.layer.borderWidth = 3.0
            playButton.titleLabel?.font =  UIFont(name:"ITCAvantGardePro-Bk", size: 20)
            playButton.layer.cornerRadius = 10
            playButton.titleLabel?.textAlignment = .center
            playButton.layer.masksToBounds = true
            playButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            playButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: -20, bottom: -12, right: 0)
            playButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
        signupPageView.selectedvideoItem = self.showVideoList[0].videos![0]
        if let premiumFlag = self.ShowData[0].videos![0].premium_flag{
                signupPageView.premium_flag = premiumFlag
            }
        self.present(signupPageView, animated: true, completion: nil)
    }
   
    fileprivate func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
         let vibrancy = UIVibrancyEffect(blurEffect: blurEffectView.effect as! UIBlurEffect)
         let vibrancyView = UIVisualEffectView(effect: vibrancy)
         vibrancyView.frame = blurEffectView.bounds
         vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         return vibrancyView
     }
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width / 3.5
        let height = (width*9)/16
        self.getShowData()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
          self.view.bringSubviewToFront(mainView)
        
    
        self.imageViewWidth.constant = width
        self.imageViewHeight.constant = height
        let focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        focusGuide.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        focusGuide.rightAnchor.constraint(equalTo: favouritesIcon.rightAnchor).isActive = true
        focusGuide.topAnchor.constraint(equalTo: favouritesIcon.topAnchor).isActive = true
        focusGuide.bottomAnchor.constraint(equalTo: favouritesIcon.bottomAnchor).isActive = true
        focusGuide.preferredFocusEnvironments = [favouritesIcon]
        let secondfocusguide = UIFocusGuide()
        view.addLayoutGuide(secondfocusguide)
        secondfocusguide.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        secondfocusguide.rightAnchor.constraint(equalTo: focusGuide.rightAnchor).isActive = true
        secondfocusguide.topAnchor.constraint(equalTo: backButton.topAnchor).isActive = true
        secondfocusguide.bottomAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
        secondfocusguide.preferredFocusEnvironments = [backButton]
        if showFlag == true{
            MoreInfoButton.setTitle("More Info", for: .normal)
            MoreInfoButton.setImage(UIImage(named: "plus-icon"), for: .normal)
            MoreInfoButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
            MoreInfoButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            MoreInfoButton.layer.borderWidth = 3.0
            MoreInfoButton.titleLabel?.font =  UIFont(name:"ITCAvantGardePro-Bk", size: 20)
            MoreInfoButton.layer.cornerRadius = 10
            MoreInfoButton.titleLabel?.textAlignment = .center
            MoreInfoButton.layer.masksToBounds = true
            MoreInfoButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: -50, bottom: -12, right: -30)
            MoreInfoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: -50)
        }
        else{
            MoreInfoButton.setTitle("Play", for: .normal)
            MoreInfoButton.setImage(UIImage(named: "icons8-play-26"), for: .normal)
            MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
            MoreInfoButton.tintColor = ThemeManager.currentTheme().headerTextColor
            MoreInfoButton.layer.borderWidth = 3.0
            MoreInfoButton.titleLabel?.font =  UIFont(name:"ITCAvantGardePro-Bk", size: 20)
            MoreInfoButton.layer.cornerRadius = 10
            MoreInfoButton.titleLabel?.textAlignment = .center
            MoreInfoButton.layer.masksToBounds = true
            MoreInfoButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            MoreInfoButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: -20, bottom: -12, right: 0)
            MoreInfoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            playButtonWidth.constant = 190
//            playButtonHeight.constant = 45
        }
    }
    func getShowData() {
        //Categories.removeAll()
        if self.show_Id != "" {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["show-id"] = show_Id
            commonClass.startActivityIndicator(onViewController: self);
            ApiCommonClass.getvideoAccordingToShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "Server error")
                        
                        //   WarningDisplayViewController().noResultview(view : self.view,title: "No Results Found")
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                } else {
                    self.ShowData = responseDictionary["data"] as! [ShowDetailsModel]
                    if self.ShowData.count == 0 {
                        DispatchQueue.main.async {
                            commonClass.stopActivityIndicator(onViewController: self)
                        }
                    } else {
                        DispatchQueue.main.async {
                            commonClass.stopActivityIndicator(onViewController: self)
                            if let showVideoList = self.ShowData[0].videos{
                                self.showVideoList =  showVideoList
                                
//                                self.watchFlag()
                                self.updateUI()
//                                self.videoListingCollectionView.reloadData()

                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    func updateUI(){
        if self.showVideoList[0].videos![0].thumbnail_350_200 != nil{
             print("didSelectShowVideos",URL(string: imageUrl + (showVideoList[0].videos![0].thumbnail_350_200)!))
            self.imageView.sd_setImage(with: URL(string: imageUrl + (showVideoList[0].videos![0].thumbnail_350_200)!),placeholderImage:UIImage(named: "lightGrey"))
         }
         if self.ShowData[0].show_name != nil{
             self.showTitleLabel.text = ShowData[0].show_name
             let text = ShowData[0].show_name
             let font =  UIFont(name: "Helvetica", size: 25)
             let fontAttributes = [NSAttributedString.Key.font: font]
             let size = (text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
             
             let heightOfLabel = size.height + 40
         }
        if showVideoList[0].videos![0].schedule_date != nil{
            self.dateLabel.text = showVideoList[0].videos![0].schedule_date
        }
         if ShowData[0].synopsis != nil{
             self.descriptionLabel.text = ShowData[0].synopsis
         }
         
         if let watch_flag = self.ShowData[0].watchlist_flag {
             if watch_flag == 1 {
              self.watchVideo = true
                 self.favouritesIcon.setImage(UIImage(named: "favouritesIconRed"), for: .normal)
             } else {
              self.watchVideo = false
                 self.favouritesIcon.setImage(UIImage(named: "favouritesIcon"), for: .normal)
             }
         }
//         var spaceHeight = CGFloat()
//         let width = (videoListingCollectionView.bounds.width)/4
//         let height = (((width-30) * 9)/16) + 30
//
//         self.mainViewHeight.constant = metadataViewHeight.constant + videoListingCollectionViewHeight.constant + 200 + 100
    }
    func getDateAfterTenDays() -> String {
      let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy"
      let date = formatter.string(from: dateAftrTenDays)
      return date
    }
    func skipLogin() {
      let deviceID =  UserDefaults.standard.string(forKey:"UDID")!
      print(deviceID)
      var parameterDict: [String: String?] = [ : ]
      parameterDict["device_id"] = deviceID
      ApiCommonClass.getGustUserId(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if let val = responseDictionary["error"] {
          DispatchQueue.main.async {
            
          }
        } else {
          if let val = responseDictionary["Channels"] {
            DispatchQueue.main.async {
              UserDefaults.standard.set(self.getDateAfterTenDays(), forKey: "guestloginafter10_date")
              UserDefaults.standard.set("true", forKey: "login_status")
              UserDefaults.standard.set("true", forKey: "skiplogin_status")
              UserDefaults.standard.set(responseDictionary["Channels"], forKey: "user_id")
              UserDefaults.standard.set("Guest User", forKey: "first_name")
              Application.shared.userSubscriptionStatus = false
                self.goToHomeVC()
              
            }
          }
        }
      }
    }
    func goToHomeVC(){
        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
        self.present(gotohomeView, animated: true, completion: nil)
        
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.backButton.isFocused{
            backButton.tintColor = ThemeManager.currentTheme().buttonTextColor
            favouritesIcon.tintColor = UIColor.white
            if showFlag == true{
                MoreInfoButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
                MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
                MoreInfoButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            }
            else{
                MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
                MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().buttonTextColor.cgColor
                MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
                MoreInfoButton.tintColor = ThemeManager.currentTheme().headerTextColor
            }
        }
        else if favouritesIcon.isFocused{
            self.favouritesIcon.backgroundColor = .clear
            if showFlag == true{
                MoreInfoButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
                MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
                MoreInfoButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            }
            else{
                MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
                MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().buttonTextColor.cgColor
                MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
                MoreInfoButton.tintColor = ThemeManager.currentTheme().headerTextColor
            }
        }
        else{
            if showFlag == true{
                MoreInfoButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
                MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
                MoreInfoButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            }
            else{
                MoreInfoButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
                MoreInfoButton.layer.borderColor = ThemeManager.currentTheme().buttonTextColor.cgColor
                MoreInfoButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
                MoreInfoButton.tintColor = ThemeManager.currentTheme().headerTextColor
            }
        }
    }
//    func didSelectPlayIcon(passModel: VideoModel?) {
//        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
//        signupPageView.selectedvideoItem = self.showVideoList[0]
//        if let premiumFlag = self.ShowData[0].premium_flag{
//                signupPageView.premium_flag = premiumFlag
//            }
//        self.present(signupPageView, animated: true, completion: nil)
//
//    }

}
