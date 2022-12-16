//
//  VideoDetailsScheduleTableViewCell.swift
//  RevelationTV
//
//  Created by sinitha sidharthan on 15/12/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit

class VideoDetailsScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seperatorLine: UIView!
    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    var scheduleListArray: ScheduleModel? {
        didSet{
            scheduleCollectionView.reloadData()
            
            self.layoutIfNeeded()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scheduleCollectionView.register(UINib(nibName: "VideoDetailsScheduleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoScheduleCollectionCell")
        self.scheduleCollectionView.showsHorizontalScrollIndicator = false
        self.scheduleCollectionView.register(channelHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "channelHeader")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.invalidateLayout()
        self.scheduleCollectionView.collectionViewLayout = layout
        self.scheduleCollectionView.delegate = self
        self.scheduleCollectionView.dataSource = self
        self.scheduleCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
    extension VideoDetailsScheduleTableViewCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return scheduleListArray?.times?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoScheduleCollectionCell", for: indexPath as IndexPath) as! VideoDetailsScheduleCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark;
            cell.ScheduleTimeLabel.text = scheduleListArray?.times?[indexPath.row]
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100 , height: 30)
        }
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
                                                                            "channelHeader", for: indexPath) as! channelHeader
            header.title.text = "\(scheduleListArray?.weekday ?? "Mon") "+"  - "
            header.title.textColor = ThemeManager.currentTheme().descriptionTextColor
            header.title.font =  UIFont(name: ThemeManager.currentTheme().fontRegular, size: 20)
            header.configure()
            return header
            
        }
        
          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
              return CGSize(width: 110, height: 30)
          }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
        func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
            return false
        }
    }


