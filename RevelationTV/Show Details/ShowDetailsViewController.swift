//
//  ShowDetailsViewController.swift
//  KICCTV
//
//  Created by GIZMEON on 10/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability
import TVOSPicker
class ShowDetailsViewController : UIViewController{
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
            mainScrollView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    @IBOutlet weak var episodeHeaderLabel: UILabel!{
        didSet{
            episodeHeaderLabel.text = "Episodes"
            episodeHeaderLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
            episodeHeaderLabel.textAlignment = .left
            episodeHeaderLabel.numberOfLines = 1
            episodeHeaderLabel.textColor = .white
            episodeHeaderLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var scheduleHeaderlabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var seasonButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var seasonButtonHeight: NSLayoutConstraint!
    
   
    @IBOutlet weak var seasonButton: UIButton!{
    didSet{
        seasonButton.setTitle("Season", for: .normal)
        let origImage = UIImage(named: "drop-down-arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        seasonButton.setImage(tintedImage, for: .normal)
        seasonButton.tintColor = .white
        seasonButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        seasonButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
        seasonButton.layer.borderWidth = 3.0
        seasonButton.titleLabel?.font =  UIFont(name: ThemeManager.currentTheme().fontRegular, size: 25)
        seasonButton.layer.cornerRadius = 30
        seasonButton.titleLabel?.textAlignment = .center
        seasonButton.layer.masksToBounds = true
        seasonButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        seasonButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        seasonButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        seasonButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        seasonButton.isHidden = true
    }
}

    
   
    @IBOutlet weak var videoListingCollectionView: UICollectionView!{
        didSet{
            videoListingCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            videoListingCollectionView.isHidden = true
        }
    }
    
    @IBOutlet weak var videoListingCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var ScheduleHeaderLabel: UILabel!{
        didSet{
            self.ScheduleHeaderLabel.textColor = ThemeManager.currentTheme().headerTextColor
            self.ScheduleHeaderLabel.font = UIFont.init(name: ThemeManager.currentTheme().fontRegular, size: 30)
            self.ScheduleHeaderLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var scheduleTableHeaderLabel: UILabel!{
        didSet{
            self.scheduleTableHeaderLabel.textColor = ThemeManager.currentTheme().headerTextColor
            self.scheduleTableHeaderLabel.font = UIFont.init(name: ThemeManager.currentTheme().fontRegular, size: 30)
            self.scheduleTableHeaderLabel.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.scheduleTableHeaderLabel.isHidden = true

        }
    }
    
    
    @IBOutlet weak var rerunTableViewHeaderLabel: UILabel!
    {
        didSet{
            self.rerunTableViewHeaderLabel.textColor = ThemeManager.currentTheme().headerTextColor
            self.rerunTableViewHeaderLabel.font = UIFont.init(name: ThemeManager.currentTheme().fontRegular, size: 30)
            self.rerunTableViewHeaderLabel.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    
    @IBOutlet weak var ScheduleSepearatorView: UIView!{
        didSet{
            ScheduleSepearatorView.isHidden = true
        }
    }
    
    @IBOutlet weak var scheduleView: UIView!{
        didSet{
            scheduleView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            scheduleView.isHidden = true
        }
    }
    
    @IBOutlet weak var scheduleViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scheduleViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scheduleTableView: UITableView!{
        didSet{
            scheduleTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var rerunView: UIView!{
        didSet{
            rerunView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            rerunView.isHidden = true
        }
    }
    
    @IBOutlet weak var rerunViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var rerunViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var rerunTableView: UITableView!{
        didSet{
            rerunTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var metaDataTableView: UITableView!{
        didSet{
            metaDataTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var metaDataTableViewHeight: NSLayoutConstraint!
    
    
    var scheduleArray = [ScheduleModel]()
    var rerunArray = [ScheduleModel]()
    
    
    
    
    
    let reachability = try! Reachability()
    var dianamicVideos = [showByCategoryModel]()
    var menuArray = ["Watch Live","Home","On-Demand","Schedule"]
    var lastFocusedIndexPath: IndexPath?
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3

    
    
    var show_Id = ""
    var fromCategories = Bool()
    var ShowData = [ShowDetailsModel]()
    var metadataItem : VideoModel!
    var metadataModel : VideoModel!
    var categoryListArray = [categoriesModel]()
    var languagesList = [languagesModel]()
    var showVideoList = [VideoModel]()
    var categoryList = [VideoModel]()
    fileprivate let cellOffset: CGFloat = 120
    var videoItem: VideoModel?
    var myMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        
       
        // Register metadata TableView
        let nibMetadata =  UINib(nibName: "DemandTableViewCell", bundle: nil)
        metaDataTableView.register(nibMetadata, forCellReuseIdentifier: "DemandTableCell")
        self.metaDataTableView.delegate = self
        self.metaDataTableView.dataSource = self
        self.metaDataTableView.sectionFooterHeight = 0
        // Register Schedule TableView
        let nibSchedule =  UINib(nibName: "VideoDetailsScheduleTableViewCell", bundle: nil)
        scheduleTableView.register(nibSchedule, forCellReuseIdentifier: "VideoScheduleTableCell")
        self.scheduleTableView.delegate = self
        self.scheduleTableView.dataSource = self
        
        
        // Register Rerun TableView
        let nibRerun =  UINib(nibName: "VideoDetailsScheduleTableViewCell", bundle: nil)
        rerunTableView.register(nibRerun, forCellReuseIdentifier: "VideoScheduleTableCell")
        self.rerunTableView.delegate = self
        self.rerunTableView.dataSource = self
       
        videoListingCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
       let flowlayout = UICollectionViewFlowLayout()
        videoListingCollectionView.dataSource = self
        videoListingCollectionView.delegate = self
        videoListingCollectionView.collectionViewLayout = flowlayout
        
        
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        self.getShowData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]
        }
        else{
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]

        }
        lastFocusedIndexPath = IndexPath(row: 2, section: 0)

        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        lastFocusedIndexPath = IndexPath(row: 2, section: 0)

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
        self.setNeedsFocusUpdate()
    }
    
    override weak var preferredFocusedView: UIView? {
        return menuCollectionView
      
    }
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [menuCollectionView]
    }
    let scale = 1.0

   
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
    
   
    
    @IBAction func seasonButtonAction(_ sender: Any) {
        let seasonName = self.ShowData[0].show_name
        var dataSource = ["\(seasonName ?? "")"]
//           dataSource.insert("Some big item", at: 1)
//           dataSource.insert("Some other big item", at: 4)

           presentPicker(
             title: "RevelationTV",
             subtitle: "Seasons",
             dataSource: dataSource,
             initialSelection: 0,
             onSelectItem: { item, index in
               print("\(item) selected at index \(index)")
             })
        
    }
    
    func getShowData() {
        //Categories.removeAll()
        commonClass.startActivityIndicator(onViewController: self)
        if self.show_Id != "" {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["show-id"] = show_Id
            ApiCommonClass.getvideoAccordingToShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                commonClass.stopActivityIndicator(onViewController: self)

                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "No data found")
                        
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
                                self.videoListingCollectionView.reloadData()
                                
                            }
                            if let scheduleArrayValue = self.ShowData[0].schedule, let rerunArrayValue = self.ShowData[0].rerun{
                                self.scheduleArray = scheduleArrayValue
                                self.rerunArray = rerunArrayValue
                                if self.rerunArray.count > 0{
                                    DispatchQueue.main.async {
                                        self.scheduleTableView.reloadData()
                                        self.rerunTableView.reloadData()
                                        self.scheduleView.isHidden = false
                                        self.rerunView.isHidden = false
                                        self.ScheduleHeaderLabel.isHidden = false
                                        self.ScheduleSepearatorView.isHidden = false
                                        let rerunArrayCount =  self.rerunArray.count
                                        let scheduleArrayCount =  self.scheduleArray.count

                                        if rerunArrayCount >  scheduleArrayCount{
                                            let headerHeight = 60 * 2
                                            self.rerunViewHeight.constant = CGFloat(rerunArrayCount*40)  + CGFloat(headerHeight)
                                            self.scheduleViewHeight.constant = CGFloat(rerunArrayCount*40)  + CGFloat(headerHeight)
                                            print(" self.rerunViewHeight.constant", self.rerunViewHeight.constant)
                                        }
                                        else{
                                            let headerHeight = 60 * 2
                                            self.rerunViewHeight.constant = CGFloat(scheduleArrayCount*40)  + CGFloat(headerHeight)
                                            self.scheduleViewHeight.constant = CGFloat(scheduleArrayCount*40)  + CGFloat(headerHeight)
                                            print(" self.rerunViewHeight.constant", self.rerunViewHeight.constant)
                                        }
                                    }
                                }
                                else{
                                    self.scheduleViewHeight.constant = 0
                                    self.rerunViewHeight.constant = 0
                                    self.ScheduleHeaderLabel.isHidden = true
                                    self.ScheduleSepearatorView.isHidden = true
                                    self.seasonButtonHeight.constant = 0
                                    self.scheduleHeaderlabelHeight.constant = 0

                                     
                                }
                               
                            }
                            else{
                                self.scheduleViewHeight.constant = 0
                                self.rerunViewHeight.constant = 0
                                self.ScheduleHeaderLabel.isHidden = true
                                self.ScheduleSepearatorView.isHidden = true
                                self.seasonButtonHeight.constant = 0
                                self.scheduleHeaderlabelHeight.constant = 0

                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    var watchVideo = false
    var watchFlagModel = [LikeWatchListModel]()
    func updateUI(){
      
      
        var spaceHeight = CGFloat()
        let width = (videoListingCollectionView.bounds.width)/4
        let height = (((width-30) * 9)/16) + 30
   
        if  showVideoList[0].videos?.count == 1 ||  showVideoList[0].videos?.count == 4{
            spaceHeight = 40
            videoListingCollectionViewHeight.constant = height + spaceHeight
        }
        else if  (showVideoList[0].videos!.count%4) == 0{
            spaceHeight = CGFloat(((showVideoList[0].videos!.count / 4)) * 40)
            videoListingCollectionViewHeight.constant = (CGFloat(showVideoList[0].videos!.count / 4 ) * height) + spaceHeight
        }
        else{
            spaceHeight = CGFloat(((showVideoList[0].videos!.count / 4) + 1) * 40)
            videoListingCollectionViewHeight.constant = (CGFloat((showVideoList[0].videos!.count / 4) + 1) * height) + spaceHeight
        }
        self.videoListingCollectionView.isHidden = false
        self.seasonButton.isHidden = true
        self.episodeHeaderLabel.isHidden = false
        let outerViewWidthNew = UIScreen.main.bounds.width - 400
        let outerViewHeightNew = (outerViewWidthNew * 3) / 8
        self.metaDataTableViewHeight.constant =  outerViewHeightNew + 180
        self.mainViewHeight.constant = metaDataTableViewHeight.constant + videoListingCollectionViewHeight.constant + scheduleViewHeight.constant + 100 + 200 + 100
        DispatchQueue.main.async {
            self.metaDataTableView.reloadData()

        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self.seasonButton.isFocused{
            seasonButton.backgroundColor = ThemeManager.currentTheme().focusedColor
        }
       
        else{
            seasonButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor

        }
        if accountButton.isFocused {
           self.accountButton.transform = CGAffineTransformMakeScale(scale, scale)
           self.accountOuterView.layer.borderWidth = 3
           self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
           self.accountButton.layer.cornerRadius = 35
           self.accountButton.layer.masksToBounds = true
            self.searchButton.tintColor = .white
       }
        else if searchButton.isFocused {
            self.searchButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            self.searchButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
        }
        else{
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            self.searchButton.tintColor = .white
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
extension ShowDetailsViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoListingCollectionView{
            if self.showVideoList.count > 0{
                return self.showVideoList[0].videos!.count

            }
            return 0
        }
        return menuArray.count
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
//    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
//        if collectionView == menuCollectionView{
//            if let previouslyFocusedIndexPath = context.previouslyFocusedIndexPath, let cell = collectionView.cellForItem(at: previouslyFocusedIndexPath) {
//                let collectionViewWidth = menuCollectionView.frame.width
//                let cellWidth = cell.frame.width
//                let rowCount = Int(ceil(collectionViewWidth / cellWidth))
//                let remender = previouslyFocusedIndexPath.row % rowCount
//                let nextIndex = previouslyFocusedIndexPath.row - remender + rowCount
//                if let nextFocusedInndexPath = context.nextFocusedIndexPath {
//                    if context.focusHeading == .down {
//                        moveFocus(to: IndexPath(row: nextIndex, section: 0))
//                        return true
//                    }
//                }
//            }
//            return true
//        }
//        return true
//    }

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
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if collectionView == videoListingCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = videoListingCollectionView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                
            }
            if let indexPath = context.nextFocusedIndexPath,
               let cell = videoListingCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.layer.borderColor = ThemeManager.currentTheme().viewBackgroundColor.cgColor
                
            }
        }
        
        
        if collectionView == menuCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = menuCollectionView.cellForItem(at: previousIndexPath) {
                print(" menu previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                if context.focusHeading == .up {
                    print("up  menu clicked")
//                    selectCollectionView = true
                    
                    self.setNeedsFocusUpdate()
                    self.updateFocusIfNeeded()
                }
                if context.focusHeading == .down {
//                    selectCollectionView = false
                   print("down menu  clicked")
                }
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = menuCollectionView.cellForItem(at: indexPath) {
                print(" menu nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.layer.borderColor = ThemeManager.currentTheme().viewBackgroundColor.cgColor
               
                
            }
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView{
            if menuArray[indexPath.item] == "Home"{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                self.present(videoDetailView, animated: false, completion: nil)
            }
//            else if menuArray[indexPath.item] == "Live"{
//                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveTabVC") as! LiveTabViewController
//
//                self.present(videoDetailView, animated: false, completion: nil)
//            }
            else if menuArray[indexPath.item] == "Watch Live"{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CatchupVC") as! CatchupViewController
               
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
        }else{
            if let videoId = showVideoList[0].videos![indexPath.row].video_id  {
                let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
                signupPageView.selectedvideoItem = showVideoList[0].videos![indexPath.row]
                        if let premiumFlag = showVideoList[0].videos![indexPath.row].premium_flag{
                            signupPageView.premium_flag = premiumFlag
                        }
                signupPageView.episodeName = showVideoList[0].videos![indexPath.row].video_title!
                self.present(signupPageView, animated: true, completion: nil)
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            if indexPath.row == 0{
                cell.menuLabel.textColor = .white
            }
            else{
                cell.menuLabel.textColor = .gray
            }
            cell.menuItem = menuArray[indexPath.row]
            return cell
        }
        else{
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
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView{
            return CGSize(width: 150, height: 80)
        }else{
            let width = (videoListingCollectionView.bounds.width)/4
            let height = ((width-30) * 9)/16
            return CGSize(width: width - 30, height: height + 30);
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == menuCollectionView{
            
            return UIEdgeInsets(top: 0, left: 25, bottom:0, right:25)
        }
        
        return UIEdgeInsets(top: 20, left: 0, bottom:20, right: 0)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == menuCollectionView{
            return 50
        }
       return 30

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == menuCollectionView{
            return 50
        }
        return 30
    }
}


extension ShowDetailsViewController : PopUpDelegate{
    func handleAccountButtonAction(action: Bool) {
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
extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == metaDataTableView{
            return self.showVideoList.count
        }
        else if tableView == scheduleTableView{
            return 1
        }
        return 1
    }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if tableView == metaDataTableView{
          return 1
      }
      else if tableView == scheduleTableView{
          if scheduleArray.count>0{
              return scheduleArray.count
          }
         return 0
      }else{
          if rerunArray.count > 0{
              return rerunArray.count
          }
        return 0
      }
     
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if tableView == metaDataTableView{
          let cell = tableView.dequeueReusableCell(withIdentifier: "DemandTableCell", for: indexPath) as! DemandTableViewCell
          cell.selectionStyle = .none
          cell.layer.cornerRadius = 8
          cell.delegate = self
          cell.videoType = "ShowDetails"
          cell.showVideos = ShowData
          return cell
      }
     else if tableView == scheduleTableView{
          let cell = tableView.dequeueReusableCell(withIdentifier: "VideoScheduleTableCell", for: indexPath) as! VideoDetailsScheduleTableViewCell
          if scheduleArray.count > 0{
              cell.scheduleListArray = scheduleArray[indexPath.row]
          }
          cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
          return cell
      }
      else{
          let cell = tableView.dequeueReusableCell(withIdentifier: "VideoScheduleTableCell", for: indexPath) as! VideoDetailsScheduleTableViewCell
          if rerunArray.count > 0{
              cell.scheduleListArray = rerunArray[indexPath.row]
          }
          cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
          return cell
      }
      
  }
    
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if tableView == metaDataTableView{
              let outerViewWidthNew = UIScreen.main.bounds.width - 400
              let outerViewHeightNew = (outerViewWidthNew * 3) / 8
              self.metaDataTableViewHeight.constant =  outerViewHeightNew + 130
              return  outerViewHeightNew + 130
        
      }
     else  if tableView == scheduleTableView{
          if scheduleArray.count > 0{
              return  40
          }
          return 0
      }else{
          if rerunArray.count > 0 {
              return  40
          }
          return 0
      }
      
  }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 0
     
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
        // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = ThemeManager.currentTheme().backgroundColor
         let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        if tableView == scheduleTableView{
            label.text = "New Episodes"

        }
        else{
            label.text = "Rerun"

        }
        label.textColor = ThemeManager.currentTheme().headerTextColor
        label.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 30)
         headerView.addSubview(label)
        return headerView
    }
    
}
extension ShowDetailsViewController:DemandTableViewCellDelegate{
    func didSelectWatchlist(passModel: VideoModel?) {
        
    }
    
    func didSelectPlayIcon(passModel: VideoModel?) {
        if let videoId = showVideoList[0].videos![0].video_id  {
            let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "videoPlayer") as! videoPlayingVC
            signupPageView.selectedvideoItem = showVideoList[0].videos![0]
                    if let premiumFlag = showVideoList[0].videos![0].premium_flag{
                        signupPageView.premium_flag = premiumFlag
                    }
            signupPageView.episodeName = showVideoList[0].videos![0].video_title!
            self.present(signupPageView, animated: true, completion: nil)
            
        }
        
    }
    
    func didSelectMoreInfo(passModel: VideoModel?) {
        
    }
    
    
}
