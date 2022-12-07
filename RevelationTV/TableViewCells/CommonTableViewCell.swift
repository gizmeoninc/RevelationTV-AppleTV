//
//  CommonTableViewCell.swift
//  tvOsSampleApp
//
//  Created by GIZMEON on 11/10/19.
//  Copyright © 2019 Firoze Moosakutty. All rights reserved.
//

import UIKit

protocol  CommonVideoTableViewCellDelegate:class {
    func didSelectFreeShows(passModel :VideoModel?)
    func didSelectNewArrivals(passModel :VideoModel?)
    func didSelectThemes(passModel :VideoModel?)
    func didSelectDianamicVideos(passModel :VideoModel?)
    func didSelectFilmOfTheDay(passModel :VideoModel?)

    func didSelectPartner(passModel :VideoModel?)
    func didFocusFilmOfTheDay(passModel :VideoModel)
    func didFocusNewArrivals(passModel :VideoModel)
    func didFocusThemes(passModel :VideoModel)
    func didFocusDianamicVideos(passModel :VideoModel)
    func didFocusPartner(passModel :VideoModel)
 
}
class CommonTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet fileprivate var mainCollectionView: UICollectionView!
    @IBOutlet weak var videoTypeLabel: UILabel!
//    let defaultSize = CGSize(width: 370, height: 250)
//    let focusedSize = CGSize(width: 400, height: 250)
    var videoType = ""
    weak var delegate: CommonVideoTableViewCellDelegate!
    fileprivate let cellOffset: CGFloat = 100
    var videoArray: [VideoModel]? {
        didSet{
            mainCollectionView.reloadData()
            mainCollectionView.backgroundColor = .clear
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        mainCollectionView.register(UINib(nibName: "PopularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularCollectionViewCell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        videoArray = []
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainCollectionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let width = (2 *  bounds.height - cellOffset) / 3
        let itemSize = CGSize(width: width, height: bounds.height - cellOffset)
        mainCollectionView.contentSize = CGSize(width: itemSize.width * CGFloat(videoArray!.count), height: bounds.height )
        (mainCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
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
        cell.backgroundColor = UIColor.black
        cell.layer.masksToBounds = true

        cell.layer.cornerRadius = 4
        cell.videoImageView.contentMode = .scaleToFill
        if videoType == "Film Of The Day" {
            if videoArray![indexPath.row].logo != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + videoArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
            }
            
        } else if videoType == "NewArrivals" {
            if videoArray![indexPath.row].logo != nil{
                cell.videoImageView.sd_setImage(with: URL(string: showUrl + videoArray![indexPath.row].logo!),placeholderImage:UIImage(named: "placeHolder"))

            }
            
        } else if videoType == "Now Streaming" {
            if videoArray![indexPath.row].logo != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((channelUrl + videoArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
             
            }else {
                cell.titleText = videoArray![indexPath.row].channel_name
                cell.videoImageView.image = UIImage(named: "lightGrey")
            }
        }
        else if videoType == "Partner"{
            if videoArray![indexPath.row].thumbnail != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((imageUrl + videoArray![indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
             
            }else {
                cell.titleText = videoArray![indexPath.row].video_title
                cell.videoImageView.image = UIImage(named: "lightGrey")
            }
        }
            else {
            if videoArray![indexPath.row].logo != nil {
                cell.videoImageView.sd_setImage(with: URL(string: ((showUrl + videoArray![indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder"))
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
       
        if let previousIndexPath = context.previouslyFocusedIndexPath ,
           let cell = mainCollectionView.cellForItem(at: previousIndexPath) {
            print("previousIndexPath")
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.shadowRadius = 0.0
            cell.contentView.layer.shadowOpacity = 0
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = mainCollectionView.cellForItem(at: indexPath) {
            print("nextFocusedIndexPath")
            cell.contentView.layer.borderWidth = 6.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
//            cell.contentView.layer.shadowColor = UIColor.white.cgColor
//            cell.contentView.layer.shadowRadius = 10.0
//            cell.contentView.layer.shadowOpacity = 0.9
            if videoType == "Film Of The Day" {
                delegate.didFocusFilmOfTheDay(passModel: videoArray![indexPath.item])
                
            } else if videoType == "NewArrivals"{
                
                
                delegate.didFocusNewArrivals(passModel: videoArray![indexPath.item])
                
            } else if videoType == "Now Streaming"{
                delegate.didFocusThemes(passModel: videoArray![indexPath.item])
                
            }
            else if videoType == "Partner"{
               delegate.didFocusPartner(passModel: videoArray![indexPath.item])
               
           }else {
                delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])
            }

        }
    }
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        super.didUpdateFocus(in: context, with: coordinator)
//
//
//        if let next = context.nextFocusedView as? PopularCollectionViewCell {
//
//            print(next)
//
//            if let indexPath = self.mainCollectionView.indexPath(for: next) {
//                print(indexPath)
//                if videoType == "FreeShows" {
//                    delegate.didFocusFreeShows(passModel: videoArray![indexPath.item])
//
//                } else if videoType == "NewArrivals"{
//
//
//                    delegate.didFocusNewArrivals(passModel: videoArray![indexPath.item])
//
//                } else if videoType == "Themes"{
//                    delegate.didFocusThemes(passModel: videoArray![indexPath.item])
//
//                } else {
//                    delegate.didFocusDianamicVideos(passModel: videoArray![indexPath.item])
//                }
//            }
//
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if videoType == "Film Of The Day" {
            delegate.didSelectFilmOfTheDay(passModel: videoArray![indexPath.item])
            
        } else if videoType == "NewArrivals"{
            delegate.didSelectNewArrivals(passModel: videoArray![indexPath.item])
            
        } else if videoType == "Now Streaming"{
            delegate.didSelectThemes(passModel: videoArray![indexPath.item])
            
        }else if videoType == "Partner"{
            delegate.didSelectPartner(passModel: videoArray![indexPath.item])
            
        }  else {
            delegate.didSelectDianamicVideos(passModel: videoArray![indexPath.item])
        }
    }
    
}

extension CommonTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 25, bottom: cellOffset / 2, right: cellOffset/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellOffset/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellOffset/2
    }
}

