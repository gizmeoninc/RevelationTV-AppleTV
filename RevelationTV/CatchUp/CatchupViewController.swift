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
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3

    var catchupVideoArray = [VideoModel?]()
    var catchupFilterArray = [showByCategoryModel]()
    var menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]
    var lastFocusedIndexPath: IndexPath?
    var selectCollectionView = false
    var videoUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibVideoLIst =  UINib(nibName: "CatchupTableViewCell", bundle: nil)
        videoListingTableView.register(nibVideoLIst, forCellReuseIdentifier: "catchUpTableCell")
        videoListingTableView.delegate = self
        videoListingTableView.dataSource = self
        videoListingTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        videoListingTableView.contentInsetAdjustmentBehavior = .never
        filterCollectionView.register(UINib(nibName: "DayFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dayFilterCollectionCell")
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        
        filterCollectionViewHeight.constant = 120
        let width = UIScreen.main.bounds.width - 100
        let height = (9*width)/16 - 200
        playerViewHeight.constant = height
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        self.getCatchUpList()
        
       
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
        return playButton
//        if selectCollectionView{
//            return playButton
//        }
//        else{
//            return menuCollectionView
//        }
      
    }
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [playButton]

//        if selectCollectionView{
//            return [playButton]
//
//        }
//        else{
//            return [menuCollectionView]
//        }
    }
    func getCatchUpList(){
        var parameterDict: [String: String?] = [ : ]
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getCactchUpList { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    self.videoListingTableView.isHidden = true
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController:self, messages: "Oops! something went wrong \n please try later")
                    self.mainView.isHidden = false
                }
            } else {
                self.catchupFilterArray.removeAll()
                if let data = responseDictionary["data"] as? [showByCategoryModel]{
                    if data.count == 0{
                        DispatchQueue.main.async {
                            commonClass.showAlert(viewController:self, messages: "No Result Found")
                            self.videoListingTableView.isHidden = true
                            commonClass.stopActivityIndicator(onViewController: self)
                            self.mainView.isHidden = false
                        }
                    }
                    else{
                        
                        self.catchupFilterArray.append(contentsOf: data)
                        if data[0].data?.count != 0{
                            self.catchupVideoArray.append(contentsOf: data[0].data!)
                            if let video = self.catchupVideoArray[0]{
                                
                                                           }
                            DispatchQueue.main.async {
                                let width = (UIScreen.main.bounds.width) - 30//some width
                                let height =   (self.catchupVideoArray.count * ((9 * Int(width)) / 16)) + 140
                                let spaceHeight = (self.catchupVideoArray.count * 25)
                                self.videoListingTableViewHeight.constant = CGFloat(height) + CGFloat(spaceHeight)
                             
                               self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                                self.videoListingTableView.reloadData()
                                self.filterCollectionView.reloadData()
                                commonClass.stopActivityIndicator(onViewController: self)
                                self.videoListingTableView.isHidden = false
                                self.videoUrl = (self.catchupVideoArray[0]?.url)!

                            }
                            self.mainView.isHidden = false
                        }
                        else{
                            DispatchQueue.main.async {
                                
                                self.videoListingTableViewHeight.constant = 0
                             
                               self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + self.playerViewHeight.constant
                                self.videoListingTableView.reloadData()
                                self.filterCollectionView.reloadData()
                                commonClass.stopActivityIndicator(onViewController: self)
                                self.videoListingTableView.isHidden = false
                            }
                            self.mainView.isHidden = false
                        }
                       
                     
                        
                    }
                    
                }
                else{
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "No Result Found")
                        commonClass.stopActivityIndicator(onViewController: self)
                        self.videoListingTableView.isHidden = true
                        self.mainView.isHidden = false
                       
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
        if catchupVideoArray.count > 0{
            return catchupVideoArray.count
        }
        return 0
        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "catchUpTableCell", for: indexPath) as! CatchupTableViewCell
            cell.liveGuideArray = catchupVideoArray[indexPath.section]
            cell.delegate = self
            cell.selectionStyle = .none
            cell.layer.cornerRadius = 8
            cell.remindMeButton.isHidden = true
            return cell
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
        print("hello")
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width / 3
        let height = (width * 9)/16
        return height + 130

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
            if catchupFilterArray.count > 0{
                return catchupFilterArray.count
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
                    selectCollectionView = true
                    self.setNeedsFocusUpdate()
                    self.updateFocusIfNeeded()
                }
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = filterCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.cornerRadius = 25
                cell.contentView.layer.borderColor = UIColor.white.cgColor
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
            mainScrollView.setContentOffset(videoListingTableView.frame.origin, animated: true)
//            videoListingTableView.scrollToRow(at:indexpathItem, at: .top, animated: true)
            videoListingTableView.reloadData()
             self.mainViewHeight.constant = self.videoListingTableViewHeight.constant + self.filterCollectionViewHeight.constant + playerViewHeight.constant
          
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFilterCollectionCell", for: indexPath as IndexPath) as! DayFilterCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            cell.layer.cornerRadius = 25
            cell.layer.masksToBounds = true
        cell.dayItem = catchupFilterArray[indexPath.row].key
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
            return CGSize(width: 250, height: 50)
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
