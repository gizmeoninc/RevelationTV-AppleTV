//
//  ShowDetailsModel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 18/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import Mapper

struct ShowDetailsModel: Mappable {
    let resolution : String?
    let show_id :Int?
    let audio_language_name  : String?
    let video_duration  : Int?
    let rating  : String?
    let director  : String?
    let show_cast  : String?
    let show_name  : String?
    let premium_flag:Int?
    let synopsis  : String?
    let thumbnail_350_200 : String?
    let video_title : String?
    let watchlist_flag : Int?
    let logo_thumb : String?
  var videos :[VideoModel]?
    var schedule :[ScheduleModel]?
    var rerun :[ScheduleModel]?
  var metadata : [VideoModel]?
  var categories : [categoriesModel]?
  var languages : [languagesModel]?

  init(map: Mapper) throws {
      show_name = map.optionalFrom("show_name")
      synopsis = map.optionalFrom("synopsis")
      video_title = map.optionalFrom("video_title")

      thumbnail_350_200 = map.optionalFrom("thumbnail_350_200")
    resolution = map.optionalFrom("resolution")
    video_duration = map.optionalFrom("video_duration")
    rating = map.optionalFrom("rating")
    audio_language_name = map.optionalFrom("audio_language_name")
    show_id = map.optionalFrom("show_id")
    director = map.optionalFrom("director")
    show_cast = map.optionalFrom("show_cast")
    premium_flag = map.optionalFrom("premium_flag")
      logo_thumb = map.optionalFrom("logo_thumb")

      
    metadata = map.optionalFrom("metadata")
    videos = map.optionalFrom("videos")
    categories = map.optionalFrom("categories")
    languages = map.optionalFrom("languages")
      watchlist_flag = map.optionalFrom("watchlist_flag")
      schedule = map.optionalFrom("schedule")
      rerun = map.optionalFrom("rerun")

  }
}
struct LikeWatchListModel: Mappable {
    let liked_flag : Int?
    let watchlist_flag : Int?

    // Implement this initializer
    init(map: Mapper) throws {
        liked_flag = map.optionalFrom("liked_flag")
        watchlist_flag = map.optionalFrom("watchlist_flag")
    }
}
struct VideoSubscriptionModel: Mappable {
    
    var subscription_name :String?
    var subscription_type_name :String?
    var subscription_type_id :Int?
    var video_id  :Int?
    var pub_id  :Int?
    var id  :Int?
    var subscription_id  :Int?
    var logo :String?
    var description : String?
    var symbol : String?
    var price : Double?
    var ios_keyword : String?
    
    init(map: Mapper) throws {
        
        id = map.optionalFrom("id")
        subscription_id = map.optionalFrom("subscription_id")
        pub_id = map.optionalFrom("pub_id")
        video_id = map.optionalFrom("video_id")
        subscription_name = map.optionalFrom("subscription_name")
        subscription_type_name = map.optionalFrom("subscription_type_name")
        subscription_type_id = map.optionalFrom("subscription_type_id")
        logo = map.optionalFrom("logo")
        description = map.optionalFrom("description")
        symbol = map.optionalFrom("symbol")
        price = map.optionalFrom("price")
        ios_keyword = map.optionalFrom("ios_keyword")
    }
}


