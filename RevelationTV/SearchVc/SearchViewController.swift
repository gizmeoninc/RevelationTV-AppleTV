//
//  SearchViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 30/11/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import CoreData

class HomeSearchViewController: UIViewController,UISearchControllerDelegate {


    @IBOutlet weak var NoResultView: UIView!
    
    @IBOutlet weak var NoResultLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    var searchArray = [showByCategoryModel]()
    var type = ""
    var keyboardHeight = CGFloat()
    var serchHistoryArray = [String]()
    var serchHistoryArrayReverse = [String]()
    var channelSearchHistoryArray = [String]()
    var channelSearchHistoryArrayReverse = [String]()
    var searchListView = UIView()
    var searchString = ""
    var categoryId = ""
    var liveflag = ""
    private var myLabel : UILabel!
    fileprivate let rowHeight = UIScreen.main.bounds.height * 0.3
    let reachability = try! Reachability()
    override func viewDidLoad() {
        print("viewDidLoad")
        //search tableview declaration
        let nibVideoList =  UINib(nibName: "HomeTableViewCell", bundle: nil)
        searchTableView.register(nibVideoList, forCellReuseIdentifier: "HomeTableCell")
        searchTableView.register(UINib(nibName:"CustomHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: CustomHeader.reuseIdentifier)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        view.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        searchTableView.contentInsetAdjustmentBehavior = .never
        //Initial view
        self.NoResultView.isHidden = false
        self.NoResultView.backgroundColor = ThemeManager.currentTheme().buttonColorDark
        self.NoResultLabel.text = "Search for TV shows , movies and categories"

        
        
        
        reachability.whenUnreachable = { _ in
            commonClass.showAlert(viewController:self, messages: "Network connection lost!")

            print("Not reachable")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
     
    }


    func setUpUI() {
       
       
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")

    }
   
    
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
    }
    
    
    // MARK: Api Calls
    @objc func getSearchResults(searchKeyword: String!) {
        print("getSearchResults")
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.getHomeSearchResults(searchText: searchKeyword, searchType: type , category: categoryId,liveflag:liveflag) { (responseDictionary: Dictionary) in
            self.searchArray.removeAll()
            if  responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    commonClass.stopActivityIndicator(onViewController: self)
                    self.NoResultView.isHidden = false
                    self.NoResultLabel.text = "Oops! Something went wrong,"
                    self.searchTableView.isHidden = true
                }
            } else {
                self.searchArray = responseDictionary["Channels"] as! [showByCategoryModel]
                print(self.searchArray.count)
                

                if self.searchArray.count == 0 {
                    print("response dictionory empty array = \(responseDictionary)")
                    DispatchQueue.main.async {
                        self.NoResultView.isHidden = false
                        self.searchTableView.isHidden = true
                        self.NoResultLabel.text = "No Results Found"
                        commonClass.stopActivityIndicator(onViewController: self)

                        
                    }
                } else {
                    print("response dictionory = \(responseDictionary)")
                    DispatchQueue.main.async {
                        commonClass.stopActivityIndicator(onViewController: self)
                        self.NoResultView.isHidden = true
                        self.searchTableView.isHidden = false
                        self.searchTableView.reloadData()
                       
                    }
                }
            }
        }
    }
}


extension HomeSearchViewController:UISearchResultsUpdating  {

  
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == ""{
            
        }
        else{
//            getSearchResults(searchKeyword: searchController.searchBar.text ?? "")
            
        }
       }

}
extension HomeSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("heloo")
        if let searchString = searchBar.text, !searchString.isEmpty {
            self.view.endEditing(true)
            searchBar.resignFirstResponder()
             if searchString.trimmingCharacters(in: .whitespaces) != "" {
                getSearchResults(searchKeyword:searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
              
            }
        }
  }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
        if let searchString = searchBar.text, !searchString.isEmpty {
            
                getSearchResults(searchKeyword:searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))
               
            }
        

    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")

    }
 
   
}

extension HomeSearchViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate  {
    func cellSelected() {
        print("called")
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchArray.count > 0{
            return  searchArray.count
        }
       return 0
        
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.backgroundColor = .clear
        cell.videoType = "Dianamic"
        cell.videoArray = searchArray[indexPath.section].shows
            return cell
        
       
        
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      return rowHeight

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = ThemeManager.currentTheme().headerTextColor
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: ThemeManager.currentTheme().fontBold, size: 40)
                titleLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: (rowHeight) * 0.2 - 20).integral
        titleLabel.text =  searchArray[section].category_name
        headerView.backgroundColor = .clear
        headerView.addSubview(titleLabel)
        return headerView
    }
  
}
extension HomeSearchViewController: HomeTableViewCellDelegate  {
    func didSelectDianamicVideosEpisode(passModel: VideoModel?) {
        
    }

    
    func didSelectDianamicVideos(passModel: VideoModel?) {
        if let passModel = passModel  {
            
            if passModel.video_id != nil{
                let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
                let id = Int(passModel.video_id!)
                episodeVC.video_Id = String(id)
                self.present(episodeVC, animated: true, completion: nil)
            }
            else{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
                let id = Int(passModel.show_id!)
                videoDetailView.show_Id = String(id)
                //                videoDetailView.fromCategories = false
                self.present(videoDetailView, animated: true, completion: nil)
            }
            
        }
        
        
        
    }
    
    func didFocusDianamicVideos(passModel: VideoModel) {
        
    }
    
    func didSelectFilmOfTheDay(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
   
    func didSelectPartner(passModel: VideoModel?) {
        print("hello")
    }
    func didFocusPartner(passModel: VideoModel) {
        print("hello")
    }
    func didSelectFreeShows(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
                videoDetailView.fromCategories = false
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    
    func didSelectNewArrivals(passModel: VideoModel?) {
        if let passModel = passModel  {
            print("cliocked new arrivals")
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "videoDetail") as! VideoDetailsViewController
            videoDetailView.videoItem = passModel
            videoDetailView.fromCategories =  false
            self.present(videoDetailView, animated: true, completion: nil)
        }
        
    }

    func didSelectThemes(passModel: VideoModel?) {
        if let passModel = passModel  {
            let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "LiveVC") as! LivePlayingViewController
            videoDetailView.channelVideo = passModel
            self.present(videoDetailView, animated: true, completion: nil)
        }
    }
    func didSelectsearchArray(passModel: VideoModel?) {
       
        if let passModel = passModel  {
            
            if passModel.video_id != nil{
                let episodeVC =  self.storyboard?.instantiateViewController(withIdentifier: "EpisodeDetailsVC") as! EpisodeViewController
                let id = Int(passModel.video_id!)
                episodeVC.video_Id = String(id)
                self.present(episodeVC, animated: true, completion: nil)
            }
            else{
                let videoDetailView =  self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsViewController
                let id = Int(passModel.show_id!)
                videoDetailView.show_Id = String(id)
    //                videoDetailView.fromCategories = false
                self.present(videoDetailView, animated: true, completion: nil)
            }
           
        }
    }
  
    func didFocusFilmOfTheDay() {
        self.setNeedsFocusUpdate()
//        self.updateFocusIfNeeded()
//        HomeTableView.setContentOffset(.zero, animated: true)

    }
    func didFocusNewArrivals(passModel: VideoModel) {
    }
    func didFocusThemes(passModel: VideoModel) {
    }
    func didFocussearchArray(passModel: VideoModel) {
    }
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> () {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
      print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
    }
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
