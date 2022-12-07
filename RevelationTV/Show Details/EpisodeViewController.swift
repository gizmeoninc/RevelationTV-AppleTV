//
//  EpisodeViewController.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 11/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability
class EpisodeViewController: UIViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            self.mainView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.mainView.isHidden = true
        }
    }
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var topImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var showAndEpisodeView: UIView!{
        didSet{
            self.showAndEpisodeView.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
        }
    }
    
    @IBOutlet weak var showAndEpisodeViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var showAndEpisodeViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var showNameLabel: UILabel!{
        didSet{
            self.showNameLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 40)
            self.showNameLabel.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
            self.showNameLabel.textColor = ThemeManager.currentTheme().headerTextColor
            self.showNameLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var episodeShowNameLabel: UILabel!{
        didSet{
            self.episodeShowNameLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
            self.episodeShowNameLabel.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
            self.episodeShowNameLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            
            backButton.setTitle("Back", for: .normal)
            let image = UIImage(named: "share_icon")?.withRenderingMode(.alwaysTemplate)
            backButton.setImage(image, for: .normal)
            backButton.tintColor = UIColor.white
            backButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            backButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            backButton.layer.borderWidth = 3.0
            backButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            backButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            backButton.layer.cornerRadius = 25
            backButton.titleLabel?.textAlignment = .center
            backButton.layer.masksToBounds = true
            backButton.contentHorizontalAlignment = .left
            backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);            backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
            
        }
    }
    
    @IBOutlet weak var onDemandButton: UIButton!{
        didSet{
            onDemandButton.setTitle("On Demand", for: .normal)
            onDemandButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            onDemandButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            onDemandButton.layer.borderWidth = 3.0
            onDemandButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            onDemandButton.layer.cornerRadius = 30
            onDemandButton.titleLabel?.textAlignment = .center
            onDemandButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            onDemandButton.layer.masksToBounds = true
           
        }
    }
    @IBOutlet weak var watchListButton: UIButton!{
        didSet{
            watchListButton.setTitle("Add to list", for: .normal)
            watchListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
            watchListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            watchListButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            watchListButton.layer.borderWidth = 3.0
            watchListButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            watchListButton.layer.cornerRadius = 30
            watchListButton.titleLabel?.textAlignment = .center
            watchListButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            watchListButton.layer.masksToBounds = true
            watchListButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchListButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchListButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchListButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    @IBOutlet weak var episodeLabel: UILabel!{
        didSet{
            self.episodeLabel.text = "More Episodes"
            self.episodeLabel.font =  UIFont(name:ThemeManager.currentTheme().fontBold, size: 30)

        }
    }
    @IBOutlet weak var episodeCollectionView: UICollectionView!{
        didSet{
            episodeCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var episodeCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var episodeNameLabel: UILabel!{
        didSet{
            self.episodeNameLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
            self.episodeNameLabel.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
            self.episodeNameLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
        }
    }
//    @IBOutlet weak var episodeNameOuterView: UIView!{
//        didSet{
//            self.episodeNameOuterView.backgroundColor = ThemeManager.currentTheme().textBackgroundColor
//        }
//    }
//    @IBOutlet weak var episodeNameOuterViewHeight: NSLayoutConstraint!
    
//    @IBOutlet weak var episodeNameOuterViewWidth: NSLayoutConstraint!
    let reachability = try! Reachability()
    var show_Id = ""
    var video_Id = ""

    var fromCategories = Bool()
    var ShowData = [ShowDetailsModel]()
    var EpisodeData = [VideoModel]()

    var metadataItem : VideoModel!
    var metadataModel : VideoModel!
    var categoryListArray = [categoriesModel]()
    var languagesList = [languagesModel]()
    var showVideoList = [VideoModel]()
    var categoryList = [VideoModel]()
    var showname: String?
    fileprivate let cellOffset: CGFloat = 120
    var videoItem: VideoModel?
    var myMutableString = NSMutableAttributedString()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        episodeCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
       let flowlayout = UICollectionViewFlowLayout()
        episodeCollectionView.dataSource = self
        episodeCollectionView.delegate = self
        episodeCollectionView.collectionViewLayout = flowlayout
        flowlayout.scrollDirection = .horizontal
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        if video_Id != ""{
            getVideoData()
//            watchFlag()
        }
        
    }
    func getVideoData() {
        if self.video_Id != "" {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["video-id"] = video_Id
            commonClass.startActivityIndicator(onViewController: self);
            ApiCommonClass.getvideoDataByID(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "Server error")
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                } else {
                    self.EpisodeData = responseDictionary["data"] as! [VideoModel]
                    if self.EpisodeData.count == 0 {
                        DispatchQueue.main.async {
                            commonClass.stopActivityIndicator(onViewController: self)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.show_Id = String(self.EpisodeData[0].show_id!)
                            self.getShowData()
                            if let watch_flag = self.EpisodeData[0].watchlist_flag {
                                if watch_flag == 1 {
                                 self.watchVideo = true
                                    self.watchListButton.setTitle("Remove from list", for: .normal)
                                    self.watchListButton.setImage(UIImage(named: ""), for: .normal)

                                } else {
                                 self.watchVideo = false
                                    self.watchListButton.setTitle("Add to list", for: .normal)
                                    self.watchListButton.setImage(UIImage(named: "plus-icon"), for: .normal)

                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getShowData() {
        //Categories.removeAll()
        if self.show_Id != "" {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["show-id"] = show_Id
            ApiCommonClass.getvideoAccordingToShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "Server error")
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
                                self.showname = self.ShowData[0].show_name
                                self.showNameLabel.text = self.ShowData[0].show_name
                                print("showname",self.showname)
//                                self.watchFlag()
                                self.updateUI()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    func updateUI(){
       if self.EpisodeData[0].thumbnail_350_200 != nil{
            print("didSelectShowVideos",URL(string: imageUrl + (EpisodeData[0].thumbnail_350_200)!))
            self.topImageView.sd_setImage(with: URL(string: imageUrl + (EpisodeData[0].thumbnail_350_200)!),placeholderImage:UIImage(named: "lightGrey"))
          
        }
        if self.EpisodeData[0].video_title != nil{
//            self.episodeNameLabel.text = "   \(showname ?? "-" ?? EpisodeData[0].video_title ?? "")   "
            self.episodeNameLabel.text = " \(EpisodeData[0].video_title!)"
            
            self.showNameLabel.text = "\(showname!)  "
            let text = EpisodeData[0].video_title
            let font =  UIFont(name: ThemeManager.currentTheme().fontBold, size: 40)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            if (size.width + 100 ) > (UIScreen.main.bounds.width / 2){
                self.showAndEpisodeViewWidth.constant = (UIScreen.main.bounds.width / 2) - 100
                let heightOfLabel = size.height + 40
                self.showAndEpisodeViewHeight.constant = heightOfLabel
            }
            else{
                self.showAndEpisodeViewWidth.constant = size.width + 100
                let heightOfLabel = size.height + 40
                self.showAndEpisodeViewHeight.constant = heightOfLabel
            }
           
//            if self.ShowData[0].show_name != nil{
//                self.showNameLabel.text = ShowData[0].show_name
//                let text = ShowData[0].show_name
//                let font =  UIFont(name: "Helvetica", size: 25)
//                let fontAttributes = [NSAttributedString.Key.font: font]
//                let size = (text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
//                self.seasonButtonWidth.constant = size.width + 200
//
//                let heightOfLabel = size.height + 40
//                self.seasonButtonHeight.constant = heightOfLabel
//                self.seasonButton.setTitle(ShowData[0].show_name, for: .normal)
//            }
            
        }
        let mainWidth = UIScreen.main.bounds.width
        topImageViewHeight.constant = (mainWidth * 9)/16 - 100
        var spaceHeight = CGFloat()
        let width = (episodeCollectionView.bounds.width)/4
        let height = (((width-30) * 9)/16) + 30
        spaceHeight = 40
        episodeCollectionViewHeight.constant = height + spaceHeight
        self.mainViewHeight.constant = topImageViewHeight.constant + episodeCollectionViewHeight.constant + 150
        self.mainView.isHidden = false
        DispatchQueue.main.async {
            self.self.episodeCollectionView.reloadData()
        }
    }
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [self.onDemandButton]
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.onDemandButton.isFocused{
            onDemandButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            watchListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            backButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

            mainScrollView.setContentOffset(.zero, animated: true)
        }
        else  if self.watchListButton.isFocused{
            watchListButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            onDemandButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            backButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

            mainScrollView.setContentOffset(.zero, animated: true)

        }
        else  if self.backButton.isFocused{
            backButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            onDemandButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            watchListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

        }
        else{
            onDemandButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            watchListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            backButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark


        }
    }
    
    //Button Actions
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onDemandAction(_ sender: Any) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
//        signupPageView.selectedvideoItem = showVideoList[0].videos![0]
//        if let premiumFlag = ShowData[0].premium_flag{
//            signupPageView.premium_flag = premiumFlag
//        }
        signupPageView.selectedvideoItem = EpisodeData[0]
                if let premiumFlag = EpisodeData[0].premium_flag{
                    signupPageView.premium_flag = premiumFlag
                }
        signupPageView.episodeName = EpisodeData[0].video_title!
        self.present(signupPageView, animated: true, completion: nil)
    }
    
    @IBAction func watchListAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
            self.present(videoDetailView, animated: false, completion: nil)
           
        }else{
            if !watchVideo {
              self.watchVideo = true
              self.watchListShow()
                self.watchListButton.setImage(UIImage(named: ""), for: .normal)
                self.watchListButton.setTitle("Remove from list", for: .normal)
            } else {
              self.watchVideo = false
              self.watchListShow()
                self.watchListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
                self.watchListButton.setTitle("Add to list", for: .normal)


            }
        }
        
    }
    var watchVideo = false
    var watchFlagModel = [LikeWatchListModel]()
    func watchListShow() {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["video-id"] = String(self.video_Id)
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
      ApiCommonClass.WatchlistVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
            self.watchVideo = !self.watchVideo
          }
        } else {
          DispatchQueue.main.async {
            if self.watchVideo  {
                self.watchListButton.setTitle("Remove from list", for: .normal)
                self.watchListButton.setImage(UIImage(named: ""), for: .normal)

            } else {
                self.watchListButton.setTitle("Add to list", for: .normal)
                self.watchListButton.setImage(UIImage(named: "plus-icon"), for: .normal)


            }
          }
        }
      }
    }
    
    
    
    
    
}

extension EpisodeViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.showVideoList.count > 0{
            return self.showVideoList[0].videos!.count

        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
        signupPageView.selectedvideoItem = showVideoList[0].videos![indexPath.item]
                if let premiumFlag = showVideoList[0].videos![indexPath.item].premium_flag{
                    signupPageView.premium_flag = premiumFlag
                }
        signupPageView.episodeName = showVideoList[0].videos![indexPath.item].video_title!
        self.present(signupPageView, animated: true, completion: nil)
      
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
            let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
            cell.backgroundColor = .clear
            cell.imageView.layer.masksToBounds = true
            cell.imageView.contentMode = .scaleToFill
            cell.imageView.layer.cornerRadius = 8
            if showVideoList[0].videos![indexPath.row].video_title != nil{
                cell.videoNameLabel.text = showVideoList[0].videos![indexPath.row].video_title
                cell.videoNameLabel.numberOfLines = 1
            }
            else{
                cell.videoNameLabel.text = " "
            }
        if showVideoList[0].videos![indexPath.row].thumbnail_350_200 != nil{
                cell.imageView.sd_setImage(with: URL(string: showUrl + showVideoList[0].videos![indexPath.row].thumbnail_350_200!),placeholderImage:UIImage(named: "landscape_placeholder"))
            }
            else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }
        return cell
    }
        
        
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = (episodeCollectionView.bounds.width)/4
        let height = ((width-30) * 9)/16
        return CGSize(width: width - 30, height: height + 30);
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom:20, right: 0)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
