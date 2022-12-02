//
//  TopBannerTableViewCell.swift
//  RevelationTV
//
//  Created by Firoze Moosakutty on 24/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

class TopBannergvhghjTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet fileprivate var mainCollectionView:UICollectionView!
    
    @IBOutlet weak var topBannerCollectionViewHeight: NSLayoutConstraint!
    
    var featuredVideos: [VideoModel]? {
      didSet{
          mainCollectionView.reloadData()
      
            self.layoutIfNeeded()
      }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainCollectionView.register(UINib(nibName: "TopBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TopBannerCollectionCell")
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.backgroundColor = ThemeManager.currentTheme().newBackgrondColor
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBannerCollectionCell", for: indexPath as IndexPath) as! TopBannerCollectionViewCell
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if featuredVideos![indexPath.row].logo_thumb != nil {
                cell.topBannerImage.sd_setImage(with: URL(string: ((featuredVideos![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            } else {
                cell.topBannerImage.image = UIImage(named: "landscape_placeholder")
            }

        } else {
            if featuredVideos![indexPath.row].logo_thumb != nil {
                cell.topBannerImage.sd_setImage(with: URL(string: ((featuredVideos![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
            } else {
                cell.topBannerImage.image = UIImage(named: "landscape_placeholder")
            }
        }

      let width = (UIScreen.main.bounds.width - 2)//some width
      let  height = (45 * width) / 364
      self.topBannerCollectionViewHeight.constant = height
      return cell
    }
    
}
