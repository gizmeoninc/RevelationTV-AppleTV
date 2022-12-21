//
//  HomeTableview.swift
//  Justwatchme
//
//  Created by GIZMEON on 26/08/21.
//  Copyright © 2021 Firoze Moosakutty. All rights reserved.
//

import Foundation
import UIKit

protocol  HomeTableViewCellDelegate:class {
    func didSelectFreeShows(passModel :VideoModel?)
    func didSelectNewArrivals(passModel :VideoModel?)
    func didSelectThemes(passModel :VideoModel?)
    func didSelectDianamicVideos(passModel :VideoModel?)
    func didSelectFilmOfTheDay(passModel :VideoModel?)
    func didSelectDianamicVideosEpisode(passModel :VideoModel?)
    
    func didSelectPartner(passModel :VideoModel?)
    func didFocusFilmOfTheDay()
    func didFocusNewArrivals(passModel :VideoModel)
    func didFocusThemes(passModel :VideoModel)
    func didFocusDianamicVideos(passModel :VideoModel)
    func didFocusPartner(passModel :VideoModel)
 
}
class HomeTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet fileprivate var mainCollectionView: UICollectionView!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var iconImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var iconImageWidth: NSLayoutConstraint!
    @IBOutlet weak var leftArrowIcon: UIImageView!{
        didSet{
            leftArrowIcon.tintColor = .red
        }
    }
    
    @IBOutlet weak var moreIconButton: UIButton!{
        didSet{
            moreIconButton.setImage(UIImage(named: "moreButtonUnfocused"), for: .normal)
        }
    }
    
    @IBAction func moreIconButtonAction(_ sender: Any) {
//        delegate?.customHeader(self, didTapButtonInSection: sectionNumber)
//        let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
//        videoDetailView.videoItem = filmVideos[0]
//            videoDetailView.fromCategories = false
//        self.present(videoDetailView, animated: true, completion: nil)

    }

    @IBOutlet weak var rightArrowIcon: UIImageView!{
        didSet{
            rightArrowIcon.tintColor = .red
        }
    }
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var videoTypeLabel: UILabel!
//    let defaultSize = CGSize(width: 370, height: 250)
//    let focusedSize = CGSize(width: 400, height: 250)
    var videoType = ""
    weak var delegate: HomeTableViewCellDelegate!
    var sectionNumber: Int!
    fileprivate let cellOffset: CGFloat = 100
    var videoArray: [VideoModel]? {
        didSet{
            mainCollectionView.reloadData()
            mainCollectionView.backgroundColor = .clear
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        mainCollectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularCollectionViewCell")
        mainCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0)
        
        videoArray = []
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if self.moreIconButton.isFocused{
            self.moreIconButton.backgroundColor = .clear
            self.moreIconButton.setImage(UIImage(named: "moreButtonFocused"), for: .normal)
            self.moreIconButton.tintColor = ThemeManager.currentTheme().buttonTextColor
        }
        else{
            self.moreIconButton.setImage( UIImage(named: "moreButtonUnfocused"), for: .normal)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainCollectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        
//        let width = (2 *  bounds.height - cellOffset) / 3
//        let itemSize = CGSize(width: width, height: bounds.height - cellOffset)
//        mainCollectionView.contentSize = CGSize(width: itemSize.width * CGFloat(videoArray!.count), height: bounds.height )
//        (mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
   
   
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return videoArray!.count

       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell", for: indexPath as IndexPath) as! PopularCollectionViewCell
//        cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        cell.contentView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor

        cell.videoImageView.contentMode = .scaleToFill
        if videoArray![indexPath.row].type == "CONTINUE_WATCHING"  {
             if videoArray![indexPath.row].logo_thumb != nil {
                 cell.videoImageView.sd_setImage(with: URL(string: (( videoArray![indexPath.row].logo_thumb!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
             }
             else{
                 cell.videoImageView.image = UIImage(named: "placeHolder")
                 
             }
             if videoArray![indexPath.row].show_name != nil {
                 
                 cell.nameLabel.text = videoArray![indexPath.row].show_name
             }
             else{
                 cell.nameLabel.text = ""
             }
             cell.liveLabel.isHidden = true
             cell.timeLabel.isHidden = true
            cell.progressBar.isHidden = false
            if videoArray![indexPath.row].watched_percentage != 0{
                    let duration = Float((videoArray![indexPath.row].watched_percentage)!) / 100
                  cell.progressBar.setProgress(duration, animated: false)
            }
                  
           
        }
       
        else {

            if  videoArray![indexPath.row].logo_thumb != nil {
                let image =  videoArray![indexPath.row].logo_thumb
                if image!.starts(with: "https"){
                    cell.videoImageView.sd_setImage(with: URL(string: ((videoArray![indexPath.row].logo_thumb)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    
                }
                else{
                    cell.videoImageView.sd_setImage(with: URL(string: showUrl + (videoArray![indexPath.row].logo_thumb!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    print("url",showUrl + (videoArray![indexPath.row].logo_thumb!))
                }
                
            }
            if  videoArray![indexPath.row].thumbnail_350_200 != nil {
                let image =  videoArray![indexPath.row].thumbnail_350_200
                if image!.starts(with: "https"){
                    cell.videoImageView.sd_setImage(with: URL(string: ((videoArray![indexPath.row].thumbnail_350_200)!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                    
                }
                else{
                    cell.videoImageView.sd_setImage(with: URL(string: showUrl + (videoArray![indexPath.row].thumbnail_350_200!)),placeholderImage:UIImage(named: "landscape_placeholder"))
                }
                
            }
            if videoArray![indexPath.row].show_name != nil {
                
                cell.nameLabel.text = videoArray![indexPath.row].show_name
            }
            else if  videoArray![indexPath.row].video_title != nil {
                
                cell.nameLabel.text = videoArray![indexPath.row].video_title
            }
            else{
                cell.nameLabel.text = ""
            }
            cell.liveLabel.isHidden = true
            cell.timeLabel.isHidden = true
            cell.progressBar.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

        if let previousIndexPath = context.previouslyFocusedIndexPath ,
           let cell = mainCollectionView.cellForItem(at: previousIndexPath) {
            print("previousIndexPath")
           
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = mainCollectionView.cellForItem(at: indexPath) {
            print("nextFocusedIndexPath")
           
             if videoType == "NewArrivals"{
                delegate.didFocusNewArrivals(passModel: videoArray![indexPath.item])
                
            } else if videoType == "Now Streaming"{
                delegate.didFocusThemes(passModel: videoArray![indexPath.item])
                
            }
            else if videoType == "Free Shows"{
               delegate.didFocusPartner(passModel: videoArray![indexPath.item])
               
           }else {
                delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])
            }
                delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if videoType == "NewArrivals"{
            delegate.didSelectNewArrivals(passModel: videoArray![indexPath.item])
            
        } else if videoType == "Now Streaming"{
            delegate.didSelectThemes(passModel: videoArray![indexPath.item])
            
        }else if videoArray![indexPath.row].type == "CONTINUE_WATCHING"{
            delegate.didSelectFreeShows(passModel: videoArray![indexPath.item])
            
        }  else {
            if self.TitleLabel.text == "Shows"{
                delegate.didSelectDianamicVideos(passModel: videoArray![indexPath.item])
            }
            else{
                delegate.didSelectDianamicVideosEpisode(passModel: videoArray![indexPath.item])
            }
        }
    }
    
}

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if videoType == "Film Of The Day" {
            return UIEdgeInsets(top: 0, left: 0, bottom:0, right:0)

        }
        else if videoType == "FilmOfTheDayList"{
            return UIEdgeInsets(top: 20, left: 30, bottom:30, right:20)

        }
        else{
            return UIEdgeInsets(top: 0, left: 0, bottom:0, right:0)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if videoType == "Film Of The Day" {
            return 0
        }
        else if videoType == "FilmOfTheDayList"{
            return 100

        }
        else{
            return 20

        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if videoType == "Film Of The Day" {
            return 0
        }
        else if videoType == "FilmOfTheDayList"{
            return 20

        }
        else{
            return 30

        }
    }
//    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if videoType == "Film Of The Day" {
            return CGSize(width: bounds.width, height: bounds.height)

        }
        else if videoType == "FilmOfTheDayList"{
            let width =  bounds.width / 6
            let height = (3 * width) / 4
            return CGSize(width: width, height: height)
        }
        else{
//            let width =  bounds.width / 4.5
            let width =  (UIScreen.main.bounds.width/4.5)
//            let height = (9 * width) / 16 + 30
            let height = ((width) * 9)/16
            return CGSize(width: width - 60, height: height + 38)
//            let width = (2 *  bounds.height - cellOffset) / 3
//            let itemSize = CGSize(width: width, height: bounds.height - cellOffset)
//            return CGSize(width: width, height: bounds.height)
        }
    }
}

