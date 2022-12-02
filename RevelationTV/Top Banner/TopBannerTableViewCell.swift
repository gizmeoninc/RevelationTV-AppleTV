//
//  TopBannerTableViewCell.swift
//  RevelationTV
//
//  Created by Firoze Moosakutty on 28/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

protocol TopBannerTableViewCellDelegate:class {
    func didSelectTopBanner(passModel :VideoModel)
}

class TopBannerTableViewCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    @IBOutlet weak var topBannerCollectionView: UICollectionView!
    
    @IBOutlet weak var topBannerCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topBannerCollectionViewWidth: NSLayoutConstraint!
    weak var delegate: TopBannerTableViewCellDelegate!
    
    var channelType = ""

    var featuredVideos: [VideoModel]? {
      didSet{
          topBannerCollectionView.reloadData()
      
            self.layoutIfNeeded()
      }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        topBannerCollectionView.register(UINib(nibName: "TopBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopBannerCollectionCell")
        topBannerCollectionView.dataSource = self
        topBannerCollectionView.delegate = self
        topBannerCollectionView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
        featuredVideos = []
//        mainCollectionView.isPagingEnabled = true
//        startTimer()
    }

func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
}
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if featuredVideos!.count > 0{
        return featuredVideos!.count
    }
    else{
        return 0
    }
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width  = UIScreen.main.bounds.width
        let widthBanner =  UIScreen.main.bounds.width / 4.5
        let height = (9 * widthBanner) / 16
            return CGSize(width: width, height: height)
    }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBannerCollectionCell", for: indexPath as IndexPath) as! TopBannerCollectionViewCell
//    cell.backgroundColor = .red
//    cell.topBannerImageView.backgroundColor = .yellow
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
        if featuredVideos![indexPath.row].logo_thumb != nil {
            cell.topBannerImageView.sd_setImage(with: URL(string: ((featuredVideos![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            
        } else {
            cell.topBannerImageView.image = UIImage(named: "landscape_placeholder")
        }

    } else {
        if featuredVideos![indexPath.row].logo_thumb != nil {
            cell.topBannerImageView.sd_setImage(with: URL(string: ((featuredVideos![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        } else {
            cell.topBannerImageView.image = UIImage(named: "landscape_placeholder")
        }
    }
//  self.pageControl.numberOfPages = featuredVideos!.count
//      self.pageControl.currentPage = indexPath.row
  let width = (UIScreen.main.bounds.width - 2)//some width
  let  height = (45 * width) / 364
    
//  self.topBannerCollectionViewHeight.constant = height/2
//    self.topBannerCollectionViewWidth.constant = width
return cell
}
}
