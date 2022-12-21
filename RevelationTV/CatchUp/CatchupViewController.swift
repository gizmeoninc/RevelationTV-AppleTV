//
//  CatchupViewController.swift
//  KICCTV
//
//  Created by GIZMEON on 08/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
class CatchupViewController: UIViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            mainScrollView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            mainView.isHidden = true
        }
    }
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
    @IBOutlet weak var dropDownArrowACcount: UIImageView!{
        didSet{
            dropDownArrowACcount.setImageColor(color: ThemeManager.currentTheme().headerTextColor)
        }
    }
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: UIButton!{
        didSet{
            let image = UIImage(named: "icons8-play-48")?.withRenderingMode(.alwaysTemplate)
            playButton.setImage(image, for: .normal)
            playButton.tintColor = UIColor.white
            playButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    @IBOutlet weak var videoImageView: UIImageView!{
        didSet{
            videoImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var filterCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var videoListingTableView: UITableView!
    
    @IBOutlet weak var videoListingTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var metaDataView: UIView!{
        didSet{
            metaDataView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
    
    @IBOutlet weak var metaDataViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var metaDataViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nowPlayingHeaderLabel: UILabel!{
        didSet{
            nowPlayingHeaderLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
            nowPlayingHeaderLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    @IBOutlet weak var seperatorLine: UIView!{
        didSet{
            seperatorLine.backgroundColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    @IBOutlet weak var nowPlayingTimeLabel: UILabel!{
        didSet{
            nowPlayingTimeLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            nowPlayingTimeLabel.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    
    @IBOutlet weak var imageViewLive: UIImageView!
   
    @IBOutlet weak var nowPlayingTitle: UILabel!{
        didSet{
            nowPlayingTitle.font = UIFont(name: "ITCAvantGardePro-Bk", size: 30)
            nowPlayingTitle.textColor = ThemeManager.currentTheme().headerTextColor
        }
    }
    
    @IBOutlet weak var nowPlayingDescription: UILabel!{
        didSet{
            nowPlayingDescription.font = UIFont(name: ThemeManager.currentTheme().fontLight, size: 20)
            nowPlayingDescription.textColor = ThemeManager.currentTheme().descriptionTextColor
            nowPlayingDescription.numberOfLines = 6
        }
    }
    
    @IBOutlet weak var demandButton: UIButton!{
    didSet{
        demandButton.setTitle("On Demand", for: .normal)
        demandButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
        demandButton.layer.borderColor = ThemeManager.currentTheme().buttonTextColor.cgColor
        demandButton.layer.borderWidth = 3.0
        demandButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 20)
        demandButton.layer.cornerRadius = 10
        demandButton.titleLabel?.textAlignment = .center
        demandButton.titleLabel?.textColor = UIColor.white
        demandButton.layer.masksToBounds = true
       
    }
}
    
    @IBOutlet weak var filterButton: UIButton!{
        didSet{
            filterButton.setTitle("Earlier Shows", for: .normal)
            let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
            filterButton.setImage(image, for: .normal)
            filterButton.tintColor = ThemeManager.currentTheme().buttonTextColor
            filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            filterButton.layer.borderWidth = 3.0
            filterButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            filterButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            filterButton.setTitleColor(ThemeManager.currentTheme().buttonTextColor, for: .normal)
            filterButton.layer.cornerRadius = 8
            filterButton.titleLabel?.textAlignment = .center
            filterButton.layer.masksToBounds = true
            filterButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    
    
    
    
    @IBOutlet weak var timeImage: UIImageView!
    
    @IBOutlet weak var videoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3

    var catchupVideoArray = [VideoModel?]()
    var catchupFilterArray = [showByCategoryModel]()
    var menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]
    var lastFocusedIndexPath: IndexPath?
    var selectCollectionView = false
    var videoUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        restoresFocusAfterTransition = false
        let nibVideoLIst =  UINib(nibName: "ScheduleListTableViewCell", bundle: nil)
        videoListingTableView.register(nibVideoLIst, forCellReuseIdentifier: "ScheduleListTableCell")
        videoListingTableView.delegate = self
        videoListingTableView.dataSource = self
        videoListingTableView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        videoListingTableView.contentInsetAdjustmentBehavior = .never
        videoListingTableView.contentInset = .zero
        videoListingTableView.separatorInset = .zero
        filterCollectionView.register(UINib(nibName: "DayFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dayFilterCollectionCell")
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        
        filterCollectionViewHeight.constant = 120
       
        
        
        
        
        let width = UIScreen.main.bounds.width - 200
        self.videoImageViewWidth.constant = width - (width/3)
         let height = (self.videoImageViewWidth.constant*9)/16
        self.playerViewHeight.constant = height
        self.videoImageHeight.constant = height
        self.metaDataViewWidth.constant = width / 3
        self.metaDataViewHeight.constant =  height
        self.imageViewWidth.constant = self.metaDataViewWidth.constant/2
        self.imageViewHeight.constant = (imageViewWidth.constant * 9)/16
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        getWeekDays()
        self.getLiveChannel()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)

            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeDown.direction = .up
            self.view.addGestureRecognizer(swipeDown)
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Home","Live","On-Demand","Catch-up","Search"]
        }
        else{
            self.menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]

        }
        lastFocusedIndexPath = IndexPath(row: 3, section: 0)

        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
    let scale = 1.0

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if playButton.isFocused{
            playButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
        }
       else  if self.filterButton.isFocused {
           
           filterButton.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
             playButton.backgroundColor = .clear
           

                // handle focus appearance changes
            }
        else if accountButton.isFocused {
            self.accountButton.transform = CGAffineTransformMakeScale(scale, scale)
            self.accountOuterView.layer.borderWidth = 3
            self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            self.accountButton.layer.cornerRadius = 35
            self.accountButton.layer.masksToBounds = true
            playButton.backgroundColor = .clear
        }
        else{
            playButton.backgroundColor = .clear
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            self.filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

        }
    }
    @objc func click(sender: UIButton) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
            self.present(videoDetailView, animated: false, completion: nil)
           
        }
        else{
            CustomPopupViewController.showPopup(parentVC: self)

        }
        print("click")
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
    
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
               
                print("Swiped down")
            case .left:
                print("Swiped left")
            case .up:
                    print("Swiped up")
               
            default:
                break
            }
        }
    }
    override weak var preferredFocusedView: UIView? {
        return menuCollectionView
//        if selectCollectionView{
//            return playButton
//        }
//        else{
//            return menuCollectionView
//        }
      
    }
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [menuCollectionView]

//        if selectCollectionView{
//            return [playButton]
//
//        }
//        else{
//            return [menuCollectionView]
//        }
    }
    var allLiveVideos : [VideoModel]?
    var todayFeaturedVideos : [VideoModel]?
    var scheduleVideos : [VideoModel]?
    var selectedIndex = 0
    var selectedFilter = 0
    var selectedDateArrayIndex = 0
    var selectedDateStringIndex = 0
    var dayArray = [String?]()
    var dateArray = [Date?]()
    var liveVideos = [VideoModel]()

    func getLiveChannel() {
        print("getLiveGuide")
        commonClass.startActivityIndicator(onViewController: self)

        ApiCommonClass.getAllChannels { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        commonClass.stopActivityIndicator(onViewController: self)

//                        self.getLiveGuide()
                    }
                }
            } else {
                self.liveVideos.removeAll()
                if let videos = responseDictionary["data"] as? [VideoModel]? {
                    self.liveVideos = videos!
                    if self.liveVideos.count == 0 {
                        self.imageViewLive.image = UIImage(named: "landscape_placeholder")
                    }else{
                        self.setupNowPlayingView()
                    }
                }
                self.getCatchUpList()
            }
        }
    }
    func setupNowPlayingView(){
        if let nowplayingVideoArray = liveVideos[0].now_playing{
            if nowplayingVideoArray.video_title != nil{
                self.nowPlayingTitle.text = nowplayingVideoArray.video_title
            }else{
                self.nowPlayingTitle.text = ""
            }
            if nowplayingVideoArray.video_description != nil{
                self.nowPlayingDescription.text = nowplayingVideoArray.video_description
            }else{
                self.nowPlayingDescription.text = ""
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
            if  nowplayingVideoArray.thumbnail_350_200 != nil {
                let image =  nowplayingVideoArray.thumbnail_350_200
                if image!.starts(with: "https"){
                    self.imageViewLive.sd_setImage(with: URL(string: ((nowplayingVideoArray.thumbnail_350_200)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    
                }
                else{
                    self.imageViewLive.sd_setImage(with: URL(string: showUrl + (nowplayingVideoArray.thumbnail_350_200!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                }
                
            }
            else {
                self.imageViewLive.image = UIImage(named: "landscape_placeholder")
            }
            
        }
        
    }
    func getCatchUpList(){
        var parameterDict: [String: String?] = [ : ]
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getLiveGuide { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    self.videoListingTableView.isHidden = true
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n please try later")
                    self.mainView.isHidden = false
                }
            } else {
                self.scheduleVideos?.removeAll()
                  self.allLiveVideos?.removeAll()
                if let data = responseDictionary["data"] as? [VideoModel]{
                    if data.count == 0{
                        DispatchQueue.main.async {
                            commonClass.showAlert(viewController:self, messages: "No Result Found")
                            self.videoListingTableView.isHidden = true
                            commonClass.stopActivityIndicator(onViewController: self)
                            self.mainView.isHidden = false
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            //                                self.getListByFilterDay(date: self.dateArray[self.selectedDateArrayIndex]!, dateString: self.dayArray[self.selectedDateArrayIndex]!)
                            self.scheduleVideos = data
                            self.allLiveVideos = data
                            self.videoListingTableView.reloadData()
                            commonClass.stopActivityIndicator(onViewController: self)
                            let width = (UIScreen.main.bounds.width) - 30//some width
                            let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                            let spaceHeight = (self.scheduleVideos!.count * 25)
                            self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                            self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                        }
                        self.mainView.isHidden = false
                    }
                }
            }
            }
        }
    
    func getWeekDays(){
        var calendar = Calendar.autoupdatingCurrent
        let today = calendar.startOfDay(for: Date())
        var days = [Date]()
        for i in 0...6 {
            if let day = calendar.date(byAdding: .day, value: i, to: today) {
                days += [day]
            }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        for date in days {
            print(formatter.string(from: date))
            if date == today{
                self.dayArray.append("Today")
                let formattedDate = dateFormatter.string(from: date)
                let covertedDate  = dateFormatter.date(from: formattedDate)
                self.dateArray.append(covertedDate)
                
            }
            else{
                self.dayArray.append(formatter.string(from: date))
                let formattedDate = dateFormatter.string(from: date)
                let covertedDate = self.convertStringTimeToDate(item:formattedDate)
                self.dateArray.append(covertedDate)
            }
            
        }
        if self.dayArray.count != 0{
            DispatchQueue.main.async {
                self.filterCollectionView.reloadData()
                //                self.getLiveGuide()
            }
        }
        
        print(days)
    }
    
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
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
    func getDateAfterTenDays() -> String {
      let dateAftrTenDays =  (Calendar.current as NSCalendar).date(byAdding: .day, value: 10, to: Date(), options: [])!
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy"
      let date = formatter.string(from: dateAftrTenDays)
      return date
    }
       
    @IBAction func playButtonAction(_ sender: Any) {
         
        let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "catchupPlayerVC") as! CatchupVideoPlayer
        signupPageView.videoName = self.videoUrl
        self.present(signupPageView, animated: true, completion: nil)
        
    }
    
    
    
}
extension CatchupViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
    func cellSelected() {
        print("called")
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleVideos?.count ?? 0

        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableCell", for: indexPath) as! ScheduleListTableViewCell
        cell.scheduleItem =  scheduleVideos?[indexPath.section]
//        cell.delegate = self
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 8
            return cell
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
        print("hello")
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width =  (UIScreen.main.bounds.width/4.5)
        let height = (9 * (width)) / 16
        return height + 70

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
       
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
  
}
extension CatchupViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView{
            if dayArray.count > 0{
                return dayArray.count
            }
            return 0
        }
       
        return menuArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
                    print("focus move")
                    moveFocus(to: IndexPath(row: nextIndex, section: 0))
                    return true
                }
                
            }
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if collectionView == filterCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = filterCollectionView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                if context.focusHeading == .up {
                    print("up clicked")
                    selectCollectionView = true
//
//                    self.setNeedsFocusUpdate()
//                    self.updateFocusIfNeeded()
                }
                if context.focusHeading == .down {
                    selectCollectionView = false
                   print("down clicked")
                }
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = filterCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.layer.borderColor = ThemeManager.currentTheme().viewBackgroundColor.cgColor
                selectCollectionView = false
                
            }
        }
       
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
        if collectionView == menuCollectionView{
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
        else{
            self.catchupVideoArray = catchupFilterArray[indexPath.row].data!
            let width = (UIScreen.main.bounds.width) - 30//some width
            let height =   (self.catchupVideoArray.count * ((9 * Int(width)) / 16)) + 140
            let spaceHeight = (self.catchupVideoArray.count * 25)
            self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
//            let indexpathItem = IndexPath(row: 0, section: 0)
//            mainScrollView.setContentOffset(videoListingTableView.frame.origin, animated: true)
//            videoListingTableView.scrollToRow(at:indexpathItem, at: .top, animated: true)
//            videoListingTableView.reloadData()
             self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + playerViewHeight.constant
          
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFilterCollectionCell", for: indexPath as IndexPath) as! DayFilterCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.dayItem = dayArray[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        if indexPath.row == 3{
            cell.menuLabel.textColor = .white
        }
        else{
            cell.menuLabel.textColor = .gray
        }
            cell.menuItem = menuArray[indexPath.row]
            return cell
        }
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView{
            return CGSize(width: 230, height: 60)
        }
        return CGSize(width: 150, height: 80)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == filterCollectionView{
            return UIEdgeInsets(top: 0, left: 0, bottom:0, right:0)

        }
        return UIEdgeInsets(top: 0, left: 25, bottom:0, right:25)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == filterCollectionView{
           return 25
        }
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == filterCollectionView{
           return 25
        }
        return 50
    }
}
extension CatchupViewController:CatchupTableViewCellDelegate{
    func didSelectRemindIcon(passModel: VideoModel?) {
        print("remind icon")
        
    }
    
    func didSelectOnDemandIcon(passModel: VideoModel?) {
        if let passModel = passModel  {
            self.videoUrl = passModel.url!
            mainScrollView.setContentOffset(.zero, animated: true)
            self.setNeedsFocusUpdate()
            self.updateFocusIfNeeded()
        }
    }
    
    
}
extension CatchupViewController : PopUpDelegate{
    func handleAccountButtonAction(action: Bool) {
        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
        self.present(videoDetailView, animated: false, completion: nil)
//        let accountVC =  self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
//        self.present(accountVC, animated: false, completion: nil)
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
