//
//  DemandShowsListingTableViewCell.swift
//  RevelationTV
//
//  Created by Firoze Moosakutty on 30/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
protocol DemandShowsListingTableCellDelegate:class {
    func didSelectDemandShows(passModel :VideoModel)
    func didSelectDianamicVideos(passModel :VideoModel?)
}
class DemandShowsListingTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
//    var dataArray: [VideoModel]? {
//        didSet{
//            mainCollectionView.reloadData()
////            mainCollectionView.backgroundColor = .red
//        }
//    }
    var videoArrayCount: Int?
    var videoArray: [VideoModel]? {
        didSet{
            mainCollectionView.reloadData()
            self.videoArrayCount = videoArray?.count
        }
    }
    
    @IBOutlet weak var mainCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var showsTitle: UILabel!
    
    @IBOutlet weak var showMoreButton: UIButton!{
        didSet{
            showMoreButton.setTitle("Show More  ", for: .normal)
          let image = UIImage(named: "down_arrow")?.withRenderingMode(.alwaysTemplate)
            showMoreButton.setImage(image, for: .normal)
            showMoreButton.tintColor = ThemeManager.currentTheme().buttonTextColor
            showMoreButton.backgroundColor = .clear
            showMoreButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            showMoreButton.layer.borderWidth = 3
            showMoreButton.titleLabel?.font = UIFont.init(name: "ITCAvantGardePro-Bk", size: 20)
            showMoreButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            showMoreButton.layer.cornerRadius = 8
            showMoreButton.titleLabel?.textAlignment = .center
            showMoreButton.layer.masksToBounds = true
            showMoreButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            showMoreButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            showMoreButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            showMoreButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
      }
    
//    @IBAction func showMoreAction(_ sender: Any) {
//        self.videoArrayCount = videoArray!.count
//        self.videoArray = dataArray
//        print("dataArrayCount",dataArray?.count)
//        print("videoArrayCount",videoArrayCount)
//        if videoArrayCount == dataArray?.count {
//            self.showMoreButton.isHidden = true
//        }
//        else{
//            if ((videoArrayCount! + 8) - 1) <= dataArray!.count {
//                videoArray = Array(dataArray![0...((videoArrayCount! + 8) - 1)])
//            }
//            else {
//                print("showmorebutton hidden")
//                self.showMoreButton.isHidden = true
//            }
//        }
//    }
    
    weak var delegate: DemandShowsListingTableCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCell")
       let flowlayout = UICollectionViewFlowLayout()
        mainCollectionView.collectionViewLayout = flowlayout
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
//        mainCollectionView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        videoArray = []
        self.videoArrayCount = videoArray!.count
        print("ddd",videoArrayCount)
//        self.updateUI()
//        if videoArrayCount == dataArray?.count{
//            self.showMoreButton.isHidden = true
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateUI(){
        var spaceHeight = CGFloat()
        let width = (mainCollectionView.bounds.width)/4
        let height = (((width-30) * 9)/16) + 30
        if videoArray!.count == 1 || videoArray!.count == 4 {
            spaceHeight = 40
            mainCollectionViewHeight.constant = height + spaceHeight
        }
        else if (videoArray!.count%4) == 0{
            spaceHeight = CGFloat(((videoArray!.count / 4)) * 40)
            mainCollectionViewHeight.constant = (CGFloat(videoArray!.count / 4 ) * height) + spaceHeight
        }
        else{
            spaceHeight = CGFloat(((videoArray!.count / 4) + 1) * 40)
            mainCollectionViewHeight.constant = (CGFloat((videoArray!.count / 4) + 1) * height) + spaceHeight
        }
        self.mainCollectionView.isHidden = false
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videoArray!.count > 0{
            return videoArray!.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.didSelectDianamicVideos(passModel: videoArray![indexPath.item])
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchCollectionCell
        cell.backgroundColor = .clear
        cell.imageView.layer.masksToBounds = true
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.layer.cornerRadius = 8
        cell.videoNameLabel.text = videoArray![indexPath.row].show_name
        cell.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        print("ggggg",videoArrayCount)
        self.videoArrayCount = videoArray!.count
        self.updateUI()
        if videoArray![indexPath.row].logo_thumb != nil {
            cell.imageView.sd_setImage(with: URL(string: ((videoArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        }
        else{
            cell.imageView.image = UIImage(named: "landscape_placeholder")
        }
//            cell.videoNameLabel.numberOfLines = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 20, left: 0, bottom:20, right:0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = (mainCollectionView.bounds.width)/4
         let height = ((width-30) * 9)/16
         return CGSize(width: width - 30, height: height + 30);
//        let width =  (mainCollectionView.bounds.width/4.5)
//        let height = ((width) * 9)/16
//        return CGSize(width: width - 30, height: height + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 30
    }
    
}
