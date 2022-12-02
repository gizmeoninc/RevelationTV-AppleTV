//
//  SubscriptionViewController.swift
//  Justwatchme
//
//  Created by GIZMEON on 16/06/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
protocol SubscriptionDelegate: class {
    func didPressBackFromSubscriptionVC()
}
class SubscriptionViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!{
        didSet{
            headerLabel.textColor = .white
            headerLabel.text = "Subscribe or Rent"
            self.headerLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var subscriptionCollectionView: UICollectionView!{
        didSet{
            self.subscriptionCollectionView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var subscriptionCollectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var subscriptionCollectionViewHeight: NSLayoutConstraint!
    var skProducts = [SKProduct]()
    // here we set all in app purchase ids
    let productIds: Set<String> = ["com.ios.Justwatchme.tv_paperview_one","com.ios.Justwatchme.tv_paperview_three","com.ios.Justwatchme.tv_paperview_eight","com.ios.Justwatchme.tv_Monthly_Subscription"]
    var VideoSubscriptionArray = [VideoSubscriptionModel]()
    var videoId = Int()
    var selectedIndex = 0
    weak var subscriptionDelegate : SubscriptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        subscriptionCollectionView.register(UINib(nibName: "SubscriptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subscriptionListCell")
        self.subscriptionCollectionView.delegate = self
        self.subscriptionCollectionView.dataSource =  self
        self.subscriptionCollectionViewWidth.constant = view.bounds.width / 2
        
        SwiftyStoreKit.retrieveProductsInfo(self.productIds) { (result) in
            let products = result.retrievedProducts
            self.skProducts = Array(products)
            self.getVideoSubscriptions(video_id:self.videoId) // call function to display prices of selected videos

           
            
        }
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(self.menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }
    @objc func menuButtonAction() {
        print("menu pressed")
        self.dismiss(animated: true, completion: nil)
        self.subscriptionDelegate?.didPressBackFromSubscriptionVC()
        
//        self.navigationController?.popToRootViewController(animated: true)
    }
    // API call to get subscription packages
    //@param video_id,uid
    func getVideoSubscriptions(video_id: Int) {
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["vid"] = String(video_id)
        parameterDict["uid"] = UserDefaults.standard.string(forKey:"user_id")
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        ApiCommonClass.getvideoSubscriptions(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    //CustomProgressView.hideActivityIndicator()
                    commonClass.startActivityIndicator(onViewController: self)
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate!.loadTabbar()
                }
            } else {
                DispatchQueue.main.async {
                    if let videos = responseDictionary["Channels"] as? [VideoSubscriptionModel] {
                        if videos.count == 0 {
                            print("video subscription array",self.VideoSubscriptionArray.count)
                            self.subscriptionCollectionView.isHidden = true
                            self.subscriptionCollectionView.reloadData()
                            commonClass.stopActivityIndicator(onViewController: self)
                           print("no result found")
                        } else {
                            self.VideoSubscriptionArray = videos
                            print("video subscription array",self.VideoSubscriptionArray.count)
                            let text = self.getProductDetails(productId: self.VideoSubscriptionArray[0].ios_keyword!)
                            self.subscriptionCollectionView.isHidden = false
                            self.subscriptionCollectionView.reloadData()
                            self.headerLabel.isHidden = false

                            commonClass.stopActivityIndicator(onViewController: self)
                            
                        }
                    }
                }
            }
        }
    }
    //API call to update subscription transaction
    func subscriptionTransaction(status: String,encryptedReceipt: String){
        commonClass.startActivityIndicator(onViewController: self)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "apple-tv"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["transaction_type"] = "1"
        parameterDict["status"] = status
        parameterDict["mode_of_payment"] = "ios-in-app"
        parameterDict["receiptid"] = encryptedReceipt
        if let subscription_id = VideoSubscriptionArray[selectedIndex].subscription_id {
            parameterDict["subscription_id"] = String(subscription_id)
        }
        if let price = VideoSubscriptionArray[selectedIndex].price {
            parameterDict["amount"] = String(price)
        }
        if let ios_keyword = VideoSubscriptionArray[selectedIndex].ios_keyword {
            parameterDict["product_id"] = ios_keyword
        }
        ApiCommonClass.subscriptionTransaction(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    if  status == "success" {
                        print("Your Subscription is processed /n Please wait for some time!")
                        self.subscriptionTransaction(status: status, encryptedReceipt: encryptedReceipt)
                        
                    }
                    
                
                    }
                }
             else {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    if status == "success" {
                        let gotohomeView =  self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! HomeTabBarViewController
                        self.present(gotohomeView, animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    func getProductDetails(productId : String) -> String {
        var priceText = ""
        for product in skProducts {
            if productId == product.productIdentifier {
                let currencySymbol = product.priceLocale.currencySymbol ?? "$"
                let Price = product.price.doubleValue
                let text = String(format: "\(currencySymbol)%.2f\n", Price)
                priceText = text
                break
            }
        }
        return priceText
    }
    //MARK:- IAP:-Delegate
    // to purchase package
    func purchase(_ purchase: String, atomically: Bool) {
        commonClass.startActivityIndicator(onViewController: self)
        SwiftyStoreKit.purchaseProduct(purchase, quantity: 1,atomically: false) { (result) in
            switch result {
            case .success(let product):
                commonClass.stopActivityIndicator(onViewController: self)

                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.didPurchased(product: product, restore: false)
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                commonClass.stopActivityIndicator(onViewController: self)

                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .clientInvalid: print("Not allowed to make the payment")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                  self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                  self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                default: print((error as NSError).localizedDescription)
                 self.subscriptionTransaction(status: "failed", encryptedReceipt: "")

                }
            }
        }
    }
    private func didPurchased(product: PurchaseDetails?, restore: Bool) {
        commonClass.startActivityIndicator(onViewController: self)

        SwiftyStoreKit.fetchReceipt(forceRefresh: false) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let receiptData):
                commonClass.stopActivityIndicator(onViewController: self)
                let encryptedReceipt = receiptData.base64EncodedString()
                
                self.subscriptionTransaction(status: "success", encryptedReceipt: encryptedReceipt)
                print("Fetch receipt success")
            case .error(let error):
                commonClass.stopActivityIndicator(onViewController: self)
                switch error {
                case ReceiptError.networkError(let error):
                    if (error as NSError).code != 16 {
                        print("rciept error")
//                        WarningDisplayViewController().customActionAlert(viewController :self,title: "Error", message: error.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
//                            }, nil])
                    }
                default: print("")
//                WarningDisplayViewController().customActionAlert(viewController :self,title: "Error", message: error.localizedDescription, actionTitles: ["Ok"], actions:[{action1 in
//                    }, nil])
                }
            }
        }
    }
   
}

extension SubscriptionViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoSubscriptionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionListCell", for: indexPath as IndexPath) as! SubscriptionCollectionViewCell
        let text = self.getProductDetails(productId: VideoSubscriptionArray[indexPath.row].ios_keyword!)
        cell.subscriptionNameLabel.text = self.VideoSubscriptionArray[indexPath.row].subscription_name
        cell.priceLabel.text = text
        cell.priceLabel.textColor = .white
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        cell.subscriptionNameLabel.textColor = .gray
        cell.layer.cornerRadius = 24
//        cell.layer.borderColor = UIColor.white.cgColor
//        cell.layer.borderWidth = 2.0
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = UIScreen.main.bounds.width/4.5
        let height = (width*9) / 16
        subscriptionCollectionViewHeight.constant = height + 20
        return CGSize(width:view.bounds.width/4.5, height: height);

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        if self.VideoSubscriptionArray[indexPath.row].ios_keyword! != "" {
            self.purchase(self.VideoSubscriptionArray[indexPath.row].ios_keyword!, atomically: true)
        }
    }
}
