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
    
    @IBOutlet weak var imageViewLive: UIImageView!{
        didSet{
            self.imageViewLive.layer.cornerRadius = 8
            self.imageViewLive.layer.masksToBounds = true
        }
    }
   
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
    
    @IBOutlet weak var searchButton: UIButton!{
        didSet{
          
            
    
                    searchButton.setTitle("", for: .normal)
                    let image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
//                     let new  = image.imageFlippedForRightToLeftLayoutDirection()

                    searchButton.setImage(image, for: .normal)
                    searchButton.tintColor = UIColor.white
                    searchButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                    searchButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
                    searchButton.layer.borderWidth = 0.0
                    searchButton.titleLabel?.font =  UIFont(name: "ITCAvantGardePro-Bk", size: 20)
                    searchButton.titleLabel?.textColor = UIColor.white
                    searchButton.layer.cornerRadius = 10
                    searchButton.titleLabel?.textAlignment = .center
                    searchButton.layer.masksToBounds = true
//                    searchButton.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
                    searchButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//                    searchButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                    searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            searchButton.addTarget(self, action: #selector(self.searchAction), for: UIControl.Event.primaryActionTriggered)
        }
    }
    
    @objc func searchAction(){
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

    
    @IBOutlet weak var timeImage: UIImageView!
    
    @IBOutlet weak var videoImageHeight: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3

    var catchupVideoArray = [VideoModel?]()
    var catchupFilterArray = [showByCategoryModel]()
    var menuArray = [String]()
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
       
        
        
        
        
        let width = UIScreen.main.bounds.width - 260
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
        let menuPressRecognizer = UITapGestureRecognizer()
               menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
               menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
               self.view.addGestureRecognizer(menuPressRecognizer)
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]
        }
        else{
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]

        }
        lastFocusedIndexPath = IndexPath(row: 0, section: 0)

        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
    @objc func menuButtonAction() {
        print("menu pressed")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    let scale = 1.0

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if playButton.isFocused{
            playButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.searchButton.tintColor = .white
            demandButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            demandButton.setTitleColor(UIColor.white, for: .normal)
            demandButton.layer.borderColor = UIColor.clear.cgColor

        }
        else if demandButton.isFocused{
            demandButton.backgroundColor = .white
            demandButton.setTitleColor(UIColor.black, for: .normal)
            self.searchButton.tintColor = .white
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playButton.backgroundColor = .clear
            demandButton.layer.borderColor = UIColor.clear.cgColor


        }
       else  if self.filterButton.isFocused {
           
           filterButton.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            playButton.backgroundColor = .clear
           self.searchButton.tintColor = .white
           demandButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
           demandButton.setTitleColor(UIColor.white, for: .normal)
           demandButton.layer.borderColor = UIColor.clear.cgColor


                // handle focus appearance changes
            }
        else if accountButton.isFocused {
            self.accountButton.transform = CGAffineTransformMakeScale(scale, scale)
            self.accountOuterView.layer.borderWidth = 3
            self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.accountButton.layer.cornerRadius = 35
            self.accountButton.layer.masksToBounds = true
            playButton.backgroundColor = .clear
            self.searchButton.tintColor = .white
            demandButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            demandButton.setTitleColor(UIColor.white, for: .normal)
            demandButton.layer.borderColor = UIColor.clear.cgColor


        }
        else if searchButton.isFocused {
            self.searchButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            self.searchButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            playButton.backgroundColor = .clear
            demandButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            demandButton.setTitleColor(UIColor.white, for: .normal)
            demandButton.layer.borderColor = UIColor.clear.cgColor


        }
        else{
            playButton.backgroundColor = .clear
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            self.filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.searchButton.tintColor = .white
            demandButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
            demandButton.setTitleColor(UIColor.white, for: .normal)
            demandButton.layer.borderColor = UIColor.clear.cgColor



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
    
    @IBAction func onDemandAction(_ sender: Any) {
        if let passModel = self.liveVideos[0].now_playing  {
            if passModel.show_id != nil{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
                let id = Int(passModel.show_id!)
                videoDetailView.show_Id = String(id)
                self.present(videoDetailView, animated: true, completion: nil)
            }
            else{
                commonClass.showAlert(viewController: self, messages: "No Live Found")
                
            }
        }
        else{
            commonClass.showAlert(viewController: self, messages: "No Live Found")
            
        }
    }
    func getLiveChannel() {
        print("getLiveGuide")
        commonClass.startActivityIndicator(onViewController: self)

        ApiCommonClass.getAllChannels { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        commonClass.stopActivityIndicator(onViewController: self)

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
            if let  url = liveVideos[0].live_link{
                self.videoUrl = url
            }
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
                                                           
                            self.scheduleVideos = data
                            self.allLiveVideos = data
                            self.getListByFilterDay(date: self.dateArray[self.selectedDateArrayIndex]!, dateString: self.dayArray[self.selectedDateArrayIndex]!)
                            self.videoListingTableView.isHidden = false
                            commonClass.stopActivityIndicator(onViewController: self)

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
    func getListByFilterDay(date:Date,dateString:String){
        if let value = allLiveVideos?.filter({ Calendar.current.isDate(self.convertStringTimeToDate(item:$0.starttime!), inSameDayAs:date)}){
            self.scheduleVideos?.removeAll()
            self.scheduleVideos = value
            if dateString == "Today"{
                self.todayFeaturedVideos = value
                print("top featured getListByFilterDay",self.todayFeaturedVideos?.count)
                if let array = self.todayFeaturedVideos?.filter({$0.status == "NOW_PLAYING"}){
                    if array.count > 0{
                        let endTime = array[0].endtime
                        let startTime = array[0].starttime
                        if let upcomingArray =  self.todayFeaturedVideos?.filter({endTime!<=$0.starttime!}){
                            self.scheduleVideos? = upcomingArray
                            DispatchQueue.main.async {
                                let width = (UIScreen.main.bounds.width) - 30//some width
                                let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                                let spaceHeight = (self.scheduleVideos!.count * 25)
                                self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                                self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                                self.videoListingTableView.reloadData()
                                if self.scheduleVideos!.count > 0{
                                    let index = IndexPath(item: 0, section: 0)
                                   
                                }

                            }
                            print("upcoming guide array",self.scheduleVideos?.count)
                        }
                        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime! <= startTime!}){
                            print("previous guide array",previousArray.count)
                        }
                    }
                    else{
                        setupUpcoming()
                    }
                    
                }
                else{
                    setupUpcoming()
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    if self.scheduleVideos!.count > 0{
                        let width = (UIScreen.main.bounds.width) - 30//some width
                        let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                        let spaceHeight = (self.scheduleVideos!.count * 25)
                        self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                        self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                        self.videoListingTableView.reloadData()
                        let index = IndexPath(item: 0, section: 0)
                    }

                }
            }
        }
    }
    var upcomingFilterImageClicked = false
    @IBAction func filterAction(_ sender: Any) {
        if !upcomingFilterImageClicked{
            scheduleVideos?.removeAll()
            print("top featured getEarlierShows blue",self.todayFeaturedVideos?.count)
            if let array = self.todayFeaturedVideos?.filter({$0.status == "NOW_PLAYING"}){
                if array.count > 0{
                    let endTime = array[0].endtime
                    let startTime = array[0].starttime
                    if let upcomingArray =  self.todayFeaturedVideos?.filter({endTime!<=$0.starttime!}){
                        
                    }
                    if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime!<=startTime!}){
                        self.scheduleVideos? = previousArray
                        DispatchQueue.main.async {
                            let width = (UIScreen.main.bounds.width) - 30//some width
                            let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                            let spaceHeight = (self.scheduleVideos!.count * 25)
                            self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                            self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                            self.videoListingTableView.reloadData()
                        }
                        print("previous guide array",previousArray.count)
                    }
                }
                else{
                    setupUpPreviusArray()
                }
            }
            else{
                setupUpPreviusArray()
            }
            let image = UIImage(named: "arrow-up")?.withRenderingMode(.alwaysTemplate)
            filterButton.setImage(image, for: .normal)
            filterButton.tintColor = ThemeManager.currentTheme().buttonTextColor
            filterButton.setTitleColor(ThemeManager.currentTheme().buttonTextColor, for: .normal)
            filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
           
           
        }
            else{
                print("top featured getEarlierShows black",self.todayFeaturedVideos?.count)

                if let array = self.todayFeaturedVideos?.filter({$0.status == "NOW_PLAYING"}){
                    if array.count > 0{
                        let endTime = array[0].endtime
                        let startTime = array[0].starttime
                        if let upcomingArray =  self.todayFeaturedVideos?.filter({endTime!<=$0.starttime!}){
                            self.scheduleVideos? = upcomingArray
                            DispatchQueue.main.async {
                                let width = (UIScreen.main.bounds.width) - 30//some width
                                let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                                let spaceHeight = (self.scheduleVideos!.count * 25)
                                self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                                self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                                self.videoListingTableView.reloadData()
                            }
                            print("upcoming guide array",self.scheduleVideos?.count)
                        }
                        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime!<=startTime!}){
                            print("previous guide array",previousArray.count)
                        }
                    }
                    else{
                        self.setupUpcoming()
                    }
                }
                else{
                    self.setupUpcoming()
                }
                let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
                filterButton.setImage(image, for: .normal)
                filterButton.tintColor = ThemeManager.currentTheme().buttonTextColor
                filterButton.setTitleColor(ThemeManager.currentTheme().buttonTextColor, for: .normal)
                filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            }
            upcomingFilterImageClicked = !upcomingFilterImageClicked
      
    }
    func setupUpcoming(){
        let currentTime =  Date()
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let currentDateString = df.string(from: currentTime)
        print("date formatted",currentDateString)
        if let upcomingArray =  self.todayFeaturedVideos?.filter({currentDateString < $0.starttime!}){
            self.scheduleVideos = upcomingArray
           

            if scheduleVideos!.count > 0{
                let width = (UIScreen.main.bounds.width) - 30//some width
                let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                let spaceHeight = (self.scheduleVideos!.count * 25)
                self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                self.videoListingTableView.reloadData()
                let index = IndexPath(item: 0, section: 0)
            }

        }
        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime! <= currentDateString}){
//             self.upcomingGuideArray = previousArray
        }
    }
    func setupUpPreviusArray(){
        let currentTime =  Date().localDate()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        df.timeZone = TimeZone(abbreviation: "UTC")
        let currentDateString = df.string(from: currentTime)
        print("date formatted",currentDateString)
        if let upcomingArray =  self.todayFeaturedVideos?.filter({currentDateString < $0.starttime!}){
            
        }
        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime! <= currentDateString}){
            self.scheduleVideos = previousArray
            if scheduleVideos!.count > 0{
                let width = (UIScreen.main.bounds.width) - 30//some width
                let height =   (self.scheduleVideos!.count * ((9 * Int(width)) / 16)) + 140
                let spaceHeight = (self.scheduleVideos!.count * 25)
                self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                self.videoListingTableView.reloadData()
            }

            print("previous guide array",previousArray.count)
        }
        
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
        if let  url = liveVideos[0].live_link{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveVC") as! LivePlayingViewController
            videoDetailView.channelVideo = self.liveVideos[0]
            self.present(videoDetailView, animated: true, completion: nil)
            
        }
       
        
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
        cell.delegate = self
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
            else if menuArray[indexPath.item] == "Schedule"{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveTabVC") as! LiveTabViewController
               
                self.present(videoDetailView, animated: false, completion: nil)
            }
            else if menuArray[indexPath.item] == "On-Demand"{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "DemandVC") as! DemandViewController
               
                self.present(videoDetailView, animated: false, completion: nil)
            }
            else if menuArray[indexPath.item] == "Watch Live"{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CatchupVC") as! CatchupViewController
               
                self.present(videoDetailView, animated: false, completion: nil)
            }
            else if menuArray[indexPath.item] == "My List"{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
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
            selectedDateArrayIndex = indexPath.row
           getListByFilterDay(date: dateArray[indexPath.item]!, dateString: dayArray[indexPath.item]!)
            //Need to fix crash when there is  no data at the first cell
           
            if let cell = collectionView.cellForItem(at: indexPath) as! DayFilterCollectionViewCell?{
                cell.backgroundColor = ThemeManager.currentTheme().focusedColor
            }
            if dayArray[indexPath.row] == "Today"{
                self.todayFeaturedVideos = scheduleVideos
                self.filterButton.isHidden = false
                getListByFilterDay(date: dateArray[indexPath.item]!, dateString: dayArray[indexPath.item]!)
                filterButton.backgroundColor = ThemeManager.currentTheme().focusedColor
                let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
                filterButton.setImage(image, for: .normal)
                filterButton.tintColor = UIColor.white
                filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
                upcomingFilterImageClicked = false
            }
            else{
                self.filterButton.isHidden = true
                getListByFilterDay(date: dateArray[indexPath.item]!, dateString: dayArray[indexPath.item]!)

            }
          
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
        if indexPath.row == 0{
            cell.menuLabel.textColor = ThemeManager.currentTheme().buttonTextColor
        }
        else{
            cell.menuLabel.textColor = .white
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
        return 75
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == filterCollectionView{
           return 25
        }
        return 75
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
extension CatchupViewController:ScheduleListTableViewCellDelegate{
    func didSelectEarlierShows() {
        let indexPosition = IndexPath(row: 0, section: 1)
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
    
    func didSelectReminder(passModel: VideoModel?) {
        print("reminder added")
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
            self.present(videoDetailView, animated: false, completion: nil)

        }else{
            commonClass.showAlert(viewController:self, messages: "Reminder updated")
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
