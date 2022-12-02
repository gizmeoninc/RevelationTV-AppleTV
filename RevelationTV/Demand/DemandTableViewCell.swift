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
            self.pageControl.numberOfPages = featuredVideos!.count
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!{
        didSet{
//            pageControl.backgroundColor = UIColor.white.withAlphaComponent(0.8)
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
        return featuredVideos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnDemandCollectionVC", for: indexPath as IndexPath) as! OnDemandCollectionViewCell
        cell.delegate = self
        cell.fetauredItem = featuredVideos?[indexPath.row]
        cell.fetauredItem = featuredVideos?[indexPath.row]
        cell.pageControl.numberOfPages = featuredVideos!.count
        cell.pageControl.currentPage = indexPath.row
        cell.pageControl.pageIndicatorTintColor = UIColor.white
//        cell.backgroundColor = .red
//        ThemeManager.currentTheme().buttonColorDark
//        cell.pageControl.currentPageIndicatorImage(forPage: indexPath.row) {
//            return UIImage(named: "watchLiveRing")
//        }
        cell.pageControl.currentPageIndicatorTintColor = ThemeManager.currentTheme().ButtonBorderColor
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = UIScreen.main.bounds.width - 100
//        let height = (UIScreen.main.bounds.height - ((UIScreen.main.bounds.height)/3))
        let width = UIScreen.main.bounds.width - 100
        let height = (width * 3 / 8)
        return CGSize(width: width, height: height + 180)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 50, bottom:0, right:50)
//    }
////
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
//    func didSelectWatchlist(passModel: VideoModel?) {
//        delegate.didSelectWatchlist(passModel: passModel)
//        print("alert for watchlist added")
//    }
}
