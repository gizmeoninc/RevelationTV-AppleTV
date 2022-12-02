//
//  GenderPickerViewController.swift
//  KICCTV
//
//  Created by Firoze Moosakutty on 02/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
import Reachability
class GenderPickerViewController: UIViewController {
    
    var selectedrow_gender: Int?
    var genderArray = ["Male","Female"]

    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBAction func genderSegmentAction(_ sender: UISegmentedControl) {
        if genderSegment.selectedSegmentIndex == 0 {
            print("male")
        }
        else if genderSegment.selectedSegmentIndex == 1 {
            print("female")
        }
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
