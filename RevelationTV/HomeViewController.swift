//
//  HomeViewController.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 03/09/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability

class HomeViewController: UIViewController {

    @IBOutlet weak var HomeTableView: UITableView!
    @IBOutlet weak var menuCollectionView: UICollectionView!{
        didSet{
            menuCollectionView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
    @IBOutlet weak var menuBar: UIView!{
        didSet{
            menuBar.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
    @IBOutlet weak var accountOuterView: UIView!
    @IBOutlet weak var accountButton: UIButton!{
        didSet{
            accountButton.addTarget(self, action: #selector(self.click(sender:)), for: UIControl.Event.primaryActionTriggered)
            self.accountButton.setImage(UIImage(named: "Profile_icon.png"), for: .normal)
            self.accountButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor

        }
    }
    
    @IBOutlet weak var searchButton: UIButton!{
        didSet{
            searchButton.setImage(UIImage(named: "TVExcelSearchImage-1"), for: .normal)
            searchButton.tintColor = .white
        }
    }
    @IBOutlet weak var dropDownArrowACcount: UIImageView!{
        didSet{
            dropDownArrowACcount.setImageColor(color: ThemeManager.currentTheme().headerTextColor)
        }
    }
    var homeTableViewHeight = CGFloat()
   
    
    let reachability = try! Reachability()
    var freeShows = [VideoModel]()
    var dianamicVideos = [showByCategoryModel]()
    var newArrivedVideos = [VideoModel]()
    var categoryVideos = [VideoModel]()
    var filmVideos = [VideoModel]()
    var liveVideos = [VideoModel]()
    var featuredVideos = [VideoModel]()
    var fetauredItem: VideoModel?
    var item = UITabBarItem()
    
    var lastFocusedIndexPath: IndexPath?
var menuArray = [String]()
    var themeVideos = [VideoModel]()
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibTopBanner =  UINib(nibName: "TopBannerTableViewCell", bundle: nil)
        HomeTableView.register(nibTopBanner, forCellReuseIdentifier: "TopBannerTableCell")
        let nib1 =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        HomeTableView.register(nib1, forCellReuseIdentifier: "HomeTableCell")
        let nib2 =  UINib(nibName: "CommonTableViewCell", bundle: nil)
        HomeTableView.register(nib2, forCellReuseIdentifier: "mainTableViewCell")
        let nibFeaturedBanner =  UINib(nibName: "DemandTableViewCell", bundle: nil)
        HomeTableView.register(nibFeaturedBanner, forCellReuseIdentifier: "DemandTableCell")
        let nibLive =  UINib(nibName: "LiveTableViewCell", bundle: nil)
        HomeTableView.register(nibLive, forCellReuseIdentifier: "LiveTableCell")
        let nibSchedule =  UINib(nibName: "ScheduleListTableViewCell", bundle: nil)
        HomeTableView.register(nibSchedule, forCellReuseIdentifier: "ScheduleListTableCell")
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        HomeTableView.backgroundColor =
        ThemeManager.currentTheme().buttonColorDark
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        HomeTableView.contentInsetAdjustmentBehavior = .never
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        
        if UserDefaults.standard.string(forKey: "skiplogin_status") != nil{
            let status = UserDefaults.standard.string(forKey: "skiplogin_status")
            print("skiploginstatus",status)
        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

    }
    @objc func methodOfReceivedNotification(notification: Notification) {
    }
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }
    let scale = 1.0
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if accountButton.isFocused {
            self.accountButton.transform = CGAffineTransformMakeScale(scale, scale)
            self.accountOuterView.layer.borderWidth = 3
            self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            self.accountButton.layer.cornerRadius = 35
            self.accountButton.layer.masksToBounds = true
        }
        else{
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            
        }
    }
    func MoveTOLoginPage() {
        let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController // move to login page from guest user                                                                                                                       login
//        loginController.isFromAccountScreen = true
        self.present(loginController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"access_token") == nil {
            print("getToken")
            self.getToken()
        }
        else{
            print("getHomeNewArrivals viewdidload")
            self.getDianamicHomeVideos()
        }
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Home","Live","On-Demand","Catch-up","Search"]
        }
        else{
            self.menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]

        }
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        lastFocusedIndexPath = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
        self.setNeedsFocusUpdate()
        let menuPressRecognizer = UITapGestureRecognizer()
               menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
               menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
               self.view.addGestureRecognizer(menuPressRecognizer)
    }
    @objc func click(sender: UIButton) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
            self.present(videoDetailView, animated: false, completion: nil)
//            CustomPopupViewController.showPopup(parentVC: self)
        }
        else{
            CustomPopupViewController.showPopup(parentVC: self)

        }
        print("click")
    }
    @objc func menuButtonAction() {
        print("menu pressed")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    // MARK: Api Calls
    //Call to accces token api
    func getToken() {
        print("getToken from home")
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getToken { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                commonClass.stopActivityIndicator(onViewController: self)
                commonClass.showAlert(viewController:self, messages: "Server error")
            } else {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.getDianamicHomeVideos()
                }
            }
            
        }
    }
    // call to NewArrivals api
    func getHomeNewArrivals() {
        if !UserDefaults.standard.bool(forKey: "luanchInformationOfApp") {
          UserDefaults.standard.setValue(true, forKey: "luanchInformationOfApp")
          self.app_Install_Launch()
        }
        if Application.shared.APP_LAUNCH{
          self.firstEventAppLuanch()
          Application.shared.APP_LAUNCH = false
        }
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getHomeNewArrivals { [self] (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    print("getHomeNewArrivals error")
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.getDianamicHomeVideos()
              }
            } else {
                
                self.newArrivedVideos.removeAll()
                if let videos = responseDictionary["data"] as? [VideoModel] {
                    print("newArrivedVideos",videos.count)
                    
                    self.newArrivedVideos = videos
                    if self.newArrivedVideos.count == 0{
                        DispatchQueue.main.async {
                            self.getDianamicHomeVideos()
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.getDianamicHomeVideos()
                        }
                    }
                }
            }
        }
    }
   
    // call to category video api
    func getDianamicHomeVideos() {
        if !UserDefaults.standard.bool(forKey: "luanchInformationOfApp") {
          UserDefaults.standard.setValue(true, forKey: "luanchInformationOfApp")
          self.app_Install_Launch()
        }
        if Application.shared.APP_LAUNCH{
          self.firstEventAppLuanch()
          Application.shared.APP_LAUNCH = false
        }
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass .getDianamicHomeVideos { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n please try later")

                }
            } else {
                

                self.dianamicVideos.removeAll()
                if let dianamicVideos = responseDictionary["data"] as? [showByCategoryModel] {
                    self.dianamicVideos = dianamicVideos
                }
                if self.dianamicVideos.count == 0 {
                    print("dianamicVideos")
                    
                    DispatchQueue.main.async {
                        self.HomeTableView.reloadData()
                        self.HomeTableView.isHidden = false
                        commonClass.stopActivityIndicator(onViewController: self)

                    }
                } else {
                    DispatchQueue.main.async {
                       
                        self.HomeTableView.isHidden = false
                        self.HomeTableView.reloadData()
                        commonClass.stopActivityIndicator(onViewController: self)
                            
                       
                       
                    }
                }
            }
        }
    }
   
    
   
    
    

   
    func app_Install_Launch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
 
      parameterDict["device_type"] = "apple-tv"
      if let longitude = UserDefaults.standard.string(forKey:"longitude") {
        parameterDict["longitude"] = longitude
      }
      if let latitude = UserDefaults.standard.string(forKey: "latitude"){
        parameterDict["latitude"] = latitude
      }
      if let country = UserDefaults.standard.string(forKey:"country"){
        parameterDict["country"] = country
      }
      if let city = UserDefaults.standard.string(forKey:"city"){
        parameterDict["city"] = city
      }
      if let userAgent = UserDefaults.standard.string(forKey:"userAgent"){
           parameterDict["ua"] = userAgent
         }
      if let IPAddress = UserDefaults.standard.string(forKey:"IPAddress") {
        parameterDict["ip_address"] = IPAddress
      }
     
      if let advertiser_id = UserDefaults.standard.string(forKey:"Idfa"){
        parameterDict["advertiser_id"] = advertiser_id
      }
      else{
            parameterDict["advertiser_id"] = "00000000-0000-0000-0000-000000000000"
          }
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
         parameterDict["width"] =  String(format: "%.3f",UIScreen.main.bounds.width)
         parameterDict["height"] = String(format: "%.3f",UIScreen.main.bounds.height)
         parameterDict["device_make"] = "Apple"
        parameterDict["device_model"] = UserDefaults.standard.string(forKey:"deviceModel")
         if (UserDefaults.standard.string(forKey: "first_name") != nil){
          parameterDict["user_name"] = UserDefaults.standard.string(forKey: "first_name")
         }
      if let user_email = UserDefaults.standard.string(forKey: "user_email"){
       parameterDict["user_email"] = user_email
      }
       
      if let publisherid = UserDefaults.standard.string(forKey: "pubid") {
        parameterDict["publisherid"] = publisherid
      }
      
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
     
      if (UserDefaults.standard.string(forKey:"skiplogin_status") == "false") {
  //    if (UserDefaults.standard.string(forKey: "user_email") != nil){
  //     parameterDict["user_email"] = UserDefaults.standard.string(forKey: "user_email")
  //    }
  //
      if (UserDefaults.standard.string(forKey: "phone") != nil){
       parameterDict["user_contact_number"] = UserDefaults.standard.string(forKey: "phone")
      }
          
      }
        print("param for device api ",parameterDict)
      ApiCommonClass.analayticsAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            print("device api success")
          }
        }
      }
    }
    func firstEventAppLuanch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
      parameterDict["event_type"] = "POP01"
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      if let channelid = UserDefaults.standard.string(forKey:"channelid") {
          parameterDict["channel_id"] = channelid
      }
      parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
      print(parameterDict)
      ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
              print("firstEventAppLuanch")
          }
        }
      }
    }
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [menuCollectionView]
    }
    @IBAction func moreButtonClicked(_ sender: Any) {
//        delegate.didSelectMoreInfo(passModel: fetauredItem)
        
//        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
//        videoDetailView.videoItem = filmVideos[0]
//            videoDetailView.fromCategories = false
//        self.present(videoDetailView, animated: true, completion: nil)
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
    func getDateAfterTenDays() -> String {
      let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy"
      let date = formatter.string(from: dateAftrTenDays)
      return date
    }
       
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
    func cellSelected() {
        print("called")
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if dianamicVideos[indexPath.section].type == "LIVE"{
            return true
        }
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  dianamicVideos.count
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dianamicVideos[indexPath.section].type == "TOP_BANNERS" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopBannerTableCell", for: indexPath) as! TopBannerTableViewCell
                    cell.featuredVideos = dianamicVideos[indexPath.section].shows
//                        cell.delegate = self
                        cell.selectionStyle = .none
                        cell.layer.cornerRadius = 8
                cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
                        return cell
        }
       
        if dianamicVideos[indexPath.section].type == "FEATURED" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.backgroundColor = .clear
            cell.videoType = "Dianamic"
            cell.TitleLabel.text = "Featured"
            cell.TitleLabel.textColor = .white
            cell.moreIconButton.tag = indexPath.section
            
            cell.moreIconButton.addTarget(self, action: #selector(goToMoreIconAction), for: .primaryActionTriggered)
            
//            cell.moreIconButton.addTarget(self, action: #selector(goToMoreIconAction(section:indexPath.section)), for: .touchUpInside)
//            cell.TitleLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 40)
            cell.videoArray = dianamicVideos[indexPath.section].shows
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DemandTableCell", for: indexPath) as! DemandTableViewCell
////            cell.channelType = "Featured"
//            cell.featuredVideos = dianamicVideos[indexPath.section].shows
//            cell.delegate = self
//            cell.selectionStyle = .none
//            cell.layer.cornerRadius = 8
//            return cell
        }
        else if dianamicVideos[indexPath.section].type == "LIVE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTableCell", for: indexPath) as! LiveTableViewCell
            cell.scheduleVideos = dianamicVideos[indexPath.section].shows
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            return cell
        }
        else if dianamicVideos[indexPath.section].type == "LIVE_GUIDE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableCell", for: indexPath) as! ScheduleListTableViewCell
            cell.delegate = self
            cell.channelType = "HomeSchedule"
            cell.scheduleVideos = dianamicVideos[indexPath.section].shows
            cell.backgroundColor = .clear
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.backgroundColor = .clear
            cell.videoType = "Dianamic"
            cell.iconImage.isHidden = false
            cell.moreIconButton.isHidden = false
            cell.TitleLabel.isHidden = false
            cell.moreIconButton.tag = indexPath.section
            
            cell.moreIconButton.addTarget(self, action: #selector(goToMoreIconAction), for: .primaryActionTriggered)
            cell.videoArray = dianamicVideos[indexPath.section].shows
            cell.TitleLabel.text = dianamicVideos[indexPath.section].category_name
            cell.TitleLabel.textColor = .white
//            self.fetauredItem = dianamicVideos[indexPath.row]

//            cell.TitleLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 100)
//            let data = dianamicVideos[indexPath.section].shows
//            if (data?.count)! >= 10 {
//                cell.videoArray = dianamicVideos[indexPath.section].shows
//            } else {
//
//            }
            return cell
        }
       
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
       if dianamicVideos[indexPath.section].type == "LIVE" {
           if let liveVideo = dianamicVideos[indexPath.section].shows?[0]{
               let videoDetailView = self.storyboard?.instantiateViewController(withIdentifier: "LiveVC") as! LivePlayingViewController
                     videoDetailView.channelVideo = liveVideo
                     self.present(videoDetailView, animated: true, completion: nil)
           }
        }
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dianamicVideos[indexPath.section].type == "TOP_BANNERS" {
            let width =  UIScreen.main.bounds.width / 2.63736
            let height = (9 * width) / 64
            print("height",height)
            return height - 12.375
        }
        else if dianamicVideos[indexPath.section].type == "FEATURED" {
//            let height = (UIScreen.main.bounds.height - ((UIScreen.main.bounds.height)/3))
//            return height + 40
            let width =  UIScreen.main.bounds.width / 4.5
            let height = (9 * width) / 16 + 35
            return height + 75
        }
        else if dianamicVideos[indexPath.section].type == "LIVE" {
            let width = UIScreen.main.bounds.width
            let widthNew = width - (width/3)
            let height = (widthNew*9)/16
            return height + 30
        }
        else if dianamicVideos[indexPath.section].type == "LIVE_GUIDE" {
            let widthnew =  (UIScreen.main.bounds.width/3)
            let height = ((widthnew)*9)/16
            return height + 280
        }
        let width =  UIScreen.main.bounds.width / 4.5
        let height = (9 * width) / 16 + 35
        
      return height + 75

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
//            if self.dianamicVideos[section].shows!.isEmpty {
//                return 0
//            }
        
          
        return 60
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        let titleLabel = UILabel()
//        titleLabel.textColor = ThemeManager.currentTheme().headerTextColor
//        titleLabel.textAlignment = .left
//        titleLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 40)
//                titleLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: (rowHeight) * 0.2 - 20).integral
////        if dianamicVideos[section].type == "FEATURED" {
////            titleLabel.text =  "   RevelationTV On Demand"
////        }
//        if dianamicVideos[section].type == "LIVE" {
//            titleLabel.text =  "RevelationTV Live"
//        }
//        else if dianamicVideos[section].type == "LIVE_GUIDE" {
//            titleLabel.text =  "Coming Up"
//        }
//        else if dianamicVideos[section].type == "CONTINUE_WATCHING" {
//            titleLabel.text =  "Resume Watching"
//        }
//        else if dianamicVideos[section].type == "NEW_RELEASES" {
//            titleLabel.text =  "New Episodes"
//        }
//        else{
//            titleLabel.text =  dianamicVideos[section].category_name
//        }
//        headerView.backgroundColor = .clear
//
//        headerView.addSubview(titleLabel)
//        return headerView
//    }
  
}
extension HomeViewController: HomeTableViewCellDelegate  {
    func didSelectDianamicVideosEpisode(passModel: VideoModel?) {
        if let passModel = passModel  {
            
            if passModel.video_id != nil{
                let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
                let id = Int(passModel.video_id!)
                episodeVC.video_Id = String(id)
                self.present(episodeVC, animated: true, completion: nil)
            }
            else{
                    let showsOverlayView = self.storyboard?.instantiateViewController(withIdentifier: "ShowsOverlayVC") as! ShowsOverlayViewController
                    let id = Int(passModel.show_id!)
                    showsOverlayView.showFlag = false
                    showsOverlayView.show_Id = String(id)
                showsOverlayView.modalPresentationStyle = .custom
                showsOverlayView.modalTransitionStyle = .crossDissolve
                    self.present(showsOverlayView, animated: true, completion: nil)
//                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
//                let id = Int(passModel.show_id!)
//                videoDetailView.show_Id = String(id)
//    //                videoDetailView.fromCategories = false
//                self.present(videoDetailView, animated: true, completion: nil)
            }
           
        }
    
    }
    
    func didSelectFilmOfTheDay(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
   
    func didSelectPartner(passModel: VideoModel?) {
        print("hello")
    }
    func didFocusPartner(passModel: VideoModel) {
        print("hello")
    }
    func didSelectFreeShows(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoPlayerVC =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
            videoPlayerVC.selectedvideoItem = passModel
            videoPlayerVC.fromHomeScreen = true
            videoPlayerVC.watchedDuration = passModel.watched_duration!
            self.present(videoPlayerVC, animated: true, completion: nil)
        }
    }
    
    func didSelectNewArrivals(passModel: VideoModel?) {
        if let passModel = passModel  {
            print("cliocked new arrivals")
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
            videoDetailView.fromCategories =  false
            self.present(videoDetailView, animated: true, completion: nil)
        }
        
    }

    //continue watching video
    func didSelectThemes(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveVC") as! LivePlayingViewController
            videoDetailView.channelVideo = passModel
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    func didSelectDianamicVideos(passModel: VideoModel?) {
        if let passModel = passModel  {
            
            if passModel.video_id != nil{
                let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
                let id = Int(passModel.video_id!)
                episodeVC.video_Id = String(id)
                self.present(episodeVC, animated: true, completion: nil)
            }
            else{
                    let showsOverlayView = self.storyboard?.instantiateViewController(withIdentifier: "ShowsOverlayVC") as! ShowsOverlayViewController
                    let id = Int(passModel.show_id!)
                showsOverlayView.modalPresentationStyle = .custom
                showsOverlayView.modalTransitionStyle = .crossDissolve
//                    showsOverlayView.playButton.isHidden = false
//                    showsOverlayView.MoreInfoButton.isHidden = true
                    showsOverlayView.showFlag = true
                    showsOverlayView.show_Id = String(id)
                showsOverlayView.modalPresentationStyle = .custom
                showsOverlayView.modalTransitionStyle = .crossDissolve
                    self.present(showsOverlayView, animated: true, completion: nil)
//                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
//                let id = Int(passModel.show_id!)
//                videoDetailView.show_Id = String(id)
//    //                videoDetailView.fromCategories = false
//                self.present(videoDetailView, animated: true, completion: nil)
            }
           
        }
    }
  
    func didFocusFilmOfTheDay() {
        self.setNeedsFocusUpdate()
//        self.updateFocusIfNeeded()
//        HomeTableView.setContentOffset(.zero, animated: true)

    }
    func didFocusNewArrivals(passModel: VideoModel) {
    }
    func didFocusThemes(passModel: VideoModel) {
    }
    func didFocusDianamicVideos(passModel: VideoModel) {
    }
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
      print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}






extension UIView{
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor,heightValue:CGFloat) {
     let gradientLayer = CAGradientLayer()
     gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
     gradientLayer.locations = [0.0, 1.0]
     gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heightValue)
     layer.insertSublayer(gradientLayer, at: 0)
   }
}
extension HomeViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return menuArray.count
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        if let previouslyFocusedIndexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: previouslyFocusedIndexPath) {
            let collectionViewWidth = menuCollectionView.frame.width
            let cellWidth = cell.frame.width
            let rowCount = Int(ceil(collectionViewWidth / cellWidth))
            let remender = previouslyFocusedIndexPath.row % rowCount
            let nextIndex = previouslyFocusedIndexPath.row - remender + rowCount
            if let nextFocusedInndexPath = context.nextFocusedIndexPath {
                if context.focusHeading == .down {
                    moveFocus(to: IndexPath(row: nextIndex, section: 0))
                    return true
                }
            }
        }
        return true
    }

    private func moveFocus(to indexPath: IndexPath) {
        lastFocusedIndexPath = indexPath
        DispatchQueue.main.async {
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
        }
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return lastFocusedIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menuArray[indexPath.item] == "Home"{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if menuArray[indexPath.item] == "Live"{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveTabVC") as! LiveTabViewController
           
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if menuArray[indexPath.item] == "On-Demand"{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "DemandVC") as! DemandViewController
           
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if menuArray[indexPath.item] == "Catch-up"{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CatchupVC") as! CatchupViewController
           
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if menuArray[indexPath.item] == "My List"{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if menuArray[indexPath.item] == "Search"{
            let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! HomeSearchViewController
            let searchController = UISearchController(searchResultsController: resultsController)
            searchController.searchResultsUpdater = resultsController
            let searchPlaceholderText = NSLocalizedString("Search Title", comment: "")
            searchController.searchBar.placeholder = searchPlaceholderText
            searchController.searchBar.delegate = resultsController
             searchController.searchBar.keyboardAppearance = .dark
            searchController.searchBar.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            searchController.view.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
            self.present(searchContainerViewController, animated: false, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        if indexPath.row == 0{
            cell.menuLabel.textColor = .white
        }else{
            cell.menuLabel.textColor = .gray
        }
            cell.menuItem = menuArray[indexPath.row]
            return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return CGSize(width: 150, height: 80)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom:0, right:25)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
extension HomeViewController:DemandTableViewCellDelegate{
    func didSelectMoreInfo(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
            let id = Int(passModel.show_id!)
            videoDetailView.show_Id = String(id)
//                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    
    func didSelectWatchlist(passModel: VideoModel?) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
            self.present(videoDetailView, animated: false, completion: nil)
           
        }
    }
    
    func didSelectPlayIcon(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
            let id = Int(passModel.show_id!)
            videoDetailView.show_Id = String(id)
//                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    
    
    
}
extension HomeViewController:ScheduleListTableViewCellDelegate{
    func didSelectEarlierShows() {
        
    }
    
    func didSelectOnDemand(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
            let id = Int(passModel.show_id!)
            videoDetailView.show_Id = String(id)
//                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    
//    func didSelectMoreInfo(passModel: VideoModel) {
//        if let passModel = passModel  {
//            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
//            let id = Int(passModel.show_id!)
//            videoDetailView.show_Id = String(id)
////                videoDetailView.fromCategories = false
//            self.present(videoDetailView, animated: true, completion: nil)
//        }
//    }
    
    func didSelectReminder(passModel: VideoModel?) {
//        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
//            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
//            self.present(videoDetailView, animated: false, completion: nil)
//
//        }
//        else{
            commonClass.showAlert(viewController:self, messages: "Reminder updated")
//        }
      
    }
    
}
extension HomeViewController : PopUpDelegate{
    func handleAccountButtonAction(action: Bool) {
//        let accountVC =  self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
//        self.present(accountVC, animated: false, completion: nil)
        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
        self.present(videoDetailView, animated: false, completion: nil)
    }
    
    func handleLogoutAction(action: Bool) {
            var parameterDict: [String: String?] = [ : ]

            if let deviceid = UserDefaults.standard.string(forKey:"UDID") {
                parameterDict["device_id"] = deviceid
            }
            if let user_id = UserDefaults.standard.string(forKey:"user_id") {
                parameterDict["user_id"] = user_id
            }
            if let pubid = UserDefaults.standard.string(forKey:"pubid") {
                parameterDict["pubid"] = pubid
            }
            if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
                parameterDict["ipaddress"] = ipAddress
            }
            ApiCommonClass.logOutAction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (result) -> () in
                print(result)
                if result {
                    UserDefaults.standard.removeObject(forKey: "user_id")
                    UserDefaults.standard.removeObject(forKey: "login_status")
                    UserDefaults.standard.removeObject(forKey: "first_name")
                    UserDefaults.standard.removeObject(forKey: "skiplogin_status")
                    UserDefaults.standard.removeObject(forKey: "access_token")
                    Application.shared.userSubscriptionsArray.removeAll()
                    self.skipLogin()
                    
                } else {
    
                }
            }

        
        
    }

}
extension HomeViewController:TopBannerTableViewCellDelegate{
    func didSelectTopBanner(passModel: VideoModel) {
        if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
            print("No Functionality")
        }else{
            self.MoveTOLoginPage()
        }
    }
}
extension HomeViewController:DemandShowsListingTableCellDelegate{
    func didSelectDemandShows(passModel: VideoModel) {
        if  UserDefaults.standard.string(forKey:"skiplogin_status") == "false" {
            print("No Functionality")
        }else{
            self.MoveTOLoginPage()
        }
    }
    
    @objc func goToMoreIconAction(sender:Any){
        let section = sender as? UIButton
        print("button section",section!.tag)
        if dianamicVideos[section!.tag].type == "CATEGORY_SHOWS" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListingViewController
            let id = Int(dianamicVideos[section!.tag].category_id!)
            videoDetailView.categoryID = String(id)
            videoDetailView.categoryName = dianamicVideos[section!.tag].category_name!
            self.present(videoDetailView, animated: true, completion: nil)
       }
        else if dianamicVideos[section!.tag].type == "FEATURED" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListingViewController
            let id = Int(dianamicVideos[section!.tag].category_id!)
            videoDetailView.categoryID = String(id)
            videoDetailView.categoryName = dianamicVideos[section!.tag].category_name!
            self.present(videoDetailView, animated: true, completion: nil)
       }
       print("row column ",section)
       
   }
    
}
//extension HomeViewController : CustomHeaderDelegate{
//    func customHeader(_ customHeader: CustomHeader, didTapButtonInSection section: Int) {
//         if dianamicVideos[section].type == "CATEGORY_SHOWS" {
//             let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListingViewController
//             let id = Int(dianamicVideos[section].category_id!)
//             videoDetailView.categoryID = String(id)
//             videoDetailView.categoryName = dianamicVideos[section].category_name!
//             self.present(videoDetailView, animated: true, completion: nil)
//        }
//        else if dianamicVideos[section].type == "SHOW" {
//            let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
//            let id = Int((dianamicVideos[section].shows?[0].video_id!)!)
//            episodeVC.video_Id = String(id)
//            self.present(episodeVC, animated: true, completion: nil)
//        }
//        print("row column ",section)
//
//    }
//
//
//}
