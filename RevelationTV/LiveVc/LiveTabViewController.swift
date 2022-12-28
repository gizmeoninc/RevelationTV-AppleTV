//
//  LiveTabViewController.swift
//  KICCTV
//
//  Created by GIZMEON on 09/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability

class LiveTabViewController: UIViewController{
    @IBOutlet weak var liveTableView: UITableView!{
        didSet{
            liveTableView.isHidden = true
            liveTableView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
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
    
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var mainView: UIView!
    {
        didSet{
            self.mainView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var comingSoonLabel: UILabel!
    {
        didSet{
            comingSoonLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
            comingSoonLabel.textColor = ThemeManager.currentTheme().headerTextColor
            comingSoonLabel.text = "Coming Up"
        }
    }
    @IBOutlet weak var sepratorView: UIView!
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    @IBOutlet weak var filterButton: UIButton!{
        didSet{
            filterButton.setTitle("Earlier Shows", for: .normal)
            let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
            filterButton.setImage(image, for: .normal)
            filterButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            filterButton.layer.borderWidth = 3.0
            filterButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            filterButton.titleLabel?.textColor = ThemeManager.currentTheme().ButtonBorderColor
            filterButton.setTitleColor(ThemeManager.currentTheme().ButtonBorderColor, for: .normal)
            filterButton.layer.cornerRadius = 8
            filterButton.titleLabel?.textAlignment = .center
            filterButton.layer.masksToBounds = true
            filterButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var filterCollectionViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var liveTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchButton: UIButton!{
        didSet{
            searchButton.setTitle("", for: .normal)
            let image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)

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

    let reachability = try! Reachability()
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    var dianamicVideos = [showByCategoryModel]()
    var scheduleVideos : [VideoModel]?
    var liveVideos = [VideoModel]()
    var menuArray = [String]()
    var lastFocusedIndexPath: IndexPath?
    var allLiveVideos : [VideoModel]?
    var todayFeaturedVideos : [VideoModel]?
    var selectedIndex = 0
    var selectedFilter = 0
    var selectedDateArrayIndex = 0
    var selectedDateStringIndex = 0
    var dayArray = [String?]()
    var dateArray = [Date?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nibVideoList =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        let nibLive =  UINib(nibName: "LiveTableViewCell", bundle: nil)
        liveTableView.register(nibLive, forCellReuseIdentifier: "LiveTableCell")
        let nibSchedule =  UINib(nibName: "ScheduleListTableViewCell", bundle: nil)
        liveTableView.register(nibSchedule, forCellReuseIdentifier: "ScheduleListTableCell")
//        liveTableView.register(nibVideoList, forCellReuseIdentifier: "HomeTableCell")
        liveTableView.delegate = self
        liveTableView.dataSource = self
        liveTableView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        liveTableView.contentInsetAdjustmentBehavior = .never
        liveTableView.tableFooterView = UIView()

        
        filterCollectionView.register(UINib(nibName: "DayFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dayFilterCollectionCell")
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        
        filterCollectionViewHeight.constant = 120
        getWeekDays()
        self.getLiveGuide()
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        let menuPressRecognizer = UITapGestureRecognizer()
               menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
               menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
               self.view.addGestureRecognizer(menuPressRecognizer)
    }
    @objc func menuButtonAction() {
        print("menu pressed")
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]
        }
        else{
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]

        }
        lastFocusedIndexPath = IndexPath(row: 3, section: 0)

        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [menuCollectionView]
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
    let scale = 1.0
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if accountButton.isFocused {
            self.accountButton.transform = CGAffineTransformMakeScale(scale, scale)
            self.accountOuterView.layer.borderWidth = 3
            self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.accountButton.layer.cornerRadius = 35
            self.accountButton.layer.masksToBounds = true
            self.filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.searchButton.tintColor = .white


        }
        else if filterButton.isFocused{
            self.filterButton.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            self.searchButton.tintColor = .white

        }
        else if searchButton.isFocused {
            self.searchButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            self.searchButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            self.filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            
        }
        else{
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            self.filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.searchButton.tintColor = .white


            
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
                                let width =  (UIScreen.main.bounds.width/4.5)
                                let height =   self.scheduleVideos!.count * (((9 * Int(width)) / 16) + 70)
                                let spaceHeight = self.scheduleVideos!.count * 20

                                self.liveTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                                self.mainViewHeight.constant = self.filterCollectionViewHeight.constant + self.liveTableViewHeight.constant + 300
                                self.liveTableView.reloadData()
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
                        let width =  (UIScreen.main.bounds.width/4.5)
                        let height =   self.scheduleVideos!.count * (((9 * Int(width)) / 16) + 70)
                        let spaceHeight = self.scheduleVideos!.count * 20

                        self.liveTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                        self.mainViewHeight.constant = self.filterCollectionViewHeight.constant + self.liveTableViewHeight.constant +  300
                        self.liveTableView.reloadData()
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
                            let width =  (UIScreen.main.bounds.width/4.5)
                            let height =   self.scheduleVideos!.count * (((9 * Int(width)) / 16) + 70)
                            let spaceHeight = self.scheduleVideos!.count * 20

                            self.liveTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                            self.mainViewHeight.constant = self.filterCollectionViewHeight.constant + self.liveTableViewHeight.constant + 300
                            self.liveTableView.reloadData()
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
                                let width =  (UIScreen.main.bounds.width/4.5)
                                let height =   self.scheduleVideos!.count * (((9 * Int(width)) / 16) + 70)
                                let spaceHeight = self.scheduleVideos!.count * 20

                                self.liveTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                                self.mainViewHeight.constant = self.filterCollectionViewHeight.constant + self.liveTableViewHeight.constant + 300
                                self.liveTableView.reloadData()
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
                let width =  (UIScreen.main.bounds.width/4.5)
                let height =   self.scheduleVideos!.count * (((9 * Int(width)) / 16) + 70)
                let spaceHeight = self.scheduleVideos!.count * 20

                self.liveTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                self.mainViewHeight.constant = self.filterCollectionViewHeight.constant + self.liveTableViewHeight.constant + 300
                self.liveTableView.reloadData()
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
                let width =  (UIScreen.main.bounds.width/4.5)
                let height =   self.scheduleVideos!.count * (((9 * Int(width)) / 16) + 70)
                let spaceHeight = self.scheduleVideos!.count * 20
                self.liveTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                self.mainViewHeight.constant = self.filterCollectionViewHeight.constant + self.liveTableViewHeight.constant + 300
                self.liveTableView.reloadData()
            }

            print("previous guide array",previousArray.count)
        }
        
    }
    
    func getLiveGuide() {
        print("getLiveGuide")
        commonClass.startActivityIndicator(onViewController: self)

        ApiCommonClass.getLiveGuide { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.liveTableView.isHidden = true
                        commonClass.stopActivityIndicator(onViewController: self)


                    }
                }
            } else {
                self.scheduleVideos?.removeAll()
                self.allLiveVideos?.removeAll()

                if let videos = responseDictionary["data"] as? [VideoModel]? {
                    self.scheduleVideos = videos!
                    self.allLiveVideos = videos

                    if self.scheduleVideos?.count == 0 {
                        self.liveTableView.isHidden = true
                        commonClass.stopActivityIndicator(onViewController: self)

                    }else{
                        DispatchQueue.main.async {
                            self.getListByFilterDay(date: self.dateArray[self.selectedDateArrayIndex]!, dateString: self.dayArray[self.selectedDateArrayIndex]!)
                            self.liveTableView.isHidden = false
                           
                            commonClass.stopActivityIndicator(onViewController: self)

                        }
                    }
                }
            }
        }
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
extension LiveTabViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
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
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        cell.selectionStyle = .none
        if upcomingFilterImageClicked{
            cell.watchlistButton.isHidden = true
        }
        else{
            cell.watchlistButton.isHidden = false
        }
           
        cell.delegate = self
        cell.layer.cornerRadius = 8
            return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let width =  (UIScreen.main.bounds.width/4.5)
            let height = (9 * (width)) / 16
            return height + 70
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
  
}
extension LiveTabViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView{
            if dayArray.count > 0{
                return dayArray.count
            }
            return 0
        }
       
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
        if collectionView == filterCollectionView{
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
        }else{
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
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFilterCollectionCell", for: indexPath as IndexPath) as! DayFilterCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.dayItem = dayArray[indexPath.row]
            return cell
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        if indexPath.row == 3{
            cell.menuLabel.textColor = ThemeManager.currentTheme().ButtonBorderColor
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
extension LiveTabViewController:ScheduleListTableViewCellDelegate{
    func didSelectEarlierShows() {
        let indexPosition = IndexPath(row: 0, section: 1)
        self.liveTableView.scrollToRow(at: indexPosition, at: .bottom, animated: true)
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
extension LiveTabViewController : PopUpDelegate{
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
