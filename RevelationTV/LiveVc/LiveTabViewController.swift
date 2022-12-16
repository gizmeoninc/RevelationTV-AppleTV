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
    let reachability = try! Reachability()
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    var dianamicVideos = [showByCategoryModel]()
    var scheduleVideos = [VideoModel]()
    var liveVideos = [VideoModel]()
    var menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]
    var lastFocusedIndexPath: IndexPath?

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
        liveTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        liveTableView.contentInsetAdjustmentBehavior = .never
       
        
       
        self.getLiveChannel()
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
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Home","Live","On-Demand","Catch-up","Search"]
        }
        else{
            self.menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]

        }
        lastFocusedIndexPath = IndexPath(row: 1, section: 0)

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
            self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            self.accountButton.layer.cornerRadius = 35
            self.accountButton.layer.masksToBounds = true
        }
        else{
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
            
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

//                        self.getLiveGuide()
                    }
                }
            } else {
                self.liveVideos.removeAll()
                if let videos = responseDictionary["data"] as? [VideoModel]? {
                    self.liveVideos = videos!
                    if self.liveVideos.count == 0 {
                    }else{
                        
                    }
                }
                self.getLiveGuide()
            }
        }
    }
    
    func getLiveGuide() {
        print("getLiveGuide")
        ApiCommonClass.getLiveGuide { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.liveTableView.isHidden = true
                        commonClass.stopActivityIndicator(onViewController: self)


                    }
                }
            } else {
                self.scheduleVideos.removeAll()
                if let videos = responseDictionary["data"] as? [VideoModel]? {
                    self.scheduleVideos = videos!
                    if self.scheduleVideos.count == 0 {
                        self.liveTableView.isHidden = true
                        commonClass.stopActivityIndicator(onViewController: self)


                    }else{
                        DispatchQueue.main.async {
                            self.liveTableView.isHidden = false
                            self.liveTableView.reloadData()
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
        if indexPath.section == 0{
            return true
        }
        return false
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return  2
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if liveVideos.count > 0{
            return 1
        }else if scheduleVideos.count > 0{
            return 1
        }
        else{
            return 0
        }
            
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveTableCell", for: indexPath) as! LiveTableViewCell
            cell.selectionStyle = .none
            if liveVideos.count > 0{
                cell.scheduleVideos = self.liveVideos

            }
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableCell", for: indexPath) as! ScheduleListTableViewCell
            cell.channelType = "LiveSchedule"
            
            cell.delegate = self
            if scheduleVideos.count > 0{
                cell.scheduleVideos = self.scheduleVideos
            }
            cell.backgroundColor = .clear
            return cell
        }
        
       
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if indexPath.section == 0{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveVC") as! LivePlayingViewController
                videoDetailView.channelVideo = self.liveVideos[indexPath.row]
                self.present(videoDetailView, animated: true, completion: nil)
            
        }
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            let width = UIScreen.main.bounds.width
            let widthNew = width - (width/3)
            let height = (widthNew*9)/16
            return height + 30
        }
        else {
            let widthnew =  (UIScreen.main.bounds.width/3)
            let height = ((widthnew)*9)/16
            return height + 420
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = ThemeManager.currentTheme().headerTextColor
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 40)
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height:60).integral
        if section == 0  {
            titleLabel.text =  "RevelationTV Live"
        }
        else  {
            titleLabel.text =  "Coming Up"
        }
       
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = .clear
        return headerView
    }
  
}
extension LiveTabViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
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
        if indexPath.row == 1{
            cell.menuLabel.textColor = .white
        }
        else{
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
//        print("reminder added")
//        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
//            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LoginRegisterVC") as! LoginRegisterViewController
//            self.present(videoDetailView, animated: false, completion: nil)
//
//        }else{
            commonClass.showAlert(viewController:self, messages: "Reminder updated")
//        }
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
