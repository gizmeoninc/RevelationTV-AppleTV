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
    @IBOutlet weak var metadataView: UIView!{
        didSet{
            metadataView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            metadataView.isHidden = true
        }
    }
    @IBOutlet weak var outerImageView: UIImageView!{
        didSet{
//            outerImageView.contentMode = .scaleToFill
        }
    }
    @IBOutlet weak var innerImageView: UIImageView!{
        didSet{
            innerImageView.contentMode = .scaleToFill
            innerImageView.layer.cornerRadius = 20
            innerImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var episodeHeaderLabel: UILabel!{
        didSet{
            episodeHeaderLabel.text = "Episodes"
            episodeHeaderLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 30)
            episodeHeaderLabel.textAlignment = .left
            episodeHeaderLabel.numberOfLines = 1
            episodeHeaderLabel.textColor = .white
            episodeHeaderLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var showNameLabel: UILabel!{
        didSet{
            showNameLabel.font =  UIFont(name: ThemeManager.currentTheme().fontBold, size: 35)

        }
    }
    @IBOutlet weak var showDescriptionLabel: UILabel!{
        didSet{
            showDescriptionLabel.font =  UIFont(name: ThemeManager.currentTheme().fontRegular, size: 25)

        }
    }
    @IBOutlet weak var watchListButton: UIButton!{
        didSet{
            watchListButton.setTitle("Add to List", for: .normal)
            watchListButton.setImage(UIImage(named: "plus-icon"), for: .normal)
            watchListButton.backgroundColor = UIColor().colorFromHexString("#010915")
            watchListButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            watchListButton.layer.borderWidth = 3.0
            watchListButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            watchListButton.layer.cornerRadius = 30
            watchListButton.titleLabel?.textAlignment = .center
            watchListButton.layer.masksToBounds = true
            watchListButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchListButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchListButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            watchListButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
    
    @IBOutlet weak var seasonButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var seasonButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var metadataViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var innerImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var innerImageViewWidth: NSLayoutConstraint!
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

    
    @IBOutlet weak var gradientView: UIView!{
        didSet{
            gradientView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    @IBOutlet weak var videoListingCollectionView: UICollectionView!{
        didSet{
            videoListingCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            videoListingCollectionView.isHidden = true
        }
    }
    
    @IBOutlet weak var videoListingCollectionViewHeight: NSLayoutConstraint!
    let reachability = try! Reachability()
    var dianamicVideos = [showByCategoryModel]()
    var menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]
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
        let width = UIScreen.main.bounds.width / 3
        let height = (width*9)/16
        self.innerImageViewWidth.constant = width
        self.innerImageViewHeight.constant = height
        self.metadataViewHeight.constant = height + 100
        self.getShowData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Home","Live","On-Demand","Catch-up","Search"]
        }
        else{
            self.menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]

        }
        lastFocusedIndexPath = IndexPath(row: 0, section: 0)

        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        lastFocusedIndexPath = IndexPath(row: 0, section: 0)

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
        self.setNeedsFocusUpdate()
    }
    
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [self.watchListButton]
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
        if self.show_Id != "" {
            var parameterDict: [String: String?] = [ : ]
            parameterDict["show-id"] = show_Id
            commonClass.startActivityIndicator(onViewController: self);
            ApiCommonClass.getvideoAccordingToShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
                if responseDictionary["error"] != nil {
                    DispatchQueue.main.async {
                        commonClass.showAlert(viewController:self, messages: "Server error")
                        
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
                            
                        }
                    }
                }
            }
        }
        
    }
    var watchVideo = false
    var watchFlagModel = [LikeWatchListModel]()
    func updateUI(){
       if self.showVideoList[0].videos![0].thumbnail_350_200 != nil{
            print("didSelectShowVideos",URL(string: imageUrl + (showVideoList[0].videos![0].thumbnail_350_200)!))
            self.outerImageView.sd_setImage(with: URL(string: imageUrl + (showVideoList[0].videos![0].thumbnail_350_200)!),placeholderImage:UIImage(named: "lightGrey"))
           self.innerImageView.sd_setImage(with: URL(string: imageUrl + (showVideoList[0].videos![0].thumbnail_350_200)!),placeholderImage:UIImage(named: "lightGrey"))
        }
        if self.ShowData[0].show_name != nil{
            self.showNameLabel.text = ShowData[0].show_name
            let text = ShowData[0].show_name
            let font =  UIFont(name: "Helvetica", size: 25)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (text! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            self.seasonButtonWidth.constant = size.width + 200
            
            let heightOfLabel = size.height + 40
            self.seasonButtonHeight.constant = heightOfLabel
            self.seasonButton.setTitle(ShowData[0].show_name, for: .normal)
        }
        if ShowData[0].synopsis != nil{
            self.showDescriptionLabel.text = ShowData[0].synopsis
        }
        
        if let watch_flag = self.ShowData[0].watchlist_flag {
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
       
        self.metadataView.isHidden = false
        self.videoListingCollectionView.isHidden = false
        self.seasonButton.isHidden = false
        self.episodeHeaderLabel.isHidden = false
        self.mainViewHeight.constant = metadataViewHeight.constant + videoListingCollectionViewHeight.constant + 200 + 100
    }
    func watchListShow() {
      var parameterDict: [String: String?] = [ : ]
      parameterDict["show-id"] = String(self.show_Id)
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
      ApiCommonClass.WatchlistShows(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
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
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.seasonButton.isFocused{
            seasonButton.backgroundColor = ThemeManager.currentTheme().focusedColor
        }
        else  if self.watchListButton.isFocused{
            watchListButton.backgroundColor = ThemeManager.currentTheme().focusedColor
        }
        else{
            seasonButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            watchListButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

        }
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
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        if collectionView == menuCollectionView{
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
        }else{
            if let videoId = showVideoList[0].videos![indexPath.row].video_id  {
                let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
                episodeVC.video_Id = String(videoId)
                self.present(episodeVC, animated: true, completion: nil)
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
        let accountVC =  self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
        self.present(accountVC, animated: false, completion: nil)
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
