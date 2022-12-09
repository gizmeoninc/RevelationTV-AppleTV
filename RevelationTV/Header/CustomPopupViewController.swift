//
//  CustomPopupViewController.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 23/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//
//Protocol to inform the Parent viewController to take some action based on the dialog box
protocol PopUpDelegate {
    func handleAccountButtonAction(action: Bool)
    func handleLogoutAction(action: Bool)
}
import Foundation
import UIKit
class CustomPopupViewController: UIViewController {
    var delegate: PopUpDelegate?

    @IBOutlet weak var acoountSettingsButton: UIButton!{
        didSet{
            self.acoountSettingsButton.setTitle("My Favourites", for: .normal)
//            self.acoountSettingsButton.setTitle("Account Settings", for: .normal)
            self.acoountSettingsButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.acoountSettingsButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
            self.acoountSettingsButton.titleLabel?.font =  UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            self.acoountSettingsButton.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            self.acoountSettingsButton.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var logOutButton: UIButton!{
        didSet{
            self.logOutButton.setTitle("Logout", for: .normal)
            self.logOutButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.logOutButton.titleLabel?.textColor = ThemeManager.currentTheme().headerTextColor
            self.logOutButton.titleLabel?.font =  UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            self.logOutButton.layer.borderColor = ThemeManager.currentTheme().headerTextColor.cgColor
            self.logOutButton.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        popupView.backgroundColor = .clear
        
    }
    @IBAction func acoountSettingsButtonaction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.handleAccountButtonAction(action: true)

    }
    
    @IBAction func logoutAction(_ sender: Any) {
        self.delegate?.handleLogoutAction(action: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if acoountSettingsButton.isFocused{
            self.acoountSettingsButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.logOutButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            
        }
        else
        {
            self.acoountSettingsButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            self.logOutButton.backgroundColor = ThemeManager.currentTheme().focusedColor
        }
    }
    static func showPopup(parentVC: UIViewController){
        //creating a reference for the dialogView controller
        if let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomVC") as? CustomPopupViewController {
        popupViewController.modalPresentationStyle = .custom
        popupViewController.modalTransitionStyle = .crossDissolve
        //setting the delegate of the dialog box to the parent viewController
        popupViewController.delegate = parentVC as? PopUpDelegate
            
        //presenting the pop up viewController from the parent viewController
        parentVC.present(popupViewController, animated: true)
        }
      }
}
