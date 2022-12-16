//
//  ThemeManager.swift
//  HappiAppleTV
//
//  Created by GIZMEON on 04/02/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation

import UIKit

enum Theme: Int {

  case theme1, theme2

  var mainColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }

  var navigationBackgroundImage: UIImage? {
    return self == .theme1 ? UIImage(named: "navBackground") : nil
  }

  var tabBarBackgroundImage: UIImage? {
    return self == .theme1 ? UIImage(named: "tabBarBackground") : nil
  }
    
  var focusedColor: UIColor {
    return UIColor().colorFromHexString("#E72A31")
  }
    var backgroundColor: UIColor {
      return UIColor().colorFromHexString("#011E4E")
    }
    var themeColor: UIColor{
        return UIColor().colorFromHexString("#011E4E")
    }
    var ButtonBorderColor: UIColor{
        return UIColor().colorFromHexString("#E72A31")
    }
    var viewBackgroundColor: UIColor {
      return UIColor().colorFromHexString("#181818")
    }
    var buttonColorDark: UIColor {
      return UIColor().colorFromHexString("#0f0f0f")
    }
    
    
    var fontBold: String {
        return "Helvetica-Bold"
    }
    var fontRegular: String {
      return "ITCAvantGardePro-Bk"
    }
    var fontLight: String {
      return "Montserrat-Light"
    }
//    var fontDefault: String {
//        return "ITCAvantGardePro-Bk"
//    }
  var secondaryColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }

  var titleTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }
  var subtitleTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("ffffff")
    case .theme2:
      return UIColor().colorFromHexString("000000")
    }
  }
    
  var textColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("000000")
    case .theme2:
      return UIColor().colorFromHexString("ffffff")
    }
  }
  var sideMenuTextColor: UIColor {
    switch self {
    case .theme1:
      return UIColor.darkGray
    case .theme2:
      return UIColor.lightGray
    }
  }
    var buttonTextColor: UIColor {
        return UIColor().colorFromHexString("#E72A31")
    }
    
    var descriptionTextColor: UIColor {
        return UIColor().colorFromHexString("#F8F8F8")
    }
    var headerTextColor: UIColor {
        return UIColor().colorFromHexString("#FBFBFB")
    }
  var textfeildColor: UIColor {
    switch self {
    case .theme1:
      return UIColor().colorFromHexString("000000")
    case .theme2:
      return UIColor().colorFromHexString("808080")
    }
  }
  var CgColor: CGColor {
    switch self {
    case .theme1:
      return  UIColor.white.cgColor
    case .theme2:
      return  UIColor.black.cgColor
    }
  }
  var PrivacyPolicyURL: String {
    return "https://gethappi.tv/policydarkmode"
  }
  var TermsAndConditionURL: String {
    return "https://gethappi.tv/termsofuse"
  }
  //screen change
  var Splashscreenimage: String {
    return "splashscreenimage"
  }
  var RightImage: String {
    return "rightArrow"
  }
  var emailAddress: String {
    return "support@gethappi.tv"
  }
  var logoutImage: String {
    return "TVExcelLogout"
  }
  var logoImage: String {
    return "LoginScreenImage"
  }
  var navigationControllerLogo: String {
    return "navigationControllerLogo"
  }
  var backImage: String {
    return "TVExcelBack"
  }
//  var UIImageColor: UIColor {
//    return UIColor().colorFromHexString("#e89c36")
//  }
    var UIImageColor: UIColor {
      return UIColor().colorFromHexString("#0f0f0f")
    }
    
  var appName: String {
    return "Revelation TV"
  }
 var app_publisher_bundle_id: String {
//    let bundleID = Bundle.main.bundleIdentifier
    return "com.ios.revelationtv.tv"
  }
  var app_key: String {
   return "RevelationTVtvOS"
  }
  var grayImageColor: UIColor {
    return UIColor().colorFromHexString("1F1F1F")
  }
    var newBackgrondColor: UIColor {
       return UIColor().colorFromHexString("#141414")
     }
    var textBackgroundColor: UIColor {
       return UIColor().colorFromHexString("#213A64")
     }

}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {

  // ThemeManager
  static func currentTheme() -> Theme {
    if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
      return Theme(rawValue: storedTheme)!
    } else {
      return .theme2
    }
  }


}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
