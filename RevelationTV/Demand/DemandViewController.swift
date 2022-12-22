//
//  DemandViewController.swift
//  KICCTV
//
//  Created by GIZMEON on 08/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability

class DemandViewController: UIViewController, DemandShowsListingTableCellDelegate {
    func didSelectDemandShows(passModel: VideoModel) {
    }
//    func didSelectDianamicVideos(passModel :VideoModel?){
//
//    }
    @IBOutlet weak var demandTableView: UITableView!
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
        }
    }
    @IBOutlet weak var dropDownArrowACcount: UIImageView!{
        didSet{
            dropDownArrowACcount.setImageColor(color: ThemeManager.currentTheme().headerTextColor)
        }
    }
    
    
    @IBOutlet weak var demandListingTableViewHeight: NSLayoutConstraint!
    
    let reachability = try! Reachability()
    var dianamicVideos = [showByCategoryModel]()
    var menuArray = [String]()
    var lastFocusedIndexPath: IndexPath?
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    var maincollectionviewheight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibVideoList =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        demandTableView.register(nibVideoList, forCellReuseIdentifier: "HomeTableCell")
        let nibDemandShowsListingTableCell = UINib(nibName: "DemandShowsListingTableViewCell", bundle: nil)
        demandTableView.register(nibDemandShowsListingTableCell, forCellReuseIdentifier: "DemandShowsListingTableCell")
        let nib2 =  UINib(nibName: "CommonTableViewCell", bundle: nil)
        demandTableView.register(nib2, forCellReuseIdentifier: "mainTableViewCell")
        let nibFeaturedBanner =  UINib(nibName: "DemandTableViewCell", bundle: nil)
        demandTableView.register(nibFeaturedBanner, forCellReuseIdentifier: "DemandTableCell")
        demandTableView.register(UINib(nibName:"CustomHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: CustomHeader.reuseIdentifier)

        demandTableView.delegate = self
        demandTableView.dataSource = self
        demandTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        demandTableView.contentInsetAdjustmentBehavior = .never
     
        
        
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        getDianamicHomeVideos()
     

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

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
    let scale = 1.0
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if accountButton.isFocused {
            self.accountButton.transform = CGAffineTransformMakeScale(scale, scale)
            self.accountOuterView.layer.borderWidth = 3
            self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            self.accountButton.layer.cornerRadius = 35
            self.accountButton.layer.masksToBounds = true
            self.searchButton.tintColor = .white
        }
        if searchButton.isFocused{
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
    func getDianamicHomeVideos() {
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.GetonDemandVideos { (responseDictionary: Dictionary) in
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
                        self.demandTableView.isHidden = true
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.demandTableView.isHidden = false
                        self.demandTableView.reloadData()
                        commonClass.stopActivityIndicator(onViewController: self)
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

extension DemandViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
    func cellSelected() {
        print("called")
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  dianamicVideos.count
    }
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        if context.nextFocusedView == moreButton {
////            moreButton.backgroundColor = .red
//             print("My button is about to be focused")
//        }
//        else {
////            moreButton.backgroundColor = .white
//
//             print("My button is NOT in focus")
//       }
//    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if dianamicVideos[indexPath.section].type == "ON-DEMAND_BANNERS" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemandTableCell", for: indexPath) as! DemandTableViewCell
//            cell.channelType = "Featured"
            cell.featuredVideos = dianamicVideos[indexPath.section].shows
            cell.delegate = self
//            cell.backgroundColor = .green
            cell.selectionStyle = .none
            cell.layer.cornerRadius = 8
//            demandListingTableViewHeight.constant = 700
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemandShowsListingTableCell", for: indexPath) as! DemandShowsListingTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
//            cell.videoType = "Dianamic"
            let data = dianamicVideos[indexPath.section].shows
            let width = UIScreen.main.bounds.width / 4.5
            let height = width * 9 / 16 + 10
//            cell.dataArray = dianamicVideos[indexPath.section].shows
//            if data!.count < 8 {
            print("data count",data!.count)
                cell.showMoreButton.isHidden = true
                cell.videoArray = dianamicVideos[indexPath.section].shows
                demandListingTableViewHeight.constant = height * CGFloat(data!.count/4)
//            }
//            else{
//                cell.videoArray = Array(dianamicVideos[indexPath.section].shows![0...7])
//                cell.showMoreButton.isHidden = false
//                demandListingTableViewHeight.constant = height * 2
//            }

//            demandListingTableViewHeight.constant = cell.mainCollectionViewHeight.constant * CGFloat(Int(cell.videoArray!.count/4))
            return cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableViewCell
//            cell.selectionStyle = .none
//            cell.delegate = self
//            cell.backgroundColor = .clear
//            cell.videoType = "Dianamic"
//            let data = dianamicVideos[indexPath.section].shows
//            cell.videoArray = dianamicVideos[indexPath.section].shows
//            return cell
        }

    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dianamicVideos[indexPath.section].type == "ON-DEMAND_BANNERS" {
            let width = UIScreen.main.bounds.width - 100
            let height = (width * 3 / 8)
            return height + 120
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DemandShowsListingTableCell")
            as! DemandShowsListingTableViewCell
            let data = dianamicVideos[indexPath.section].shows
            var spaceHeight = CGFloat()
            let width = (cell.mainCollectionView.bounds.width)/4
            let height = (((width-30) * 9)/16) + 30
            if data!.count == 1 || data!.count == 4 {
                spaceHeight = 40
                self.maincollectionviewheight = height + spaceHeight
            }
            else if (data!.count%4) == 0{
                spaceHeight = CGFloat(((data!.count / 4)) * 40)
                self.maincollectionviewheight = CGFloat(data!.count / 4 ) * height + spaceHeight
            }
            else{
                spaceHeight = CGFloat(((data!.count / 4) + 1) * 40)
                self.maincollectionviewheight = CGFloat((data!.count / 4) + 1) * height + spaceHeight
            }
//            cell.videoArray = dianamicVideos[indexPath.section].shows
            

//            let width = UIScreen.main.bounds.width / 4
//            let height = width * 9 / 16
//            let demandListTableHeight = height * CGFloat(dianamicVideos[indexPath.section].shows!.count/4)
            let demandListTableHeight = self.maincollectionviewheight + 50
            return demandListTableHeight
        }
//      return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dianamicVideos[section].type == "ON-DEMAND_BANNERS" {

          return 0
            
        }
        return 0
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! CustomHeader
//
//        if dianamicVideos[section].type == "ON-DEMAND_BANNERS" {
////            headerView.customLabel.text =  "RevelationTV On Demand"
//            headerView.moreButton.isHidden = true
//        }
//        else if dianamicVideos[section].type == "CATEGORY_SHOWS" {
//            headerView.customLabel.text =  dianamicVideos[section].category_name
//            headerView.moreButton.isHidden = false
//        }
//        else if dianamicVideos[section].type == "CONTINUE_WATCHING" {
//            headerView.customLabel.text =  "Resume Watching"
//            headerView.moreButton.isHidden = false
//        }
//        else if dianamicVideos[section].type == "NEW_RELEASES" {
//            headerView.customLabel.text =  "New Episodes"
//            headerView.moreButton.isHidden = true
//        }
//        else if dianamicVideos[section].type == "SHOW" {
//            headerView.customLabel.text =  dianamicVideos[section].category_name
//            headerView.moreButton.isHidden = false
//        }
//        else{
//            headerView.customLabel.text =  dianamicVideos[section].category_name
//            headerView.moreButton.isHidden = true
//        }
//        headerView.sectionNumber = section
//        headerView.delegate = self
//
//
//        return headerView
//    }
  
}
extension DemandViewController: HomeTableViewCellDelegate  {
    func didSelectMoreIcon(_didSelectMoreIcon: HomeTableViewCell, didTapMoreIconInSection section: Int) {
        
    }
    
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
                    showsOverlayView.showFlag = true
                    showsOverlayView.show_Id = String(id)
                showsOverlayView.modalPresentationStyle = .custom
                showsOverlayView.modalTransitionStyle = .crossDissolve
                    self.present(showsOverlayView, animated: true, completion: nil)
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


extension DemandViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        if indexPath.row == 2{
            cell.menuLabel.textColor = ThemeManager.currentTheme().buttonTextColor
        }
        else{
            cell.menuLabel.textColor = .white
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
        return 75
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 75
    }
}

extension DemandViewController:DemandTableViewCellDelegate{
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
extension DemandViewController : CustomHeaderDelegate{
    func customHeader(_ customHeader: CustomHeader, didTapButtonInSection section: Int) {
         if dianamicVideos[section].type == "CATEGORY_SHOWS" {
             let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListingViewController
             let id = Int(dianamicVideos[section].category_id!)
             videoDetailView.categoryID = String(id)
             videoDetailView.categoryName = dianamicVideos[section].category_name!
             self.present(videoDetailView, animated: true, completion: nil)
        }
        else if dianamicVideos[section].type == "SHOW" {
            let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
            let id = Int((dianamicVideos[section].shows?[0].video_id!)!)
            episodeVC.video_Id = String(id)
            self.present(episodeVC, animated: true, completion: nil)
        }
        print("row column ",section)
        
    }
    
    
}
extension DemandViewController : PopUpDelegate{
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
