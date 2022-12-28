//
//  Login Register View Controller.swift
//  KICCTV
//
//  Created by Firoze Moosakutty on 01/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import Reachability
import TVMultiPicker

class LoginRegisterViewController: UIViewController,GuestRegisterDelegate, RegisterMenuDelegate {
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
    var lastFocusedIndexPath: IndexPath?
var menuArray = [String]()
    func didSelectRegister() {
        
    }
    func didSelectRegisterSkip() {
        
    }
    let reachability = try! Reachability()
    var guestUserLogedIn = false
    var userDetails = [userModel]()
    var loginUserDetails = [VideoModel]()

    weak var guestUserDelegate: videoPlayingDelegate!
    var countries_Array = [String]()
    var country_code_Array = [String?]()

    
    let lettersAndSpacesCharacterSet = CharacterSet.letters.union(.whitespaces).inverted

    var userId = String()
    var countryCode : String?
    var selectedDateString : String?
    
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
    
    @IBOutlet weak var registerHeader: UILabel!{
        didSet{
            registerHeader.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 24)
        }
    }
    
    @IBOutlet weak var FullNameLabel: UILabel!{
        didSet{
            FullNameLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var nameText: UITextField!{
        didSet{
            nameText.layer.cornerRadius = 5
            nameText.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var lastNameLabel: UILabel!{
        didSet{
            lastNameLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var lastNameText: UITextField!{
        didSet{
            lastNameText.layer.cornerRadius = 5
            lastNameText.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var emailText: UITextField!{
        didSet{
            emailText.layer.cornerRadius = 5
            emailText.layer.masksToBounds = true
            emailText.keyboardType = .emailAddress
        }
    }
    
    @IBOutlet weak var passwordLabel: UILabel!{
        didSet{
            passwordLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var passwordText: UITextField! {
        didSet{
            passwordText.isSecureTextEntry = true
            passwordText.layer.cornerRadius = 5
            passwordText.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!{
        didSet{
            confirmPasswordLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var confirmPasswordText: UITextField!{
        didSet{
            confirmPasswordText.isSecureTextEntry = true
            confirmPasswordText.layer.cornerRadius = 5
            confirmPasswordText.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var dobLabel: UILabel!
    
//    @IBOutlet weak var dobButton: UIButton!{
//        didSet{
//            self.dobButton.addTarget(self, action: #selector(dobButtonTapped), for: .primaryActionTriggered)
//            dobButton.layer.cornerRadius = 5
//            dobButton.layer.masksToBounds = true
//
//        }
//    }
    
    @IBOutlet weak var genderLabel: UILabel!
    
//    @IBOutlet weak var genderButton: UIButton!{
//        didSet{
//            genderButton.layer.cornerRadius = 5
//            genderButton.layer.masksToBounds = true
//        }
//    }
    
//    @IBAction func genderButtonAction(_ sender: Any) {
//        let genderData = ["Male", "Female"]
////        var dataSource = ["\(seasonName ?? "")"]
////           dataSource.insert("Some big item", at: 1)
////           dataSource.insert("Some other big item", at: 4)
//
//           presentPicker(
//             title: "RevelationTV",
//             subtitle: "Select Gender",
//             dataSource: genderData,
//             initialSelection: 0,
//             onSelectItem: { item, index in
//               print("\(item) selected at index \(index)")
//                 self.genderButton.setTitle(item, for: .normal)
//             })
//
//    }
    
    @IBOutlet weak var countryLabel: UILabel!{
        didSet{
            countryLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }

    @IBOutlet weak var countryButton: UIButton!{
        didSet{
            countryButton.layer.cornerRadius = 5
            countryButton.layer.masksToBounds = true
            countryButton.setTitleColor(.black, for: .normal)
            countryButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
            countryButton.titleLabel?.textAlignment = .left
        }
    }
    
    @IBAction func countryButtonAction(_ sender: Any) {
        let countryData = countries_Array
        let countryCodeData = country_code_Array
//        var dataSource = ["\(seasonName ?? "")"]
//           dataSource.insert("Some big item", at: 1)
//           dataSource.insert("Some other big item", at: 4)
        
           presentPicker(
             title: "RevelationTV",
             subtitle: "Select Country",
             dataSource: countryData,
             initialSelection: 0,
             onSelectItem: { item, index in
               print("\(item) selected at index \(index)")
                 self.countryButton.setTitle(item, for: .normal)
                 self.countryCode = self.country_code_Array[index]
                 print("countrycode",self.countryCode)
             })

    }
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
              registerButton.backgroundColor = ThemeManager.currentTheme().buttonTextColor
              registerButton.titleLabel?.font = UIFont(name: "ITCAvantGardePro-Bk", size: 20)
              registerButton.titleLabel?.textColor = .white
//            registerButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
              registerButton.layer.borderWidth = 0
              registerButton.layer.cornerRadius = 8
              registerButton.layer.masksToBounds = true
            }
        }
    
    @IBOutlet weak var seperatorView: UIView!{
        didSet{
            seperatorView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        }
    }
   
    @IBOutlet weak var seperatorFocusButton: UIButton!{
        didSet{
            seperatorFocusButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            seperatorFocusButton.setTitle("", for: .normal)
            seperatorFocusButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            seperatorFocusButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            seperatorFocusButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            seperatorFocusButton.imageEdgeInsets = UIEdgeInsets(top: -12, left: 0, bottom: -12, right: 0)
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
    
//    @objc
//      private func dobButtonTapped() {
//          let picker = MultiPicker.datePicker { date, picker in
//                          self.dismiss(animated: true, completion: nil)
//              guard
//                  let date = date
//                  else { return }
//              let dateFormatter = DateFormatter()
//              dateFormatter.dateFormat = "MMM d, yyyy"
//              self.dobButton.setTitle(dateFormatter.string(from: date), for: .normal)
//              let Formatter = DateFormatter()
//              Formatter.dateFormat = "yyyy-MM-dd"
//              self.selectedDateString = Formatter.string(from: date)
//              print("selected date",self.selectedDateString)
//          }
//          present(picker, animated: true, completion: nil)
//      }
    
    @IBOutlet weak var termsOfUseLabel: UILabel!
    
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var loginHeader: UILabel!{
        didSet{
            loginHeader.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 24)
        }
    }
    
    @IBOutlet weak var emailLoginLabel: UILabel!{
        didSet{
            emailLoginLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var emailLoginText: UITextField!{
        didSet{
            emailLoginText.layer.cornerRadius = 5
            emailLoginText.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var passwordLoginLabel: UILabel!{
        didSet{
            passwordLoginLabel.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 18)
        }
    }
    
    @IBOutlet weak var passwordLoginText: UITextField!{
        didSet{
            passwordLoginText.isSecureTextEntry = true
            passwordLoginText.layer.cornerRadius = 5
            passwordLoginText.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var LoginButton: UIButton!{
        didSet{
              LoginButton.backgroundColor = ThemeManager.currentTheme().ButtonBorderColor
              LoginButton.titleLabel?.font = UIFont(name: "ITCAvantGardePro-Bk", size: 20)
              LoginButton.titleLabel?.textColor = UIColor.white
              LoginButton.layer.cornerRadius = 8
//            LoginButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
              LoginButton.layer.borderWidth = 0
              LoginButton.layer.masksToBounds = true
            }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        signin()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]
        }
        else{
            self.menuArray = ["Watch Live","Home","On-Demand","Schedule"]

        }
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "menuCollectionCell")
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        lastFocusedIndexPath = IndexPath(row: 1, section: 0)
        DispatchQueue.main.async {
            self.menuCollectionView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.currentTheme().UIImageColor
        self.updateFocusIfNeeded()
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            self.country_code_Array.append(id)
            self.countries_Array.append(name)
        }
        Application.shared.country_code = "US"

       

        var countries_Array: [String] = []
        var country_code_Array: [String] = []
        
        emailLoginText.delegate = self
        passwordLoginText.delegate = self
    }
    
    @objc func dobDatePicker() {
        let dobPicker = MultiPicker.datePicker(
        startYear: 1900,            // Lower year bound
        initialYear: 1990,          // Initially focused year
        configuration: .defaultConfig
        ) { date, picker in
        picker.dismiss(animated: true, completion: nil)
        print(date)
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
    @objc func menuButtonAction() {
        print("menu pressed")
        
    }
    func gotoHome(){

        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
        present(gotohomeView, animated: true, completion: nil)

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
    func signin(){
        if (commonClass.isValidEmail(email:emailLoginText!.text! ) == 1) {
            commonClass.showAlert(viewController:self, messages: "Enter Email")
        } else if(commonClass.isValidEmail(email:emailLoginText!.text! ) == 3) {
            commonClass.showAlert(viewController:self, messages: "Invalid Email")
        } else if (passwordLoginText.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Password")
        }
//        else if (passwordTextField.text!.count < 6) {
//            commonClass.showAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
//
//        }
        else {
            self.signInApiCalling()
        }
    }

    func signInApiCalling() {
        userDetails.removeAll()
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        guard let email =  self.emailLoginText.text, let password = self.passwordLoginText.text else {
            return
        }
       
        if UserDefaults.standard.string(forKey:"countryCode") != nil{
             parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        }
        else{
            parameterDict["country_code"] = "US"
        }
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
             parameterDict["device_id"] = device_id
           }
        if UserDefaults.standard.string(forKey:"IPAddress") != nil{
          if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
               parameterDict["ipaddress"] = ipAddress
           }
        }
        if emailLoginText.text != nil{
            let trimmedString = emailLoginText!.text!.trimmingCharacters(in: .whitespaces)
            parameterDict["user_email"] = trimmedString.lowercased()
        }
        if !password.isEmpty{
            let trimmedString = password.trimmingCharacters(in: .whitespaces)
            parameterDict["password"] = trimmedString
        }
        
        
        parameterDict["pubid"] = UserDefaults.standard.string(forKey: "pubid")
        if UserDefaults.standard.string(forKey:"countryCode") != nil{
             parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        }
        else{
            parameterDict["country_code"] = " "
        }
//         parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
             parameterDict["device_id"] = device_id
           }
        if UserDefaults.standard.string(forKey:"IPAddress") != nil{
          if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
               parameterDict["ipaddress"] = ipAddress
           }
        }
        ApiCommonClass.Login (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if let errror = responseDictionary["error"] as? String {
                DispatchQueue.main.async {
                    if responseDictionary["user_id"] == nil{
                        commonClass.showAlert(viewController: self, messages: errror )
                        commonClass.stopActivityIndicator(onViewController: self)
                    }
                    else{
                        commonClass.stopActivityIndicator(onViewController: self)
                        commonClass.showAlert(viewController: self, messages: errror )
                        UserDefaults.standard.set(email.lowercased(), forKey: "user_email")
//                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "otpVerification") as! OTPverificationViewController
//                        gotohomeView.guestRegisterDelegates = self
                        Application.shared.isFromRegister = false
//                        gotohomeView.userid = responseDictionary["user_id"]! as! String
                        
//                        self.present(gotohomeView, animated: true, completion: nil)
                        
                        print(responseDictionary["user_id"])
                    }
                }
            } else {
                self.loginUserDetails = responseDictionary["Channels"] as! [VideoModel]
                
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    UserDefaults.standard.set(self.loginUserDetails[0].user_id, forKey: "user_id")
                    UserDefaults.standard.set(self.loginUserDetails[0].first_name, forKey: "first_name")
                    UserDefaults.standard.set(self.loginUserDetails[0].user_email, forKey: "user_email")
                    UserDefaults.standard.set("true", forKey: "login_status")
                    UserDefaults.standard.set("false", forKey: "skiplogin_status")
                    self.app_Install_Launch()
                    if self.guestUserLogedIn == true {
                        commonClass.stopActivityIndicator(onViewController: self)
                        Application.shared.guestRegister = true
                        self.getUserSubscription()
                    }
                    else {
                        
                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                        self.present(gotohomeView, animated: true, completion: nil)

                    }
                    
                }
                
            }
        }
        
    }
    func getUserSubscription(){
        self.dismiss(animated: true, completion: nil)
        self.guestUserDelegate.guestUserLogin()
 
    }
    
    func app_Install_Launch() {
      var parameterDict: [String: String?] = [ : ]
      let currentDate = Int(Date().timeIntervalSince1970)
      parameterDict["timestamp"] = String(currentDate)
      parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
      if let device_id = UserDefaults.standard.string(forKey:"UDID") {
        parameterDict["device_id"] = device_id
      }
 
      parameterDict["device_type"] = "apple-tv"
      if let longitude = UserDefaults.standard.string(forKey:"longitude") {
        parameterDict["longitude"] = longitude
      }
      if let latitude = UserDefaults.standard.string(forKey: "latitude"){
        parameterDict["latitude"] = latitude
      }
      if let country = UserDefaults.standard.string(forKey:"country"){
        parameterDict["country"] = country
      }
      if let city = UserDefaults.standard.string(forKey:"city"){
        parameterDict["city"] = city
      }
      if let userAgent = UserDefaults.standard.string(forKey:"userAgent"){
           parameterDict["ua"] = userAgent
         }
      if let IPAddress = UserDefaults.standard.string(forKey:"IPAddress") {
        parameterDict["ip_address"] = IPAddress
      }
     
      if let advertiser_id = UserDefaults.standard.string(forKey:"Idfa"){
        parameterDict["advertiser_id"] = advertiser_id
      }
      if let app_id = UserDefaults.standard.string(forKey: "application_id") {
        parameterDict["app_id"] = app_id
      }
      parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
         parameterDict["width"] =  String(format: "%.3f",UIScreen.main.bounds.width)
         parameterDict["height"] = String(format: "%.3f",UIScreen.main.bounds.height)
         parameterDict["device_make"] = "Apple"
        parameterDict["device_model"] = UserDefaults.standard.string(forKey:"deviceModel")
         if (UserDefaults.standard.string(forKey: "first_name") != nil){
          parameterDict["user_name"] = UserDefaults.standard.string(forKey: "first_name")
         }
      if let user_email = UserDefaults.standard.string(forKey: "user_email"){
       parameterDict["user_email"] = user_email
      }
       
      if let publisherid = UserDefaults.standard.string(forKey: "pubid") {
        parameterDict["publisherid"] = publisherid
      }
      
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
     
      if (UserDefaults.standard.string(forKey:"skiplogin_status") == "false") {
  //    if (UserDefaults.standard.string(forKey: "user_email") != nil){
  //     parameterDict["user_email"] = UserDefaults.standard.string(forKey: "user_email")
  //    }
  //
      if (UserDefaults.standard.string(forKey: "phone") != nil){
       parameterDict["user_contact_number"] = UserDefaults.standard.string(forKey: "phone")
      }
          
      }
        print("param for device api ",parameterDict)
      ApiCommonClass.analayticsAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
        if responseDictionary["error"] != nil {
          DispatchQueue.main.async {
          }
        } else {
          DispatchQueue.main.async {
            print("device api success")
          }
        }
      }
    }
    // Register
    @IBAction func registerAction(_ sender: Any) {
        if (nameText.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Name")
        }
      else if  nameText.text?.rangeOfCharacter(from: lettersAndSpacesCharacterSet) != nil {
        commonClass.showAlert(viewController:self, messages: "No special character allowed for user name")
       }
      else if nameText.text!.isReallyEmpty || nameText.text == "              " {
        commonClass.showAlert(viewController:self, messages: "User name must start with letter")
      }
     else if (lastNameText.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Last Name")
        }
      else if  lastNameText.text?.rangeOfCharacter(from: lettersAndSpacesCharacterSet) != nil {
        commonClass.showAlert(viewController:self, messages: "No special character allowed for user name")
       }
      else if lastNameText.text!.isReallyEmpty || lastNameText.text == "              " {
        commonClass.showAlert(viewController:self, messages: "User name must start with letter")
      }
        else if (commonClass.isValidEmail(email:emailText!.text! ) == 1) {
            commonClass.showAlert(viewController:self, messages: "Enter Email")
        } else if(commonClass.isValidEmail(email:emailText!.text! ) == 3) {
            commonClass.showAlert(viewController:self, messages: "Invalid Email")
        }
        else if (countryButton.titleLabel!.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Country")
        }
        else if (passwordText.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Enter Password")
        }
        else if (passwordText.text!.count < 6) {
            commonClass.showAlert(viewController:self, messages: "Password should contain minimum of 6 characters")
        }
        else if (confirmPasswordText.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Please confirm Password")
        }
        else if (confirmPasswordText.text?.isEmpty)! {
            commonClass.showAlert(viewController:self, messages: "Password doesn't match")
        }
        else {
            register()
        }
    }
    func register() {
        let UDID = UIDevice.current.identifierForVendor?.uuidString
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        var parameterDict: [String: String?] = [ : ]
        
        guard let email = self.emailText.text, let password = self.passwordText.text,let udid = UDID,let name = self.nameText.text,let lastname = self.lastNameText.text  else {
            return
        }
        
        if self.emailText.text != nil{
            let trimmedString = self.emailText!.text!.trimmingCharacters(in: .whitespaces)
            parameterDict["user_email"] = trimmedString.lowercased()
            UserDefaults.standard.set(parameterDict["user_email"] as Any?, forKey: "user_email")

        }
        if !password.isEmpty{
            let trimmedString = password.trimmingCharacters(in: .whitespaces)
            parameterDict["password"] = trimmedString
        }

        parameterDict["first_name"] = name
        parameterDict["last_name"] = lastname
//        if self.dobButton.titleLabel != nil {
//            let dob = self.selectedDateString
//            parameterDict["dob"] = dob
//        }
//        if self.genderButton.titleLabel?.text != nil {
//            let gender = self.genderButton.titleLabel?.text
//            parameterDict["gender"] = gender
//        }
        if self.countryButton.titleLabel?.text != nil {
            let countrycode = self.countryCode
            parameterDict["country_code"] = countrycode
        }
        if let ipAddress = UserDefaults.standard.string(forKey:"IPAddress") {
            parameterDict["ipaddress"] = ipAddress
        }
       
            parameterDict["apple_id"] = "0"
      
            parameterDict["facebook_id"] = "0"
            
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
     
        parameterDict["login_type"] = "gmail-login"
        parameterDict["verified"] = UserDefaults.standard.string(forKey: "verifiedNumber")
        parameterDict["c_code"] = ""
        if let longitude = UserDefaults.standard.string(forKey:"longitude") {
          parameterDict["longitude"] = longitude
        }
        if let latitude = UserDefaults.standard.string(forKey: "latitude"){
          parameterDict["latitude"] = latitude
        }
        if let country = UserDefaults.standard.string(forKey:"country"){
          parameterDict["country"] = country
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(parameterDict)
        print("parameterDictionary",parameterDict)
        ApiCallManager.apiCallREST(mainUrl: RegisterApi, httpMethod: "POST", headers: ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: data) { (responseDictionary: Dictionary) in
            var channelResponseArray = [userModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            print("enter to registration ")
           guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 0{
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController: self, messages: responseDictionary["message"] as! String)
                    
                }
            }
            else if status == 1 {
                DispatchQueue.main.async {
                    let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                    for videoItem in dataArray {
                        let JSON: NSDictionary = videoItem as NSDictionary
                        let videoModel: userModel = userModel.from(JSON)! // This is a 'User?'
                        channelResponseArray.append(videoModel)
                    }
                    channelResponse["Channels"]=channelResponseArray as AnyObject
                    self.userDetails = channelResponse["Channels"] as! [userModel]
                    if self.userDetails.count != 0 {
                        print(self.userDetails[0])
                        DispatchQueue.main.async {
                            UserDefaults.standard.string(forKey: "user_name")
                            UserDefaults.standard.set(self.userDetails[0].user_email, forKey: "user_email")
                            UserDefaults.standard.set("true", forKey: "login_status")
                            UserDefaults.standard.set("false", forKey: "skiplogin_status")
                            UserDefaults.standard.set(self.userDetails[0].user_id, forKey: "user_id")
                            UserDefaults.standard.set(self.userDetails[0].first_name, forKey: "user_name")
//                            if self.isFromLogin{
//                                self.dismiss(animated: false, completion: {
//                                    self.loginDelegate?.loadHome()
//                                })
//                            }
//                            else{
                                Application.shared.isFromRegister = true
                                self.gotoHome()
//                            }
                        }
                    }
                    
//                    commonClass.stopActivityIndicator(onViewController: self)
//                    let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "otpVerification") as! OTPverificationViewController
//                    gotohomeView.registerdelegates = self
//                    gotohomeView.userid = self.userId
                    Application.shared.isFromRegister = true
//                    self.present(gotohomeView, animated: true, completion: nil)
                }
                
            }
            else if status == 2{
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    commonClass.showAlert(viewController: self, messages: "Already registered user")
                    
                }
            }
            else {
                channelResponse["error"]=responseDictionary["message"]
            }
            
        }
        
    }
    let scale = 1.0
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations({
            if self.accountButton.isFocused {
                self.accountButton.transform = CGAffineTransformMakeScale(self.scale, self.scale)
                self.accountOuterView.layer.borderWidth = 3
                self.accountOuterView.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
                self.accountButton.layer.cornerRadius = 35
                self.accountButton.layer.masksToBounds = true
                self.searchButton.tintColor = .white
                self.seperatorFocusButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                self.countryButton.backgroundColor = UIColor.white
            }
            else if self.seperatorFocusButton.isFocused{
                self.seperatorFocusButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                self.searchButton.tintColor = .white
                self.seperatorFocusButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                self.countryButton.backgroundColor = UIColor.white
                self.accountButton.transform = CGAffineTransformIdentity
                self.accountOuterView.layer.borderWidth = 0

            }
           else if self.searchButton.isFocused{
            self.searchButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
            self.searchButton.tintColor = ThemeManager.currentTheme().ButtonBorderColor
            self.accountButton.transform = CGAffineTransformIdentity
            self.accountOuterView.layer.borderWidth = 0
           }
           else  if self.countryButton.isFocused {
                self.countryButton.backgroundColor = ThemeManager.currentTheme().focusedColor
                self.searchButton.tintColor = .white
                self.seperatorFocusButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                self.accountButton.transform = CGAffineTransformIdentity
                self.accountOuterView.layer.borderWidth = 0
            }
            else{
                self.accountButton.transform = CGAffineTransformIdentity
                self.accountOuterView.layer.borderWidth = 0
                self.searchButton.tintColor = .white
                self.seperatorFocusButton.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
                self.countryButton.backgroundColor = UIColor.white
            }

        }, completion: nil)
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == nameText{
//            nameText.resignFirstResponder()
//        }
//        if textField == lastNameText {
//            lastNameText.resignFirstResponder()
//        }
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == nameText{
//            nameText.resignFirstResponder()
//        }
//        if textField == lastNameText {
//            lastNameText.resignFirstResponder()
//        }
//    }
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        if textField == nameText{
//            nameText.resignFirstResponder()
//        }
//        if textField == lastNameText {
//            lastNameText.resignFirstResponder()
//        }
//    }
    func didSelectGuestRegister() {
        Application.shared.guestRegister = true
        self.gotoHome()
    }
    
    func didSelectSkipVerification() {
        navigationController?.popViewController(animated: false)
        Application.shared.guestRegister = false
        self.gotoHome()
    }

}
extension LoginRegisterViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == nameText{
//            lastNameText.becomeFirstResponder()
//        }
//        else if textField == lastNameText{
//            emailText.becomeFirstResponder()
//        }
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailLoginText{
            passwordLoginText.becomeFirstResponder()
            return true
        }
        
        else if textField == passwordLoginText{
            passwordLoginText.resignFirstResponder()
            return true
        }
        return true
    }
}
extension LoginRegisterViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
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
    override var preferredFocusEnvironments : [UIFocusEnvironment] {
        return [menuCollectionView]
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
        }else{
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
extension LoginRegisterViewController : PopUpDelegate{
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
                    let signupPageView =  self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                    self.present(signupPageView, animated: true, completion: nil)
                    
                } else {
    
                }
            }

        
        
    }
    
   
    
}
