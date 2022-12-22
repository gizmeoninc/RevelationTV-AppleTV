//
//  CategoryListingViewController.swift
//  AdventureSportstvOS
//
//  Created by GIZMEON on 21/12/20.
//  Copyright © 2020 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

class CategoryListingViewController: UIViewController{
   
    @IBOutlet weak var NoResultView: UIView!
    
    var channelVideos = [VideoModel]()
    var Categories = [VideoModel]()
    var delegate : categoryListingDelegate!
    var categoryID = String()
    var categoryName = String()
    var categoryType = String()
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var gardientview: UIView!
    
    
    @IBOutlet weak var headerTitleLabel: UILabel!{
        didSet{
            headerTitleLabel.textColor = ThemeManager.currentTheme().headerTextColor
            headerTitleLabel.font = UIFont(name: ThemeManager.currentTheme().fontDefault, size: 28)
            headerTitleLabel.textAlignment = .left
//            headerTitleLabel.
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
    
    
    
    
    
    
    var menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]
    var lastFocusedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        let flowlayout = UICollectionViewFlowLayout()
        self.NoResultView.isHidden = true
        categoriesCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.collectionViewLayout = flowlayout
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        let gradientLayer1:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.categoriesCollectionView.frame.size
        gradientLayer.colors =
            [UIColor.black.cgColor,UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)

        self.gardientview.layer.addSublayer(gradientLayer)
        categoriesCollectionView.backgroundView = self.gardientview
        
      
        NoResultView.backgroundColor = .black
        if self.categoryID != ""{
            self.headerTitleLabel.text = categoryName
            getCategoryVideos(categoryId: self.categoryID)
        }
        getFeaturedShows()
        
        // Do any additional setup after loading the view.
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Home","Live","On-Demand","Catch-up","Search"]
        }
        else{
            self.menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]

        }
        lastFocusedIndexPath = IndexPath(row: 2, section: 0)

        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
       

    }
    func getCategoryVideos1(){
        print("delegate called")
    }
    func getCategoryVideos(categoryId: String) {
        commonClass.startActivityIndicator(onViewController: self)

        Categories.removeAll()
             var parameterDict: [String: String?] = [ : ]
       
               parameterDict["key"] = String(categoryId)
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "apple-tv"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
       
             ApiCommonClass.getvideoByCategory(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
               if responseDictionary["error"] != nil {
                 DispatchQueue.main.async {
                    self.NoResultView.isHidden = false
                    commonClass.stopActivityIndicator(onViewController: self)
                 }
               } else {
                 self.Categories = responseDictionary["data"] as! [VideoModel]
                 if self.Categories.count == 0 {
                   DispatchQueue.main.async {
                    self.NoResultView.isHidden = false
                    self.categoriesCollectionView.isHidden = true
                    self.categoriesCollectionView.reloadData()
                    commonClass.stopActivityIndicator(onViewController: self)

                   }
                 } else {
                   DispatchQueue.main.async {
                    print("categoryListApi call")
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.NoResultView.isHidden = true

                    self.categoriesCollectionView.isHidden = false

                     self.categoriesCollectionView.reloadData()
                   }
                 }
               }
             }
           }
    func getFeaturedShows() {
        commonClass.startActivityIndicator(onViewController: self)

        Categories.removeAll()
             var parameterDict: [String: String?] = [ : ]
//               parameterDict["key"] = String(categoryId)
        parameterDict["user_id"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "apple-tv"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
       
             ApiCommonClass.getFeaturedShowsList(parameterDictionary: parameterDict as? Dictionary<String, String>){ (responseDictionary: Dictionary) in
               if responseDictionary["error"] != nil {
                 DispatchQueue.main.async {
                    self.NoResultView.isHidden = false
                    commonClass.stopActivityIndicator(onViewController: self)
                 }
               } else {
                 self.Categories = responseDictionary["data"] as! [VideoModel]
                 if self.Categories.count == 0 {
                   DispatchQueue.main.async {
                    self.NoResultView.isHidden = false
                    self.categoriesCollectionView.isHidden = true
                    self.categoriesCollectionView.reloadData()
                    commonClass.stopActivityIndicator(onViewController: self)

                   }
                 } else {
                   DispatchQueue.main.async {
                    print("featuredShowsListApi call")
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.NoResultView.isHidden = true

                    self.categoriesCollectionView.isHidden = false

                     self.categoriesCollectionView.reloadData()
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
extension CategoryListingViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView{
            return menuArray.count
        }
        return Categories.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView{
            return CGSize(width: 150, height: 80)
        }
        let width = (categoriesCollectionView.bounds.width)/4
        let height = ((width-30) * 9)/16
        return CGSize(width: width - 30, height: height + 30);
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCollectionCell", for: indexPath as IndexPath) as! MenuCollectionViewCell
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        if indexPath.row == 2{
            cell.menuLabel.textColor = .white
        }
        else{
            cell.menuLabel.textColor = .gray
        }
            cell.menuItem = menuArray[indexPath.row]
            return cell
        }
        
        let cell: SearchCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionCell
        cell.backgroundColor = .clear
        cell.imageView.layer.masksToBounds = true
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.cornerRadius = 8
        if Categories[indexPath.row].show_name != nil{
            cell.videoNameLabel.text = Categories[indexPath.row].show_name
            cell.videoNameLabel.textAlignment = .left
            cell.videoNameLabel.numberOfLines = 1
        }
        else{
            cell.videoNameLabel.text = " "
        }
        if categoryType == "Featured"{
            if Categories[indexPath.row].logo_thumb != nil{
                cell.imageView.sd_setImage(with: URL(string: Categories[indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "landscape_placeholder"))
//                cell.imageView.sd_setImage(with: URL(string: showUrl + Categories[indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "landscape_placeholder"))
                print("img featuredshows url",showUrl + Categories[indexPath.row].logo_thumb!)
            }
            else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }
        }
        else{
            if Categories[indexPath.row].logo != nil{
                cell.imageView.sd_setImage(with: URL(string: showUrl + Categories[indexPath.row].logo_thumb!),placeholderImage:UIImage(named: "landscape_placeholder"))
            }
            else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }
        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath as IndexPath) as! PopularCollectionViewCell
//        cell.backgroundColor = .red
//               if Categories[indexPath.row].logo_thumb != nil {
//            cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + Categories[indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
//        }
//        cell.layer.cornerRadius = 8
//        cell.layer.masksToBounds = true
        return cell
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
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
            let id = Int(Categories[indexPath.item].show_id!)
            videoDetailView.show_Id = String(id)
//                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
            
            
        }
//        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
//        videoDetailView.videoItem = Categories[indexPath.item]
//            videoDetailView.fromCategories = false
//        self.present(videoDetailView, animated: true, completion: nil)
    }
}
extension CategoryListingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == menuCollectionView{
            return UIEdgeInsets(top: 0, left: 25, bottom:0, right:25)
        }
        return UIEdgeInsets(top: 20, left: 0, bottom:20, right: 0)
    }

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

extension CategoryListingViewController : PopUpDelegate{
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
