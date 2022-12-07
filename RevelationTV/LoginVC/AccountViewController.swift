//
//  AccountViewController.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 22/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import TVOSPicker
import TVMultiPicker
import Reachability
class AccountViewController: UIViewController {
    
    
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
    
    var menuArray = ["Home","Live","On-Demand","Catch-up","My List","Search"]
    
    var lastFocusedIndexPath: IndexPath?

    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!{
        didSet{
            usernameLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            usernameLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            usernameLabel.text = "Username"
        }
    }
    @IBOutlet weak var userTextField: UITextField!{
        didSet{
            userTextField.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            userTextField.textColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            emailLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            emailLabel.text = "Email"
        }
    }
    
    @IBOutlet weak var genderLabel: UILabel!
    {
        didSet{
            genderLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            genderLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            genderLabel.text = "Gender"
        }
    }
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            emailTextField.textColor = ThemeManager.currentTheme().buttonColorDark
            emailTextField.backgroundColor = .lightGray
        }
    }
    @IBOutlet weak var dobLAbel: UILabel! {
        didSet{
            dobLAbel.textColor = ThemeManager.currentTheme().descriptionTextColor
            dobLAbel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            dobLAbel.text = "Dob"
        }
    }
    
   
    
    @IBOutlet weak var countryLabel: UILabel!{
        didSet{
            countryLabel.textColor = ThemeManager.currentTheme().descriptionTextColor
            countryLabel.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            
            countryLabel.text = "Country"
        }
    }
   
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
  
    @IBOutlet weak var accountSettingsHeaderLabel: UILabel!
    
    
    @IBOutlet weak var genderTextfield: UITextField!{
        didSet{
            genderTextfield.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            genderTextfield.textColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var countryTextfield: UITextField!{
        didSet{
            countryTextfield.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            countryTextfield.textColor = ThemeManager.currentTheme().buttonColorDark
        }
    }
    
    @IBOutlet weak var dobTextfield: UITextField!
    {
        didSet{
            dobTextfield.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            dobTextfield.textColor = ThemeManager.currentTheme().buttonColorDark
        }
    }

    @IBOutlet weak var saveButton: UIButton!{
        didSet{
            saveButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            saveButton.titleLabel?.font = UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
        }
    }
    var country_code: String!
    var countryCode: String!
    var dateOfBirthString : String!
    let reachability = try! Reachability()
    var countries_Array = [String]()
    var country_code_Array = [String?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        genderTextfield.delegate = self
        countryTextfield.delegate = self
        userTextField.delegate = self
        dobTextfield.delegate = self
        emailTextField.returnKeyType = .done
        userTextField.returnKeyType = .done
      getAccountDetails()
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            self.country_code_Array.append(id)
            self.countries_Array.append(name)
        }

    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: country_code)
        self.countryTextfield.text = current.localizedString(forRegionCode: countryCode)
        return current.localizedString(forRegionCode: countryCode)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        lastFocusedIndexPath = IndexPath(row: 4, section: 0)
        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
    }
    
    func getAccountDetails(){
        var channelResponse = Dictionary<String, AnyObject>()
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        ApiCommonClass.getAccountDetails(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                }
             } else{
                 DispatchQueue.main.async {
                     commonClass.stopActivityIndicator(onViewController: self)
                 }
                 let data = responseDictionary["data"] as! Dictionary<String, AnyObject>
               DispatchQueue.main.async {
                   if let data = responseDictionary["data"] as? NSDictionary  {
                       if data["dob"] == nil {
                       }
                       else {
                           if let time =  data["dob"] as? String {
                               let formatter = DateFormatter()
                               formatter.dateFormat = "MMM dd,yyyy"
                               let startTime = self.convertStringTimeToDate(item: time)
                               let timeStart = formatter.string(from: startTime)
                               self.dobTextfield.text = timeStart
                               
                               let savedFormatter = DateFormatter()
                               savedFormatter.dateFormat = "yyyy-MM-dd"
                               let startTimeSaved = self.convertStringTimeToDate(item: time)
                               self.dateOfBirthString = formatter.string(from: startTimeSaved)
                           }
                       }
                       if data["gender"] == nil{
                       }
                       else{
                           self.genderTextfield.text = data["gender"] as? String
                       }
                       if data["country_code"] == nil{
                       }
                       else{
                           self.country_code = data["country_code"] as? String
                           self.countryCode = data["country_code"] as? String
                           if self.country_code.starts(with: "_"){
                          self.country_code.remove(at: self.country_code.startIndex)
                               self.countryTextfield.text = self.countryName(from: self.country_code)
                           }
                           else{
                               self.countryTextfield.text = self.countryName(from: self.country_code)
                           }
                       }
                       self.userTextField.text = data["first_name"] as? String
                       self.emailTextField.text = data["user_email"] as? String
               }
             }
             }
        }
    }
    func setAccountDetailsChanges(){
        commonClass.startActivityIndicator(onViewController: self)
           let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted
           if (userTextField.text?.isEmpty)! {
               commonClass.showAlert(viewController:self, messages: "Enter Name.")
           }
           else if  userTextField.text?.rangeOfCharacter(from: lettersAndSpacesCharacterSet) != nil {
               commonClass.showAlert(viewController:self, messages: "Numbers and special characters are not allowed for user name.")
           }
    
           else {
               if  reachability.connection != .unavailable {
                   let UDID = UIDevice.current.identifierForVendor?.uuidString
                   let country_code = UserDefaults.standard.string(forKey:"countryCode")!
                   let accesToken = UserDefaults.standard.string(forKey:"access_token")!
                   let user_id = UserDefaults.standard.string(forKey:"user_id")!
                   let pubid = UserDefaults.standard.string(forKey:"pubid")!
                   let device_type = "apple-tv"
                   let dev_id = UserDefaults.standard.string(forKey:"UDID")!
                   let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
                   let channelid = UserDefaults.standard.string(forKey:"channelid")!
                   let userAgent = UserDefaults.standard.string(forKey:"userAgent")
                   var parameterDict: [String: String?] = [ : ]
                   guard let first_name = userTextField.text else {
                     return
                   }
                   parameterDict["first_name"] = first_name
                   if self.countryCode != nil{
                       parameterDict["country_code"] = self.countryCode
                   }
                   if self.genderTextfield.text != nil{
                       parameterDict["gender"] = self.genderTextfield.text
                   }
                   if self.dateOfBirthString != nil{
                       parameterDict["dob"] = dateOfBirthString
                   }
                   print(parameterDict)
                   let encoder = JSONEncoder()
                   encoder.outputFormatting = .prettyPrinted
                   let data = try! encoder.encode(parameterDict)
                   let versionLabel = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                   ApiCallManager.apiCallREST(mainUrl: editAccountDetails, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken,"uid":user_id,"pubid":pubid,"device_type":device_type,"ip":ipAddress,"channelid":channelid,"country_code":country_code,"dev_id":dev_id,"version":"\(versionLabel)"], postData: data){(responseDictionary: Dictionary) in
                   var channelResponse = Dictionary<String, AnyObject>()
                       print("response",responseDictionary)
                       guard let succes = responseDictionary["success"] as? Bool  else {
                         return
                       }
                     if let val = responseDictionary["error"] {
                       DispatchQueue.main.async {
                           commonClass.stopActivityIndicator(onViewController: self)
                           commonClass.showAlert(viewController:self, messages:  val as! String)
                       }
                     } else {
                         if succes == false{
                             DispatchQueue.main.async {
                                 commonClass.stopActivityIndicator(onViewController: self)
                                 commonClass.showAlert(viewController:self, messages:  "Data not saved ... Try later")

                             }
                         }
                         else if succes == true{
                       DispatchQueue.main.async {
                           commonClass.stopActivityIndicator(onViewController: self)
                           commonClass.showAlert(viewController:self, messages:  "Data updated successfully")
                           self.getAccountDetails()

                           }
                         }
                         else{
                             channelResponse["error"]=responseDictionary["message"]
                         }
                     }
                   }
               }
               else{
               AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
               }
           }
       }
  
    @IBAction func submitAction(_ sender: Any) {
        self.setAccountDetailsChanges()
    }
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
    @objc func myTargetFunction(textField: UITextField) {
        print("myTargetFunction")
    }
    @objc func genderSelcted() {
        print("genderSelcted")
        var dataSource = ["Female","Male"]

           presentPicker(
             title: "RevelationTV",
             subtitle: "Gender",
             dataSource: dataSource,
             initialSelection: 0,
             onSelectItem: { item, index in
               print("\(item) selected at index \(index)")
                 self.genderTextfield.text = item
             })
    }
  
    @objc func countrySelected() {
        print("dobSelected")
        let countryData = countries_Array
        let countryCodeData = country_code_Array

        
           presentPicker(
             title: "RevelationTV",
             subtitle: "Select Country",
             dataSource: countryData,
             initialSelection: 0,
             onSelectItem: { item, index in
               print("\(item) selected at index \(index)")
                 self.countryTextfield.text = item
                 self.countryCode = self.country_code_Array[index]
                 print("countrycode",self.countryCode)
             })
    }
    @objc func dobSelected() {
        print("dobSelected")
        let picker = MultiPicker.datePicker { date, picker in
                        self.dismiss(animated: true, completion: nil)
            guard
                let date = date
                else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            self.dobTextfield.text = dateFormatter.string(from: date)
            
            let savedFormatter = DateFormatter()
            savedFormatter.dateFormat = "yyyy-MM-dd"
            self.dateOfBirthString = savedFormatter.string(from: date)
        }
        present(picker, animated: true, completion: nil)
    }
}

extension AccountViewController : UITextFieldDelegate{
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // HERE, open your keyboard or do whatever you want
        if textField == genderTextfield{
            self.genderSelcted()
            return false
        }
         if textField == dobTextfield{
            self.dobSelected()
            return false
        }
        if textField == emailTextField{
           return false
       }
        if textField == countryTextfield{
        self.countrySelected()
        return false
       }
        return true
    }
    
    

}
extension AccountViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
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
        if indexPath.item == 0{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
        
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if indexPath.item == 1{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveTabVC") as! LiveTabViewController
           
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if indexPath.item == 2{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "DemandVC") as! DemandViewController
           
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if indexPath.item == 3{
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "CatchupVC") as! CatchupViewController
           
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if indexPath.item == 4{
//            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
//            self.present(videoDetailView, animated: false, completion: nil)
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "WatchListVC") as! WatchListViewController
            self.present(videoDetailView, animated: false, completion: nil)
        }
        else if indexPath.item == 5{

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
        if indexPath.row == 0{
            cell.menuLabel.textColor = .white
        }else{
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
