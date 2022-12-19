//
//  DemandTableViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 01/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit
protocol DemandTableViewCellDelegate:class {
    func didSelectWatchlist(passModel :VideoModel?)
    func didSelectPlayIcon(passModel :VideoModel?)
    func didSelectMoreInfo(passModel :VideoModel?)
}
class DemandTableViewCell: UITableViewCell{
    
    var videoType = ""
    weak var delegate: DemandTableViewCellDelegate!
//    fileprivate let cellOffset: CGFloat = 100
    @IBOutlet weak var demandBannerCollectionView: UICollectionView!
    var featuredVideos: [VideoModel]? {
        didSet{
            demandBannerCollectionView.reloadData()
            demandBannerCollectionView.backgroundColor = .clear
        }
    }
    var showVideos: [ShowDetailsModel]? {
        didSet{
            demandBannerCollectionView.reloadData()
            demandBannerCollectionView.backgroundColor = .clear
        }
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        demandBannerCollectionView.register(UINib(nibName: "OnDemandCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnDemandCollectionVC")
        demandBannerCollectionView.delegate = self
        demandBannerCollectionView.dataSource = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension DemandTableViewCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if videoType == "ShowDetails"{
            return showVideos?.count ?? 0
        }
        return featuredVideos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnDemandCollectionVC", for: indexPath as IndexPath) as! OnDemandCollectionViewCell
        cell.delegate = self
        if videoType == "ShowDetails"{
            cell.pageControl.isHidden = true
            cell.MoreInfoButton.isHidden = true
            cell.showItem = showVideos?[0]
        }
      else
        {
          cell.pageControl.numberOfPages = featuredVideos!.count
          cell.pageControl.currentPage = indexPath.row
          cell.pageControl.pageIndicatorTintColor = UIColor.white
          cell.pageControl.currentPageIndicatorTintColor = ThemeManager.currentTheme().ButtonBorderColor
          cell.fetauredItem = featuredVideos?[indexPath.row]

      }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if videoType == "ShowDetails"{
            let width = UIScreen.main.bounds.width - 400
            let height = (width * 3 / 8)
            return CGSize(width: width, height: height + 130)
        }
        let width = UIScreen.main.bounds.width - 100
        let height = (width * 3 / 8)
        return CGSize(width: width, height: height + 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension DemandTableViewCell:OnDemandCollectionViewCellDelegate{
    func didSelectPlayIcon(passModel: VideoModel?) {
        delegate.didSelectPlayIcon(passModel: passModel)
    }
    func didSelectMoreInfo(passModel: VideoModel?) {
        delegate.didSelectMoreInfo(passModel: passModel)
    }

}
