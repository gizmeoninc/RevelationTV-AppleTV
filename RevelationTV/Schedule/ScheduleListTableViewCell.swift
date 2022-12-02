//
//  ScheduleListTableViewCell.swift
//  KICCTV
//
//  Created by GIZMEON on 02/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

import UIKit
protocol ScheduleListTableViewCellDelegate:class {
    func didSelectOnDemand(passModel :VideoModel?)
    func didSelectReminder(passModel :VideoModel?)
    func didSelectEarlierShows()
}
class ScheduleListTableViewCell: UITableViewCell {
    @IBOutlet weak var filterButton: UIButton!{
        didSet{
            filterButton.setTitle("Earlier Shows", for: .normal)
            let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
            filterButton.setImage(image, for: .normal)
            filterButton.tintColor = UIColor.white
            filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            filterButton.layer.borderColor = ThemeManager.currentTheme().ButtonBorderColor.cgColor
            filterButton.layer.borderWidth = 3.0
            filterButton.titleLabel?.font =  UIFont(name:ThemeManager.currentTheme().fontRegular, size: 25)
            filterButton.titleLabel?.textColor = ThemeManager.currentTheme().buttonTextColor
            filterButton.layer.cornerRadius = 30
            filterButton.titleLabel?.textAlignment = .center
            filterButton.layer.masksToBounds = true
            filterButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        }
    }
//    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
//
//    @IBOutlet weak var filterView: UIView!{
//        didSet{
//            filterView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
//        }
//    }
    @IBOutlet weak var filterButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    @IBOutlet weak var dayListingCollectionView: UICollectionView!{
        didSet{
            dayListingCollectionView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var scheduleCollectionViewHeight: NSLayoutConstraint!
    var scheduleVideos: [VideoModel]? {
        didSet{
//            scheduleCollectionView.reloadData()
            scheduleCollectionView.backgroundColor = .clear
//            if scheduleVideos!.count>0{
//                self.allLiveVideos = scheduleVideos
//            }
            if onceFlag{
                self.getLiveGuide()
                onceFlag = false
            }
          
        }
    }
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    var allLiveVideos : [VideoModel]?
    var todayFeaturedVideos : [VideoModel]?

    weak var delegate: ScheduleListTableViewCellDelegate!
    var selectedIndex = 0
    var selectedFilter = 0
    var selectedDateArrayIndex = 0
    var selectedDateStringIndex = 0
    var dayArray = [String?]()
    var dateArray = [Date?]()
    var onceFlag = true
    var channelType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        //schedule list collectionview setup
        scheduleCollectionView.register(UINib(nibName: "SheduleListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ScheduleListCollectionCell")
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
        let widthnew =  (UIScreen.main.bounds.width/3)
        let height = ((widthnew)*9)/16
        self.scheduleCollectionViewHeight.constant = height + 90
        
        //day list collectionview setup
        dayListingCollectionView.register(UINib(nibName: "DayFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dayFilterCollectionCell")
        dayListingCollectionView.delegate = self
        dayListingCollectionView.dataSource = self
//        dayListingCollectionView.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        
        //call function to get day array from today(15 days)
        self.getWeekDays()
        self.gradientViewHeight.constant = self.scheduleCollectionViewHeight.constant + 90 + 80
        self.gradientView.setDianamicGradientBackground(colorTop: ThemeManager.currentTheme().viewBackgroundColor.withAlphaComponent(0.4), colorBottom: ThemeManager.currentTheme().buttonColorDark.withAlphaComponent(0.5), height: self.gradientViewHeight.constant)
        
        
      
      
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self.filterButton.isFocused {
            self.filterButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            self.filterButton.setTitleColor(UIColor.white, for: .focused)
                // handle focus appearance changes
            }
            else {
                self.filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark

                // handle unfocused appearance changes
            }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //
    func getWeekDays(){
        var calendar = Calendar.autoupdatingCurrent
        let today = calendar.startOfDay(for: Date())
        var days = [Date]()
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: today) {
                    days += [day]
                }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        for date in days {
            print(formatter.string(from: date))
            if date == today{
                self.dayArray.append("Today")
                let formattedDate = dateFormatter.string(from: date)
                let covertedDate  = dateFormatter.date(from: formattedDate)
                self.dateArray.append(covertedDate)

            }
            else{
                self.dayArray.append(formatter.string(from: date))
                let formattedDate = dateFormatter.string(from: date)
                let covertedDate = self.convertStringTimeToDate(item:formattedDate)
                self.dateArray.append(covertedDate)
            }
            
        }
        if self.dayArray.count != 0{
            DispatchQueue.main.async {
                self.dayListingCollectionView.reloadData()
//                self.getLiveGuide()
            }
                 }
        
        print(days)
    }
    func getLiveGuide() {
          print("getLiveGuide")
        let widthnew =  (UIScreen.main.bounds.width/3)
        let height = ((widthnew)*9)/16
        if channelType == "HomeSchedule"{
            self.filterButtonHeight.constant = 0
            self.scheduleCollectionViewHeight.constant = height + 90
        }
        else{
            self.filterButtonHeight.constant = 60
            self.scheduleCollectionViewHeight.constant = height + 150

        }
          ApiCommonClass.getLiveGuide { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
              DispatchQueue.main.async {
                DispatchQueue.main.async {
                }
              }
            } else {
              self.scheduleVideos?.removeAll()
                self.allLiveVideos?.removeAll()
               if let videos = responseDictionary["data"] as? [VideoModel]? {
                  self.scheduleVideos = videos
                  self.allLiveVideos = videos
                  if self.scheduleVideos?.count == 0 {
                }else{
                    DispatchQueue.main.async {
                        self.getListByFilterDay(date: self.dateArray[self.selectedDateArrayIndex]!, dateString: self.dayArray[self.selectedDateArrayIndex]!)
                    }
                }
              }
            }
          }
        }
    func getListByFilterDay(date:Date,dateString:String){
//        if let value = allLiveVideos?.filter({ Calendar.current.isDate(self.convertStringTimeToDate(item:$0.starttime!), inSameDayAs:date)}){
//            if value.count > 0{
//                self.scheduleVideos?.removeAll()
//                self.scheduleVideos = value
//                DispatchQueue.main.async {
//                    self.scheduleCollectionView.reloadData()
//                }
//            }
//
//        }
        if let value = allLiveVideos?.filter({ Calendar.current.isDate(self.convertStringTimeToDate(item:$0.starttime!), inSameDayAs:date)}){
            self.scheduleVideos?.removeAll()
            self.scheduleVideos = value
            if dateString == "Today"{
                self.todayFeaturedVideos = value
                print("top featured getListByFilterDay",self.todayFeaturedVideos?.count)
                if let array = self.todayFeaturedVideos?.filter({$0.status == "NOW_PLAYING"}){
                    if array.count > 0{
                        let endTime = array[0].endtime
                        let startTime = array[0].starttime
                        if let upcomingArray =  self.todayFeaturedVideos?.filter({endTime!<=$0.starttime!}){
                            self.scheduleVideos? = upcomingArray
                            DispatchQueue.main.async {
                                self.scheduleCollectionView.reloadData()
                            }
                            print("upcoming guide array",self.scheduleVideos?.count)
                        }
                        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime! <= startTime!}){
                            print("previous guide array",previousArray.count)
                        }
                    }
                    else{
                        setupUpcoming()
                    }
                    
                }
                else{
                    setupUpcoming()
                }
            }
            else{
                DispatchQueue.main.async {
                    self.scheduleCollectionView.reloadData()
                }
            }
        }
    }
    var upcomingFilterImageClicked = false

    @IBAction func filterAction(_ sender: Any) {
        if !upcomingFilterImageClicked{
            scheduleVideos?.removeAll()
            print("top featured getEarlierShows blue",self.todayFeaturedVideos?.count)
            if let array = self.todayFeaturedVideos?.filter({$0.status == "NOW_PLAYING"}){
                if array.count > 0{
                    let endTime = array[0].endtime
                    let startTime = array[0].starttime
                    if let upcomingArray =  self.todayFeaturedVideos?.filter({endTime!<=$0.starttime!}){
                        
                    }
                    if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime!<=startTime!}){
                        self.scheduleVideos? = previousArray
                        DispatchQueue.main.async {
                            self.scheduleCollectionView.reloadData()
                        }
                        print("previous guide array",previousArray.count)
                    }
                }
                else{
                    setupUpPreviusArray()
                }
            }
            else{
                setupUpPreviusArray()
            }
            let image = UIImage(named: "arrow-up")?.withRenderingMode(.alwaysTemplate)
            filterButton.setImage(image, for: .normal)
            filterButton.tintColor = UIColor.white
            filterButton.backgroundColor = ThemeManager.currentTheme().focusedColor
            let index = IndexPath(item: 0, section: 0)
            scheduleCollectionView.scrollToItem(at: index, at: .left, animated: true)
            delegate.didSelectEarlierShows()
           
        }
            else{
                print("top featured getEarlierShows black",self.todayFeaturedVideos?.count)

                if let array = self.todayFeaturedVideos?.filter({$0.status == "NOW_PLAYING"}){
                    if array.count > 0{
                        let endTime = array[0].endtime
                        let startTime = array[0].starttime
                        if let upcomingArray =  self.todayFeaturedVideos?.filter({endTime!<=$0.starttime!}){
                            self.scheduleVideos? = upcomingArray
                            DispatchQueue.main.async {
                                self.scheduleCollectionView.reloadData()
                            }
                            print("upcoming guide array",self.scheduleVideos?.count)
                        }
                        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime!<=startTime!}){
                            print("previous guide array",previousArray.count)
                        }
                    }
                    else{
                        self.setupUpcoming()
                    }
                }
                else{
                    self.setupUpcoming()
                }
                let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
                filterButton.setImage(image, for: .normal)
                filterButton.tintColor = UIColor.white
                filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
                let index = IndexPath(item: 0, section: 0)
                scheduleCollectionView.scrollToItem(at: index, at: .left, animated: true)
                delegate.didSelectEarlierShows()

//                filterIconImage.image = UIImage(named: "earlier_shows_icon_black")
            }
            upcomingFilterImageClicked = !upcomingFilterImageClicked
      
    }
    func setupUpcoming(){
        let currentTime =  Date()
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let currentDateString = df.string(from: currentTime)
        print("date formatted",currentDateString)
        if let upcomingArray =  self.todayFeaturedVideos?.filter({currentDateString < $0.starttime!}){
            self.scheduleVideos = upcomingArray
            self.scheduleCollectionView.reloadData()
        }
        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime! <= currentDateString}){
//             self.upcomingGuideArray = previousArray
        }
        
    }
    func setupUpPreviusArray(){
        let currentTime =  Date().localDate()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        df.timeZone = TimeZone(abbreviation: "UTC")
        let currentDateString = df.string(from: currentTime)
        print("date formatted",currentDateString)
        if let upcomingArray =  self.todayFeaturedVideos?.filter({currentDateString < $0.starttime!}){
            
        }
        if let previousArray =  self.todayFeaturedVideos?.filter({$0.endtime! <= currentDateString}){
            self.scheduleVideos = previousArray
            self.scheduleCollectionView.reloadData()
            print("previous guide array",previousArray.count)
        }
        
    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
    
   

}
extension ScheduleListTableViewCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == scheduleCollectionView{
            print("Schedulevideo cpunt",scheduleVideos?.count)
            return scheduleVideos?.count ?? 0
        }
        return dayArray.count
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        if collectionView == scheduleCollectionView{
            return false
        }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if collectionView == dayListingCollectionView{
            if let previousIndexPath = context.previouslyFocusedIndexPath ,
               let cell = dayListingCollectionView.cellForItem(at: previousIndexPath) {
                print("previousIndexPath")
                cell.contentView.layer.borderWidth = 0.0
                cell.contentView.layer.shadowRadius = 0.0
                cell.contentView.layer.shadowOpacity = 0
                cell.contentView.layer.cornerRadius = 0
            }

            if let indexPath = context.nextFocusedIndexPath,
               let cell = dayListingCollectionView.cellForItem(at: indexPath) {
                print("nextFocusedIndexPath")
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.borderColor = UIColor.white.cgColor
                cell.contentView.layer.cornerRadius = 28
               
            }
        }
       
       
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dayListingCollectionView{
            selectedDateArrayIndex = indexPath.row
           getListByFilterDay(date: dateArray[indexPath.item]!, dateString: dayArray[indexPath.item]!)
            //Need to fix crash when there is  no data at the first cell
            let index = IndexPath(item: 0, section: 0)
            scheduleCollectionView.scrollToItem(at: index, at: .left, animated: true)
            if let cell = collectionView.cellForItem(at: indexPath) as! DayFilterCollectionViewCell?{
                cell.backgroundColor = ThemeManager.currentTheme().focusedColor
            }
            if dayArray[indexPath.row] == "Today"{
                self.todayFeaturedVideos = scheduleVideos
                self.filterButton.isHidden = false
                getListByFilterDay(date: dateArray[indexPath.item]!, dateString: dayArray[indexPath.item]!)
                filterButton.backgroundColor = ThemeManager.currentTheme().focusedColor
                let image = UIImage(named: "drop-down-arrow")?.withRenderingMode(.alwaysTemplate)
                filterButton.setImage(image, for: .normal)
                filterButton.tintColor = UIColor.white
                filterButton.backgroundColor = ThemeManager.currentTheme().buttonColorDark
                upcomingFilterImageClicked = false
            }
            else{
                self.filterButton.isHidden = true
                getListByFilterDay(date: dateArray[indexPath.item]!, dateString: dayArray[indexPath.item]!)

            }


        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == scheduleCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleListCollectionCell", for: indexPath as IndexPath) as! SheduleListCollectionViewCell
            cell.backgroundColor = .clear
            cell.delegate = self
            cell.scheduleItem = scheduleVideos?[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFilterCollectionCell", for: indexPath as IndexPath) as! DayFilterCollectionViewCell
            cell.backgroundColor = ThemeManager.currentTheme().buttonColorDark
            cell.layer.cornerRadius = 28
            cell.layer.masksToBounds = true
            cell.dayItem = dayArray[indexPath.row]
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == scheduleCollectionView{
            if channelType == "HomeSchedule"{
                let width = (scheduleCollectionView.frame.width - ((scheduleCollectionView.frame.width)/3))
                let widthnew =  (UIScreen.main.bounds.width/3)
                let height = ((widthnew)*9)/16
                return CGSize(width: width + 100, height: height + 90)
            }
            else{
                let width = (scheduleCollectionView.frame.width - ((scheduleCollectionView.frame.width)/3))
                let widthnew =  (UIScreen.main.bounds.width/3)
                let height = ((widthnew)*9)/16
                return CGSize(width: width + 100, height: height + 150)
            }
            
            
        }
        else{
            return CGSize(width: 200, height: 60)
        }
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
extension ScheduleListTableViewCell : SheduleListCollectionViewCellDelegate{
    func didSelectOnDemand(passModel: VideoModel?) {
        delegate.didSelectOnDemand(passModel: passModel)
    }
    
    func didSelectReminder(passModel: VideoModel?) {
        if UserDefaults.standard.string(forKey:"skiplogin_status") == "true" {
            delegate.didSelectReminder(passModel: passModel)
        }else{
            self.getLiveGuide()
            delegate.didSelectReminder(passModel: passModel)
        }
       
    }
    
    
}
