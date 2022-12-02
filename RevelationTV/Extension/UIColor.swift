//
//  UIColor.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 03/09/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
// MARK: Extensions
extension UIView{
  func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
     let gradientLayer = CAGradientLayer()
     gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
     gradientLayer.locations = [0.0, 1.0]
     gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
     layer.insertSublayer(gradientLayer, at: 0)
   }
    func setDianamicGradientBackground(colorTop: UIColor, colorBottom: UIColor,height:CGFloat) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
       gradientLayer.locations = [0.0, 1.0]
       gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
       layer.insertSublayer(gradientLayer, at: 0)
     }
    func setGradientBackgroundForDetailScreen(colorTop: UIColor, colorBottom: UIColor) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
       gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
       layer.insertSublayer(gradientLayer, at: 0)
     }
    
}
