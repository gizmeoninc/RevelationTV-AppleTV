//
//  ReminderListingTableViewCell.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 17/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol ReminderListingTableViewCellDelegate:class {
    func didSelectOnDemand(passModel :VideoModel?)
    func didSelectReminder(passModel :VideoModel?)
}
class ReminderListingTableViewCell: UITableViewCell {
    @IBOutlet weak var scheduleCollectionView: UICollectionView!

    
    var scheduleVideos: [VideoModel]? {
        didSet{
            scheduleCollectionView.reloadData()
        }
    }
    weak var delegate: ReminderListingTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scheduleCollectionView.register(UINib(nibName: "SheduleListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScheduleListCollectionCell")
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
        scheduleCollectionView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ReminderListingTableViewCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleVideos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleListCollectionCell", for: indexPath as IndexPath) as! SheduleListCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            cell.delegate = self
            cell.scheduleItem = scheduleVideos?[indexPath.row]
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (scheduleCollectionView.frame.width - ((scheduleCollectionView.frame.width)/3))
        let widthnew =  (UIScreen.main.bounds.width/3)
        let height = ((widthnew)*9)/16
        return CGSize(width: width + 100, height: height + 100 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom:0, right:0)
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 50
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
}
extension ReminderListingTableViewCell : SheduleListCollectionViewCellDelegate{
    func didSelectOnDemand(passModel: VideoModel?) {
        delegate.didSelectOnDemand(passModel: passModel)
    }
    
    func didSelectReminder(passModel: VideoModel?) {
        delegate.didSelectReminder(passModel: passModel)
        
    }
    
    
}


    
    


