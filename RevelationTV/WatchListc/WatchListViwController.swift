
//
//  DemandViewController.swift
//  KICCTV
//
//  Created by GIZMEON on 08/11/22.
//  Copyright © 2022 Sinitha sidharthan. All rights reserved.
//

import UIKit
import SDWebImage
import ParallaxView
import Reachability

class WatchListViewController: UIViewController {
    @IBOutlet weak var watchlistTableView: UITableView!
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

    let reachability = try! Reachability()
    var dianamicVideos = [showByCategoryModel]()
    var menuArray = ["Watch Live","Home","On-Demand","Schedule"]
    var lastFocusedIndexPath: IndexPath?
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibVideoList =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        watchlistTableView.register(nibVideoList, forCellReuseIdentifier: "HomeTableCell")
        let nibSchedule =  UINib(nibName: "ReminderListingTableViewCell", bundle: nil)
        watchlistTableView.register(nibSchedule, forCellReuseIdentifier: "ReminderTableCell")
        
      
        watchlistTableView.register(UINib(nibName:"CustomHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: CustomHeader.reuseIdentifier)
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        watchlistTableView.contentInsetAdjustmentBehavior = .never
        watchlistTableView.sectionFooterHeight = 0
        watchlistTableView.separatorInset = .zero
        watchlistTableView.sectionHeaderHeight = 0
        watchlistTableView.contentInset = .zero
        
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")
            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
     

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWatchListVideos()
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]
        }
        else{
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]

        }
        lastFocusedIndexPath = IndexPath(row: 1, section: 0)

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
        else if searchButton.isFocused{
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
    
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [menuCollectionView]
    }
    func getWatchListVideos() {
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getWatchList { (responseDictionary: Dictionary) in
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
                        self.watchlistTableView.isHidden = true
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.watchlistTableView.isHidden = false
                        self.watchlistTableView.reloadData()
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

extension WatchListViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
    func cellSelected() {
        print("called")
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if dianamicVideos.count > 0{
            return  dianamicVideos.count
        }
       return 0
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if dianamicVideos.count > 0{
//            return  dianamicVideos.count
//        }
//       return 0
        if section == 1 {
            print("section 1",dianamicVideos[section].data!.count)
            return dianamicVideos[section].data!.count
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dianamicVideos[indexPath.section].type == "REMINDERS" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableCell", for: indexPath) as! ReminderListingTableViewCell
            //            tableView.tableFooterView = UIView(frame: CGRectZero)
//            let width = UIScreen.main.bounds.width / 4
//            let height = (width * 9)/16
//            tableView.rowHeight = height + 60
            cell.scheduleVideos = dianamicVideos[indexPath.section].data
            cell.scheduleItem = cell.scheduleVideos?[indexPath.row]
            cell.delegate = self
            cell.contentView.backgroundColor =
                ThemeManager.currentTheme().buttonColorDark
//            cell.footer

            cell.selectionStyle = .none
            cell.layer.cornerRadius = 8
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.contentView.backgroundColor = ThemeManager.currentTheme().buttonColorDark

            cell.videoType = "Dianamic"
            let data = dianamicVideos[indexPath.section].data
            cell.TitleLabel.text = "Favourites"
            cell.moreIconButton.isHidden = true
            cell.TitleLabel.font = UIFont(name: "ITCAvantGardePro-Bk", size: 30)
            cell.iconImage.image = UIImage(named: "favouritesIcon")
            cell.iconImageWidth.constant = 30
            cell.iconImageHeight.constant = 30
            cell.iconImage.image = cell.iconImage.image?.withRenderingMode(.alwaysTemplate)
            cell.iconImage.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            let screenSize: CGRect = UIScreen.main.bounds
            cell.iconImage.frame = CGRect(x: 0, y: 0, width: 30, height: 29)
            cell.videoArray = data
            return cell
        }

    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dianamicVideos[indexPath.section].type == "REMINDERS" {
            let width = UIScreen.main.bounds.width / 4
            let height = (width * 9)/16
            return height + 65
            
        }
        let width =  UIScreen.main.bounds.width / 4.5
        let height = (9 * width) / 16 + 35
        
      return height + 90
//      return rowHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dianamicVideos[section].type == "REMINDERS" {
          return 60
        }
        return 0
    }

    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if dianamicVideos[section].type == "REMINDERS" {
//          return 10
//        }
//        return 10
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader") as! CustomHeader
        headerView.contentView.backgroundColor = .red

        if dianamicVideos[section].type == "REMINDERS" {
            headerView.contentView.backgroundColor =
            ThemeManager.currentTheme().buttonColorDark

            headerView.customLabel.text =  "Show Library"
            headerView.customLabel.font = UIFont(name: "ITCAvantGardePro-Bk", size: 30)
            headerView.customLabel.isHidden = false
            headerView.moreButton.isHidden = true
            headerView.dividerView.isHidden = false
        }
        else{
            headerView.customLabel.isHidden = true
//            headerView.customLabel.text =  dianamicVideos[section].key
            headerView.moreButton.isHidden = true
            headerView.dividerView.isHidden = true
        }


        return headerView
    }

}
extension WatchListViewController: HomeTableViewCellDelegate  {
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
//                    navigationController?.pushViewController(showsOverlayView, animated: true)
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
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
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
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
                let id = Int(passModel.show_id!)
                videoDetailView.show_Id = String(id)
    //                videoDetailView.fromCategories = false
                self.present(videoDetailView, animated: true, completion: nil)
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


extension WatchListViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
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
        if indexPath.row == 1{
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


extension WatchListViewController:DemandTableViewCellDelegate{
    func didSelectMoreInfo(passModel: VideoModel?) {
        
    }
    
    func didSelectWatchlist(passModel: VideoModel?) {
        print("added to watchlist")
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
extension WatchListViewController : ReminderListingTableViewCellDelegate{
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
        self.getWatchListVideos()
    }
    
    func didSelectEarlierShows() {
        
    }
    
    
}
extension WatchListViewController : PopUpDelegate{
    func handleAccountButtonAction(action: Bool) {
//        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
//        self.present(videoDetailView, animated: false, completion: nil)
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
