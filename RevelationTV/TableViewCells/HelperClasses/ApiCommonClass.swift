//
//  ApiCommonClass.swift
//  AlimonySwift
//
//  Created by Firoze Moosakutty on 09/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures
import Result

public class ApiCommonClass {
    
    static func getPubId()  -> Future<Void, NoError> {
        return Future { complete in
            var parameterDictionary: [String: String] = [ : ]
            parameterDictionary["app_publisher_bundle_id"] = Application.shared.app_bundle_id
            parameterDictionary["app_key"] = Application.shared.app_key
            let getPubUrl = ApiRESTUrlString().getPubID(parameterDictionary: parameterDictionary)
            AF.request(getPubUrl!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["Content-Type":"application/json"])
              .responseJSON{ (response) in
                switch(response.result) {
                case .success(let value):
                  let responseDict = value as! [String: Any]
                  guard let publisherId = responseDict["pubid"] as? Int else {
                    return
                  }
                    guard let channelid = responseDict["channelid"] as? Int else {
                        return
                      }
                    print("channelid",channelid)
                    print("publisherId",publisherId)
                    
                   
                  guard let registration_mandatory_flag = responseDict["registration_mandatory_flag"] as? Bool else {
                    return
                  }
                  guard let subscription_mandatory_flag = responseDict["subscription_mandatory_flag"] as? Int else {
                    return
                  }
                   
                  UserDefaults.standard.set(publisherId, forKey: "pubid")
                    UserDefaults.standard.set(channelid, forKey: "channelid")
                  UserDefaults.standard.set(registration_mandatory_flag, forKey: "registration_mandatory_flag")
                  UserDefaults.standard.set(subscription_mandatory_flag, forKey: "subscription_mandatory_flag")

                  print(publisherId)
                  print("subscription_mandatory_flag",subscription_mandatory_flag)
                  complete(.success(()))
                  break
                case .failure(let error):
                  print(error)
                
//
                  complete(.success(()))
                  break
                }
            }
        }
    }
    
    static func getPubid1(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()

        var parameterDict: [String: String?] = [ : ]
        parameterDict["app_publisher_bundle_id"] = Application.shared.app_bundle_id
        parameterDict["app_key"] = Application.shared.app_key
        if let getTokenApi = ApiRESTUrlString().getPubID(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: Any]

                        guard let publisherId = responseDict["pubid"] as? Int else {
                          return
                        }
                          guard let channelid = responseDict["channelid"] as? Int else {
                              return
                            }
                          print("channelid",channelid)
                          print("publisherId",publisherId)
                          
                         
                        guard let registration_mandatory_flag = responseDict["registration_mandatory_flag"] as? Bool else {
                          return
                        }
                        guard let subscription_mandatory_flag = responseDict["subscription_mandatory_flag"] as? Int else {
                          return
                        }
                         
                        UserDefaults.standard.set(publisherId, forKey: "pubid")
                          UserDefaults.standard.set(channelid, forKey: "channelid")
                        UserDefaults.standard.set(registration_mandatory_flag, forKey: "registration_mandatory_flag")
                        UserDefaults.standard.set(subscription_mandatory_flag, forKey: "subscription_mandatory_flag")

                        print(publisherId)
                        print("subscription_mandatory_flag",subscription_mandatory_flag)
                        channelResponse =  [:]

                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        print(error)
                        break
                    }
            }
            
        }
    }
    
  
    static func getToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UserDefaults.standard.string(forKey:"fcmToken") != nil {
            parameterDict["fcmToken"] = UserDefaults.standard.string(forKey:"fcmToken")
        } else {
            parameterDict["fcmToken"] = ""
        }
        parameterDict["device_type"] = "apple-tv"
        parameterDict["app_bundle_id"] = Application.shared.app_bundle_id
        parameterDict["app_key"] = Application.shared.app_key
        if let getTokenApi = ApiRESTUrlString().getToken(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDictionary = value as! [String: AnyObject]
                        var channelResponse = Dictionary<String, AnyObject>()
                        if  responseDictionary["message"] as? String  == "authentication done " {
                            if responseDictionary["pubid"] as? String != "" {
                                if let pubid = responseDictionary["pubid"] as? Int {
                                    Application.shared.publisherId = pubid
                                }
                            }
                            if let accessToken = responseDictionary ["token"] as? String {
                                Application.shared.accessToken = accessToken
                                UserDefaults.standard.set(accessToken, forKey: "access_token")

                            }
                            if let app_id = responseDictionary["app_id"] as? String {
                              UserDefaults.standard.set(app_id, forKey: "app_id")
                                print("app_id",app_id)
                               
                            }
                            if let application_id = responseDictionary["application_id"] as? Int {
                              UserDefaults.standard.set(application_id, forKey: "application_id")
                            }

                            if let banner_id = responseDictionary["banner_id"] as? String{
                              UserDefaults.standard.set(banner_id, forKey: "banner_id")
                            }

                            if let rewarded_id = responseDictionary["rewarded_id"] as? String {
                              UserDefaults.standard.set(rewarded_id, forKey: "rewarded_id")
                            }

                            if let interstitial_id = responseDictionary["interstitial_id"] as? String{
                              UserDefaults.standard.set(interstitial_id, forKey: "interstitial_id")
                            }
                            if let interstitial_status = responseDictionary["interstitial_status"] as? String{
                              UserDefaults.standard.set(interstitial_status, forKey: "interstitial_status")
                            }

                            if let mobpub_interstitial_status = responseDictionary["mobpub_interstitial_status"] as? String {
                              UserDefaults.standard.set(mobpub_interstitial_status, forKey: "mobpub_interstitial_status")
                            }

                            if let mobpub_interstitial_id = responseDictionary["mobpub_interstitial_id"] as? String {
                              UserDefaults.standard.set(mobpub_interstitial_id, forKey: "mobpub_interstitial_id")
                            }

                            if let mobpub_banner_id = responseDictionary["mobpub_banner_id"] as? String {
                              UserDefaults.standard.set(mobpub_banner_id, forKey: "mobpub_banner_id")
                            }
                            channelResponse =  [:]
                        } else {
                            channelResponse["error"] = responseDictionary["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                    }
            }
            
        }
    }
    
    
    static func Register(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        AF.request(RegisterApi, method: .post, parameters: parameterDictionary!, headers:  ["Content-Type":"application/json"])
            .responseJSON{ (response) in
                switch(response.result) {
                case .success(let value):
                    let responseDict = value as! [String: AnyObject]
                    var registerDict = Dictionary<String, AnyObject>()
                    if let dataDict = responseDict["data"] as? NSArray {
                        registerDict = (dataDict[0] as? [String: AnyObject])!
                        callback(registerDict)
                    }else {
                        print(responseDict)
                        let val = responseDict["message"]
                        print(val)
                        registerDict["error"] = val!
                        callback(registerDict)
                    }
                    
                    break
                    
                case .failure(let error):
                    
                    print(error)
                    break
                    
                }
        }
    }
    static func getGustUserId(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      ApiCallManager.apiCallREST(mainUrl: GetGustUserLogin, httpMethod: "POST", headers: ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: JSONData) { (responseDictionary: Dictionary) in
          var channelResponseArray = [VideoModel]()
          var channelResponse = Dictionary<String, AnyObject>()
          if let status: Int = responseDictionary["success"] as? Int, status == 1 {
              let dataArray = responseDictionary["user_id"] as! NSNumber
              channelResponse["Channels"] = dataArray as AnyObject
              
          } else {
              channelResponse["error"] = "An error occurred, please try again later" as AnyObject
          }
          callback(channelResponse)
      }
    }

    
    static func Login(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {

        
        
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
         var responseMessage = String()

            if let getUrl = ApiRESTUrlString().Login(parameterDictionary: parameterDictionary) {
                var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
                mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
                mutableURLRequest.httpMethod = "GET"
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.allHTTPHeaderFields = ["country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
                AF.request(mutableURLRequest).validate().responseJSON{ response in
                    switch(response.result) {
                   
                    case .success(let value):
                     var channelResponseArray = [VideoModel]()
                     var channelResponse = Dictionary<String, AnyObject>()
                        let responseDict = value as! [String: AnyObject]
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                     guard let statuscode = response.response?.statusCode else {
                         return
                     }
                     if statuscode == 200{
                         // Create a user!
                         let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                         for videoItem in dataArray {
                             let JSON: NSDictionary = videoItem as NSDictionary
                             let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                             channelResponseArray.append(videoModel)
                         }
                         channelResponse["Channels"]=channelResponseArray as AnyObject
                     }
                     else if  statuscode == 201 {
                         let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                         for videoItem in dataArray {
                             let JSON: NSDictionary = videoItem as NSDictionary
                             let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                             let userid = videoModel.user_id!
                             let userId = String(userid)
                             channelResponseArray.append(videoModel)
                             responseMessage = "Please verify your email"
                             channelResponse["user_id"] = userId as AnyObject
                             channelResponse["error"] = responseMessage as AnyObject
                             
                             
                         }
                        
                         
                         
                     }
                     else if statuscode == 202 {
                         responseMessage = "Invalid Credentials"
                         channelResponse["error"] = responseMessage as AnyObject
                     } else if statuscode == 203 {
                         responseMessage = "You have exceeded no of users. Please logout from existing device to access."
                         channelResponse["error"] = responseMessage as AnyObject
                     } else {
                         responseMessage = "Internal Server Error"
                         channelResponse["error"] = responseMessage as AnyObject
                     }
                     
                     callback(channelResponse)
                        break
                    case .failure:
//                           completion(false)
                        break
                    }
                }
            }
        
    }
    static func getAccountDetails(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
      let userAgent = UserDefaults.standard.string(forKey:"userAgent")
      let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      var parameterDict: [String: String?] = [ : ]
        var channelResponseArray = [VideoModel]()
        var channelResponse = Dictionary<String, AnyObject>()
        if let getTokenApi = ApiRESTUrlString().getAccountDetails(parameterDictionary: parameterDictionary) {
            AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
            .responseJSON{ (response) in
              switch(response.result) {
              case .success(let value):
                let responseDict = value as! [String: AnyObject]
                guard let status = responseDict["success"] as? NSNumber  else {
                  return
                }
                if status == 1 {
                    let dataArray = responseDict["data"] as! Dictionary<String, Any>
                    channelResponse["data"]=dataArray as AnyObject
                  callback(channelResponse)
                } else {
                  channelResponse["error"] = responseDict["message"]
                }
                  
                  
                break
              case .failure(let error):
                channelResponse["error"] = error as AnyObject
                callback(channelResponse)
                break
              }
          }
        }

      
    }
    static func ForgotPassword(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
      let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
      let loginApi = ApiRESTUrlString().ForgotPassword(parameterDictionary: parameterDictionary)
      
      ApiCallManager.apiCallREST(mainUrl: loginApi!, httpMethod: "GET", headers: ["country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status = responseDictionary["success"] as? NSNumber  else {
          return
        }
        if status == 1 {
          // Create a user!
          let dataArray = responseDictionary["message"]
          channelResponse["Channels"]=dataArray
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }

        callback(channelResponse)
      }
    }
    static func getUserSubscriptions(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getUserSubscriptions(parameterDictionary: nil) {
            AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [SubscriptionModel]()
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: SubscriptionModel = SubscriptionModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
      }
    }
  }
    static func getLiveGuide(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UserDefaults.standard.string(forKey:"channelid") == nil{
            parameterDict["channel_id"] = "371"
        }
        else{
            parameterDict["channel_id"] = UserDefaults.standard.string(forKey:"channelid")
        }
        if let getTokenApi = ApiRESTUrlString().getLiveGuide(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
            mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
            mutableURLRequest.httpMethod = "GET"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
            AF.request(mutableURLRequest).validate().responseJSON{ response in
                switch(response.result) {
                case .success(let value):
                    let responseDict = value as! [String: AnyObject]
                    var channelResponseArray = [VideoModel]()
                    guard let status = responseDict["success"] as? NSNumber  else {
                        return
                    }
                    if status == 1 {
                        let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                        for videoItem in dataArray {
                            let JSON: NSDictionary = videoItem as NSDictionary
                            let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                            channelResponseArray.append(videoModel)
                        }
                        channelResponse["data"] = channelResponseArray as AnyObject
                    } else {
                        channelResponse["error"] = responseDict["message"]
                    }
                    callback(channelResponse)
                    break
                case .failure(let error):
                    channelResponse["error"] = error as AnyObject
                    callback(channelResponse)
                    break
                }
            }
        }
    }
    static func subscriptionTransaction(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let JSONData = try?  JSONSerialization.data(
            withJSONObject: parameterDictionary,
            options: []
        )
        
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        ApiCallManager.apiCallREST(mainUrl: SubscriptionTransaction, httpMethod: "POST", headers: ["Content-Type":"application/json","access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: JSONData) { (responseDictionary: Dictionary) in
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status = responseDictionary["success"] as? NSNumber  else {
                return
            }
            if status == 1 {
                channelResponse["Channels"] = responseDictionary["success"]
                
            } else {
                channelResponse["error"] = responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getvideoSubscriptions(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let getSearchResultsApi = ApiRESTUrlString().getvideoSubscriptions(parameterDictionary: parameterDictionary)
        ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version], postData: nil) { (responseDictionary: Dictionary) in
            var channelResponseArray = [VideoSubscriptionModel]()
            var channelResponse = Dictionary<String, AnyObject>()
            guard let status: Int = responseDictionary["success"] as? Int else { return }
            if status == 1 {// Create a user!
                let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                    let JSON: NSDictionary = videoItem as NSDictionary
                    let videoModel: VideoSubscriptionModel = VideoSubscriptionModel.from(JSON)! // This is a 'User?'
                    channelResponseArray.append(videoModel)
                }
                
                channelResponse["Channels"]=channelResponseArray as AnyObject
            } else {
                channelResponse["error"]=responseDictionary["message"]
            }
            callback(channelResponse)
        }
    }
    static func getWatchList(callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var parameterDict: [String : String?] = [ : ]
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
     let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      let getWatchList = ApiRESTUrlString().getWatchlist(parameterDictionary: (parameterDict as! Dictionary<String, String>))
        
      ApiCallManager.apiCallREST(mainUrl: getWatchList!, httpMethod: "GET", headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponseArray = [showByCategoryModel]()
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status = responseDictionary["success"] as? NSNumber else { return }
        if status == 1 {// Create a user!
          let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
          for videoItem in dataArray {
            let JSON: NSDictionary = videoItem as NSDictionary
            let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)! // This is a 'User?'
            channelResponseArray.append(videoModel)
          }

          channelResponse["data"]=channelResponseArray as AnyObject
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
    static func LoginFromMobile(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        let url = LoginFromMobileApi + parameterDictionary["code"]!
print("registerMobile",url)
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      ApiCallManager.apiCallREST(mainUrl: url, httpMethod: "POST", headers: ["Content-Type":"application/json","country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponseArray = [VideoModel]()
        var channelResponse = Dictionary<String, AnyObject>()
        if let status: Int = responseDictionary["success"] as? Int, status == 1 {
            let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
            }
            
            channelResponse["message"] = responseDictionary["message"]
            channelResponse["Channels"] = channelResponseArray as AnyObject
//                callback(channelResponse)
            //        for videoItem in dataArray {
  //          let JSON: NSDictionary = videoItem as NSDictionary
  //          let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
  //          channelResponseArray.append(videoModel)
  //        }
//          channelResponse["Channels"] = dataArray as AnyObject

        } else {
          channelResponse["error"] = responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
    static func getCategories(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      var parameterDict: [String: String?] = [ : ]
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
     let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      if let getTokenApi = ApiRESTUrlString().getCategories(parameterDictionary: parameterDict as? Dictionary<String, String>) {
        var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
        mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableURLRequest.httpMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        AF.request(mutableURLRequest).validate().responseJSON{ response in
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [VideoModel]()
            guard let status = responseDict["success"] as? NSNumber  else {
              return
            }
            if status == 1 {
              let dataArray = responseDict["categories"] as! [Dictionary<String, Any>]
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["categories"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
        }
      }
    }
      
    static func getHomeSearchResults(searchText: String!,searchType: String,category: String!,liveflag: String, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {

      var parameterDict: [String : String?] = [ : ]
      parameterDict["key"] = searchText
      parameterDict["type"] = searchType
      parameterDict["category"] = category
      parameterDict["liveflag"] = liveflag
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
     let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

  //    parameterDict["language"] = Application.shared.langugeIdList
      let getSearchResultsApi = ApiRESTUrlString().getHomeSearchResults(parameterDictionary: (parameterDict as! Dictionary<String, String>))
      ApiCallManager.apiCallREST(mainUrl: getSearchResultsApi!, httpMethod: "GET", headers: ["access-token": accesToken,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"uid":user_id,"ua":encodeduserAgent], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponseArray = [showByCategoryModel]()
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status = responseDictionary["success"] as? NSNumber else { return }
        if status == 1 {// Create a user!
          if searchType == "channel"{
            let dataArray = responseDictionary["channel_data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
          }else{

            let dataArray = responseDictionary["data"] as! [Dictionary<String, Any>]
            for videoItem in dataArray {
              let JSON: NSDictionary = videoItem as NSDictionary
              let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)! // This is a 'User?'
              channelResponseArray.append(videoModel)
            }
          }


          channelResponse["Channels"]=channelResponseArray as AnyObject
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
    static func getFreeShows(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
           
            if let getNewarrivalApi = ApiRESTUrlString().getFreeShows(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                AF.request(getNewarrivalApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                    .responseJSON{ (response) in
                        switch(response.result) {
                        case .success(let value):
                            let responseDict = value as! [String: AnyObject]
                            var channelResponseArray = [VideoModel]()
                            var channelResponse = Dictionary<String, AnyObject>()
                            guard let status = responseDict["success"] as? NSNumber  else {
                                return
                            }
                            if status == 1 {
                                // Create a user!
                                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                                for videoItem in dataArray {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                }
                                
                                channelResponse["data"]=channelResponseArray as AnyObject
                            } else {
                                channelResponse["error"]=responseDict["message"]
                            }
                            callback(channelResponse)
                            
                            break
                            
                        case .failure(let error):
                            
                            print(error)
                            break
                            
                        }
                }
            }
        
        
    }
    
    static func getThemes(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        
        var parameterDict: [String: String?] = [ : ]
        if let accesToken = Application.shared.accessToken {
            parameterDict["user_id"] = ""
            parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
            parameterDict["device_type"] = "apple-tv"
            parameterDict["pubid"] = UserDefaults.standard.string(forKey:"publisherId")
            if let getCategoryApi = ApiRESTUrlString().getThemes(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                AF.request(getCategoryApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken])
                    .responseJSON{ (response) in
                        switch(response.result) {
                        case .success(let value):
                            let responseDict = value as! [String: AnyObject]
                            var channelResponseArray = [VideoModel]()
                            var channelResponse = Dictionary<String, AnyObject>()
                            guard let status = responseDict["success"] as? NSNumber  else {
                                return
                            }
                            if status == 1 {
                                // Create a user!
                                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                                for videoItem in dataArray {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                }
                                
                                channelResponse["data"]=channelResponseArray as AnyObject
                            } else {
                                channelResponse["error"]=responseDict["message"]
                            }
                            callback(channelResponse)
                            
                            break
                            
                        case .failure(let error):
                            
                            print(error)
                            break
                        }
                }
                
            }
            
        }
    }
    
    static func getHomeNewArrivals(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
           
            if let getNewarrivalApi = ApiRESTUrlString().getHomeNewArrivals(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                AF.request(getNewarrivalApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                    .responseJSON{ (response) in
                        switch(response.result) {
                        case .success(let value):
                            let responseDict = value as! [String: AnyObject]
                            var channelResponseArray = [VideoModel]()
                            var channelResponse = Dictionary<String, AnyObject>()
                            guard let status = responseDict["success"] as? NSNumber  else {
                                return
                            }
                            if status == 1 {
                                // Create a user!
                                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                                for videoItem in dataArray {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                }
                                
                                channelResponse["data"]=channelResponseArray as AnyObject
                            } else {
                                channelResponse["error"]=responseDict["message"]
                            }
                            callback(channelResponse)
                            
                            break
                            
                        case .failure(let error):
                            
                            print(error)
                            break
                            
                        }
                }
            }
        
    }
    static func getFilmOfVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getDianamicApi = ApiRESTUrlString().getFilmOfTheDayVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            
            AF.request(getDianamicApi, method: .get, parameters: nil, headers:["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)!
                                channelResponseArray.append(videoModel)
                            }
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
        }
    }
    static func getDianamicHomeVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getDianamicApi = ApiRESTUrlString().getDianamicHomeVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            
            AF.request(getDianamicApi, method: .get, parameters: nil, headers:["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [showByCategoryModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)!
                                channelResponseArray.append(videoModel)
                            }
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
        }
    }
    static func GetonDemandVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getDianamicApi = ApiRESTUrlString().getonDemandVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            
            AF.request(getDianamicApi, method: .get, parameters: nil, headers:["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [showByCategoryModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)!
                                channelResponseArray.append(videoModel)
                            }
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
        }
    }
    static func getCactchUpList(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getDianamicApi = ApiRESTUrlString().getCactchUpList(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            
            AF.request(getDianamicApi, method: .get, parameters: nil, headers:["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [showByCategoryModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: showByCategoryModel = showByCategoryModel.from(JSON)!
                                channelResponseArray.append(videoModel)
                            }
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
        }
    }
    static func getFeaturedVideos(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getDianamicApi = ApiRESTUrlString().getFeaturedVideos(parameterDictionary: parameterDict as? Dictionary<String, String>) {
            
            AF.request(getDianamicApi, method: .get, parameters: nil, headers:["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                            for videoItem in dataArray {
                                let JSON: NSDictionary = videoItem as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)!
                                channelResponseArray.append(videoModel)
                            }
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
        }
    }
    static func getPartnerList(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
           
            if let getNewarrivalApi = ApiRESTUrlString().getPartnerList(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                AF.request(getNewarrivalApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                    .responseJSON{ (response) in
                        switch(response.result) {
                        case .success(let value):
                            let responseDict = value as! [String: AnyObject]
                            var channelResponseArray = [VideoModel]()
                            var channelResponse = Dictionary<String, AnyObject>()
//                            guard let status = responseDict["success"] as? NSNumber  else {
//                                return
//                            }
//                            if status == 1 {
                                // Create a user!
                                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                                for videoItem in dataArray {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                }
                                
                                channelResponse["data"]=channelResponseArray as AnyObject
//                            } else {
//                                channelResponse["error"]=responseDict["message"]
//                            }
                            callback(channelResponse)
                            
                            break
                            
                        case .failure(let error):
                            
                            print(error)
                            break
                            
                        }
                }
            }
        
    }
    static func getAllChannels(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        var parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
           
            if let getNewarrivalApi = ApiRESTUrlString().getAllChannels(parameterDictionary: parameterDict as? Dictionary<String, String>) {
                AF.request(getNewarrivalApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                    .responseJSON{ (response) in
                        switch(response.result) {
                        case .success(let value):
                            let responseDict = value as! [String: AnyObject]
                            var channelResponseArray = [VideoModel]()
                            var channelResponse = Dictionary<String, AnyObject>()
                            guard let status = responseDict["success"] as? NSNumber  else {
                                return
                            }
                            if status == 1 {
                                // Create a user!
                                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                                for videoItem in dataArray {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                }
                                
                                channelResponse["data"]=channelResponseArray as AnyObject
                            } else {
                                channelResponse["error"]=responseDict["message"]
                            }
                            callback(channelResponse)
                            
                            break
                            
                        case .failure(let error):
                            
                            print(error)
                            break
                            
                        }
                }
            }
        
    }
    static func Channelhome(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let parameterDict: [String: String?] = [ : ]
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                 if let getTokenApi = ApiRESTUrlString().getChannelhome(parameterDictionary: parameterDictionary) {
        AF.request(getTokenApi, method: .get, parameters: parameterDictionary,  headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
          .responseJSON{ (response) in
            switch(response.result) {
            case .success(let value):
              let responseDict = value as! [String: AnyObject]
              var channelResponseArray = [VideoModel]()
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                  let JSON: NSDictionary = videoItem as NSDictionary
                  let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                  channelResponseArray.append(videoModel)
                }
                channelResponse["data"] = channelResponseArray as AnyObject
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
        }
      }
    }
    static func generateLiveToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
      let parameterDict: [String: String?] = [ : ]
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let getLanguagesApi = ApiRESTUrlString().generateLiveToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
      ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status = responseDictionary["success"] as? NSNumber  else {
          return
        }
        if status == 1 {
          // Create a user!
          let dataArray = responseDictionary["data"]

          channelResponse["Channels"]=dataArray
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
    static func getPartnerByPartnerid(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
        let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getVideosApi = ApiRESTUrlString().GetPartnerByCategory(parameterDictionary: parameterDictionary){
            AF.request(getVideosApi, method: .get, parameters: parameterDictionary, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                     
                        let responseDict = value as! [String: AnyObject]
                        if responseDict["err"] != nil{
                          channelResponse["error"] = "no value" as AnyObject
                        }
                        else{
                        let dataArray = responseDict["data"] as! NSDictionary

                        var channelResponseArray = [VideoModel]()
                       
                        let categories = dataArray["shows"] as! [Dictionary<String, Any>]
                      
                        
                        if !categories.isEmpty {
            //                        let dataArray1 = param["videos"] as! [Dictionary<String, Any>]
                                  for videoItem in categories {
                                    let JSON: NSDictionary = videoItem as NSDictionary
                                    let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                    channelResponseArray.append(videoModel)
                                  }
                          
                                  channelResponse["data"] = channelResponseArray as AnyObject
                               if dataArray["partner_image"] != nil{
                                              channelResponse["partner_image"] = dataArray["partner_image"] as AnyObject
                                              }
                                              if dataArray["partner_description"] != nil{
                                              channelResponse["partner_description"] = dataArray["partner_description"] as AnyObject
                                              }
                                              if dataArray["partner_name"] != nil{
                                              channelResponse["partner_name"] = dataArray["partner_name"] as AnyObject
                                              }
                                } else {
            //                channelResponse["error"] = "no value" as AnyObject
                          if dataArray["partner_image"] != nil{
                          channelResponse["partner_image"] = dataArray["partner_image"] as AnyObject
                          }
                          if dataArray["partner_description"] != nil{
                          channelResponse["partner_description"] = dataArray["partner_description"] as AnyObject
                          }
                          if dataArray["partner_name"] != nil{
                          channelResponse["partner_name"] = dataArray["partner_name"] as AnyObject
                          }

                                }
                        }
                        
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        print(error)
                        break
                    }
            }
            
            
            
        }
    }
//    static func getPartnerByPartnerid(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
//        var channelResponse = Dictionary<String, AnyObject>()
//        var parameterDict: [String: String?] = [ : ]
//        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
//        let user_id = UserDefaults.standard.string(forKey:"user_id")!
//        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
//        let pubid = UserDefaults.standard.string(forKey:"pubid")!
//       let device_type = "apple-tv"
//        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
//        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
//        let channelid = UserDefaults.standard.string(forKey:"channelid")!
//        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
//        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
//        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
//
//            if let getNewarrivalApi = ApiRESTUrlString().GetPartnerByCategory(parameterDictionary: parameterDict as? Dictionary<String, String>) {
//                AF.request(getNewarrivalApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
//                    .responseJSON{ (response) in
//                        switch(response.result) {
//                        case .success(let value):
//                            let responseDict = value as! [String: AnyObject]
//                            if responseDict["err"] != nil{
//                              channelResponse["error"] = "no value" as AnyObject
//                            }
//                            else{
//                            let dataArray = responseDict["data"] as! NSDictionary
//
//                            var channelResponseArray = [VideoModel]()
//
//                            let categories = dataArray["shows"] as! [Dictionary<String, Any>]
//
//
//                            if !categories.isEmpty {
//                //                        let dataArray1 = param["videos"] as! [Dictionary<String, Any>]
//                                      for videoItem in categories {
//                                        let JSON: NSDictionary = videoItem as NSDictionary
//                                        let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
//                                        channelResponseArray.append(videoModel)
//                                      }
//
//                                      channelResponse["data"] = channelResponseArray as AnyObject
//                                   if dataArray["partner_image"] != nil{
//                                                  channelResponse["partner_image"] = dataArray["partner_image"] as AnyObject
//                                                  }
//                                                  if dataArray["partner_description"] != nil{
//                                                  channelResponse["partner_description"] = dataArray["partner_description"] as AnyObject
//                                                  }
//                                                  if dataArray["partner_name"] != nil{
//                                                  channelResponse["partner_name"] = dataArray["partner_name"] as AnyObject
//                                                  }
//                                    } else {
//                //                channelResponse["error"] = "no value" as AnyObject
//                              if dataArray["partner_image"] != nil{
//                              channelResponse["partner_image"] = dataArray["partner_image"] as AnyObject
//                              }
//                              if dataArray["partner_description"] != nil{
//                              channelResponse["partner_description"] = dataArray["partner_description"] as AnyObject
//                              }
//                              if dataArray["partner_name"] != nil{
//                              channelResponse["partner_name"] = dataArray["partner_name"] as AnyObject
//                              }
//
//                                    }
//                            }
//
//                            callback(channelResponse)
//
//                            break
//
//                        case .failure(let error):
//                            channelResponse["error"] = error as AnyObject
//                            callback(channelResponse)
//                            print(error)
//                            break
//
//                        }
//                }
//            }
//
//    }
  
    static func analayticsAPI(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      AF.request(APP_LAUNCH, method: .post, parameters: parameterDictionary, encoding: URLEncoding.default, headers:  nil)
        .responseString{ (response) in
          var channelResponse = Dictionary<String, AnyObject>()

          switch(response.result) {

          case .success(let value):
            print("Sucess Device API")
              channelResponse["value"] = value as AnyObject
            print(value)
            break
          case .failure(let error):
            print("Error Device API")
              channelResponse["value"] = "Error" as AnyObject

            if let value =  parameterDictionary["event_type"] {
              print(value)
            }
            print(error)
            break
          }
          callback(channelResponse)
      }
    }
    static func analayticsEventAPI(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      
      AF.request(eventAPI, method: .post, parameters: parameterDictionary, encoding: URLEncoding.default, headers:  nil)
        .responseString{ (response) in
          switch(response.result) {
          case .success(let value):
            print("Sucess Event API")
            print(value)
            break
          case .failure(let error):
            print("Error Event API")
            print(error)
            break
          }
      }
    }
    static func parseSrtFile(urlString: String, callback: @escaping(Dictionary<String, String?>) -> Void) {
      var apiResponse = Dictionary<String, String>()
      AF.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers:  nil)
        .responseString{ response in
          switch(response.result) {
          case .success(let value):
            apiResponse["data"] = value
            callback(apiResponse)
            break
          case .failure(let error):
            print(error)
            callback(apiResponse)
            break
          }
      }
    }
    static func getvideoDataByID(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getVideosApi = ApiRESTUrlString().getVideosByID(parameterDictionary: parameterDictionary){
            AF.request(getVideosApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! Dictionary<String, Any>
                //            for videoItem in dataArray {
                            let JSON: NSDictionary = dataArray as NSDictionary
                              let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                              channelResponseArray.append(videoModel)
                            
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
            
            
            
        }
    }
    static func getvideoAccordingToShows(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getVideosApi = ApiRESTUrlString().getvideoAccordingToShows(parameterDictionary: parameterDictionary){
            AF.request(getVideosApi, method: .get, parameters: nil, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [ShowDetailsModel]()
                        var channelResponse = Dictionary<String, AnyObject>()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            // Create a user!
                            let dataArray = responseDict["data"] as! Dictionary<String, Any>
                //            for videoItem in dataArray {
                            let JSON: NSDictionary = dataArray as NSDictionary
                              let videoModel: ShowDetailsModel = ShowDetailsModel.from(JSON)! // This is a 'User?'
                              channelResponseArray.append(videoModel)
                            
                            channelResponse["data"]=channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"]=responseDict["message"]
                        }
                        callback(channelResponse)
                        
                        break
                        
                    case .failure(let error):
                        
                        print(error)
                        break
                        
                    }
            }
            
            
            
        }
    }
    static func getWatchFlagVideo(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
             let user_id = UserDefaults.standard.string(forKey:"user_id")!
              let country_code = UserDefaults.standard.string(forKey:"countryCode")!
              let pubid = UserDefaults.standard.string(forKey:"pubid")!
             let device_type = "apple-tv"
              let dev_id = UserDefaults.standard.string(forKey:"UDID")!
              let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
              let channelid = UserDefaults.standard.string(forKey:"channelid")!
              let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      if let getTokenApi = ApiRESTUrlString().getWatchFlagVideo(parameterDictionary: parameterDictionary) {
          AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
          .responseJSON{ (response) in
            switch(response.result) {
            case .success(let value):
              var channelResponseArray = [LikeWatchListModel]()
              let responseDict = value as! [String: AnyObject]
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                  let JSON: NSDictionary = videoItem as NSDictionary
                  let videoModel: LikeWatchListModel = LikeWatchListModel.from(JSON)! // This is a 'User?'
                  channelResponseArray.append(videoModel)
                }
                channelResponse["data"] = channelResponseArray as AnyObject
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
        }
      }
    }
    static func WatchlistVideos(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
     let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

      if let getTokenApi = ApiRESTUrlString().getWatchlistVideos(parameterDictionary: parameterDictionary) {
          AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
          .responseJSON{ (response) in
            switch(response.result) {
            case .success(let value):
              let responseDict = value as! [String: AnyObject]
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                channelResponse["data"] = responseDict["message"]
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
        }
      }
    }
    static func getWatchFlag(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
             let user_id = UserDefaults.standard.string(forKey:"user_id")!
              let country_code = UserDefaults.standard.string(forKey:"countryCode")!
              let pubid = UserDefaults.standard.string(forKey:"pubid")!
             let device_type = "apple-tv"
              let dev_id = UserDefaults.standard.string(forKey:"UDID")!
              let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
              let channelid = UserDefaults.standard.string(forKey:"channelid")!
              let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      if let getTokenApi = ApiRESTUrlString().getWatchFlag(parameterDictionary: parameterDictionary) {
          AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
          .responseJSON{ (response) in
            switch(response.result) {
            case .success(let value):
              var channelResponseArray = [LikeWatchListModel]()
              let responseDict = value as! [String: AnyObject]
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
                for videoItem in dataArray {
                  let JSON: NSDictionary = videoItem as NSDictionary
                  let videoModel: LikeWatchListModel = LikeWatchListModel.from(JSON)! // This is a 'User?'
                  channelResponseArray.append(videoModel)
                }
                channelResponse["data"] = channelResponseArray as AnyObject
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
        }
      }
    }
    static func WatchlistShows(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
     let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

      if let getTokenApi = ApiRESTUrlString().getWatchlistShows(parameterDictionary: parameterDictionary) {
          AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
          .responseJSON{ (response) in
            switch(response.result) {
            case .success(let value):
              let responseDict = value as! [String: AnyObject]
              guard let status = responseDict["success"] as? NSNumber  else {
                return
              }
              if status == 1 {
                channelResponse["data"] = responseDict["message"]
              } else {
                channelResponse["error"] = responseDict["message"]
              }
              callback(channelResponse)
              break
            case .failure(let error):
              channelResponse["error"] = error as AnyObject
              callback(channelResponse)
              break
            }
        }
      }
    }
    static func getvideoByCategory(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
      var channelResponse = Dictionary<String, AnyObject>()
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      let country_code = UserDefaults.standard.string(forKey:"countryCode")!
      let pubid = UserDefaults.standard.string(forKey:"pubid")!
     let device_type = "apple-tv"
      let dev_id = UserDefaults.standard.string(forKey:"UDID")!
      let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
      let channelid = UserDefaults.standard.string(forKey:"channelid")!
      let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      if let getTokenApi = ApiRESTUrlString().getvideoByCategory(parameterDictionary: parameterDictionary) {
        var mutableURLRequest = URLRequest(url: URL(string: getTokenApi)!)
        mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        mutableURLRequest.httpMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
        AF.request(mutableURLRequest).validate().responseJSON{ response in
          
          switch(response.result) {
          case .success(let value):
            let responseDict = value as! [String: AnyObject]
            var channelResponseArray = [VideoModel]()
  //          guard let status = responseDict["success"] as? NSNumber  else {
  //            return
  //          }
  //          if status == 1 {
              let dataArray = responseDict["data"] as! [Dictionary<String, Any>]
            if !dataArray.isEmpty{
              for videoItem in dataArray {
                let JSON: NSDictionary = videoItem as NSDictionary
                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                channelResponseArray.append(videoModel)
              }
              channelResponse["data"] = channelResponseArray as AnyObject
            } else {
              channelResponse["error"] = responseDict["message"]
            }
            callback(channelResponse)
            break
          case .failure(let error):
            channelResponse["error"] = error as AnyObject
            callback(channelResponse)
            break
          }
        }
      }
    }
    static func logOutAction( parameterDictionary: Dictionary<String, String>!,completion: @escaping(_ result: Bool)->()) {
        if let accesToken = UserDefaults.standard.string(forKey:"access_token") {
            let user_id = UserDefaults.standard.string(forKey:"user_id")!
            let country_code = UserDefaults.standard.string(forKey:"countryCode")!
            let pubid = UserDefaults.standard.string(forKey:"pubid")!
           let device_type = "apple-tv"
            let dev_id = UserDefaults.standard.string(forKey:"UDID")!
            let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
            let channelid = UserDefaults.standard.string(forKey:"channelid")!
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
            let userAgent = UserDefaults.standard.string(forKey:"userAgent")
            let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            if let getUrl = ApiRESTUrlString().getlogOUtUrl(parameterDictionary: nil) {
                var mutableURLRequest = URLRequest(url: URL(string: getUrl)!)
                mutableURLRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
                mutableURLRequest.httpMethod = "GET"
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                mutableURLRequest.allHTTPHeaderFields = ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent]
                AF.request(mutableURLRequest).validate().responseJSON{ response in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                        break
                    case .failure:
                        completion(false)
                        break
                    }
                }
            }
        }
    }
    static func getIpandlocation(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
         var dataResponse = Dictionary<String, AnyObject>()
         let getTokenApi = "https://giz.poppo.tv/service/ipinfo"
         AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
           .responseJSON{ (response) in
             switch(response.result) {
             case .success(let value):
               let responseDictionary = value as! [String: AnyObject]
                   let countryCode = responseDictionary["countryCode"] as! String
                   UserDefaults.standard.set(countryCode, forKey: "countryCode")
                let country = responseDictionary["country"] as! String
                 UserDefaults.standard.set(country, forKey: "country")
                   UserDefaults.standard.set(countryCode, forKey: "c_code")
                   if UserDefaults.standard.string(forKey: "countryCode") == nil {
                     UserDefaults.standard.set("US", forKey: "countryCode")
                     UserDefaults.standard.set("US", forKey: "c_code")
                   }
                   let lat = responseDictionary["lat"]
                   UserDefaults.standard.set(lat, forKey: "latitude")
                   let lon = responseDictionary ["lon"]
                   UserDefaults.standard.set(lon, forKey: "longitude")
                   let IPAddress = responseDictionary["query"] as! String
                   UserDefaults.standard.set(IPAddress, forKey: "IPAddress")
               if UserDefaults.standard.string(forKey: "IPAddress") == nil {
                   UserDefaults.standard.set(" ", forKey: "IPAddress")
               }
                   let city = responseDictionary ["city"] as! String
                   UserDefaults.standard.set(city, forKey: "city")
                   let region = responseDictionary["region"] as! String
                   UserDefaults.standard.set(region, forKey: "Region")
                   UserDefaults.standard.set("2", forKey: "Geo_Type")
                   dataResponse =  [:]
                   callback(dataResponse)
               break
             case .failure(let error):
               print(error)
               dataResponse["error"] = error as AnyObject
               callback(dataResponse)
               break
             }
         }
     }
    static func generateToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
      var parameterDict: [String: String?] = [ : ]
      let accesToken = UserDefaults.standard.string(forKey:"access_token")!
      parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
      let getLanguagesApi = ApiRESTUrlString().generateVideoToken(parameterDictionary: parameterDict as? Dictionary<String, String>)
      ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
        var channelResponse = Dictionary<String, AnyObject>()
        guard let status = responseDictionary["success"] as? NSNumber  else {
          return
        }
        if status == 1 {
          // Create a user!
          let dataArray = responseDictionary["data"]

          channelResponse["Channels"]=dataArray
        } else {
          channelResponse["error"]=responseDictionary["message"]
        }
        callback(channelResponse)
      }
    }
    static func GetSelectedVideo(parameterDictionary: Dictionary<String, String>!, callback: @escaping(Dictionary<String, AnyObject?>) -> Void) {
        var channelResponse = Dictionary<String, AnyObject>()
        let accesToken = UserDefaults.standard.string(forKey:"access_token")!
        let user_id = UserDefaults.standard.string(forKey:"user_id")!
        let country_code = UserDefaults.standard.string(forKey:"countryCode")!
        let pubid = UserDefaults.standard.string(forKey:"pubid")!
       let device_type = "apple-tv"
        let dev_id = UserDefaults.standard.string(forKey:"UDID")!
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
        let channelid = UserDefaults.standard.string(forKey:"channelid")!
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as! String
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")
        let encodeduserAgent = String(format: "%@", userAgent!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let getTokenApi = ApiRESTUrlString().getSelectedVideo(parameterDictionary: parameterDictionary) {
            AF.request(getTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:  ["access-token": accesToken,"uid":user_id,"country_code":country_code,"pubid":pubid,"device_type":device_type,"dev_id":dev_id,"ip":ipAddress,"channelid":channelid,"version":version,"ua":encodeduserAgent])
                .responseJSON{ (response) in
                    switch(response.result) {
                    case .success(let value):
                        let responseDict = value as! [String: AnyObject]
                        var channelResponseArray = [VideoModel]()
                        guard let status = responseDict["success"] as? NSNumber  else {
                            return
                        }
                        if status == 1 {
                            let dataArray = responseDict["data"] as! Dictionary<String, Any>
                          
                                let JSON: NSDictionary = dataArray as NSDictionary
                                let videoModel: VideoModel = VideoModel.from(JSON)! // This is a 'User?'
                                channelResponseArray.append(videoModel)
                            
                            channelResponse["data"] = channelResponseArray as AnyObject
                        } else {
                            channelResponse["error"] = responseDict["message"]
                        }
                        callback(channelResponse)
                        break
                    case .failure(let error):
                        channelResponse["error"] = error as AnyObject
                        callback(channelResponse)
                        break
                    }
                }
        }
    }
    static func parseSubRip(_ payload: String) -> NSDictionary? {

       do {

         // Prepare payload
         var payload = payload.replacingOccurrences(of: "\n\r\n", with: "\n\n")
         payload = payload.replacingOccurrences(of: "\n\n\n", with: "\n\n")
         payload = payload.replacingOccurrences(of: "\r\n", with: "\n")

         // Parsed dict
         let parsed = NSMutableDictionary()

         // Get groups
         let regexStr = "(\\d+)\\n([\\d:,.]+)\\s+-{2}\\>\\s+([\\d:,.]+)\\n([\\s\\S]*?(?=\\n{2,}|$))"
         let regex = try NSRegularExpression(pattern: regexStr, options: .caseInsensitive)
         let matches = regex.matches(in: payload, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, payload.count))
         for m in matches {

           let group = (payload as NSString).substring(with: m.range)

           // Get index
           var regex = try NSRegularExpression(pattern: "^[0-9]+", options: .caseInsensitive)
           var match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
           guard let i = match.first else {
             continue
           }
           let index = (group as NSString).substring(with: i.range)

           // Get "from" & "to" time
           regex = try NSRegularExpression(pattern: "\\d{1,2}:\\d{1,2}:\\d{1,2}[,.]\\d{1,3}", options: .caseInsensitive)
           match = regex.matches(in: group, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, group.count))
           guard match.count == 2 else {
             continue
           }
           guard let from = match.first, let to = match.last else {
             continue
           }

           var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0

           let fromStr = (group as NSString).substring(with: from.range)
           var scanner = Scanner(string: fromStr)
           scanner.scanDouble(&h)
           scanner.scanString(":", into: nil)
           scanner.scanDouble(&m)
           scanner.scanString(":", into: nil)
           scanner.scanDouble(&s)
           scanner.scanString(",", into: nil)
           scanner.scanDouble(&c)
           let fromTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)

           let toStr = (group as NSString).substring(with: to.range)
           scanner = Scanner(string: toStr)
           scanner.scanDouble(&h)
           scanner.scanString(":", into: nil)
           scanner.scanDouble(&m)
           scanner.scanString(":", into: nil)
           scanner.scanDouble(&s)
           scanner.scanString(",", into: nil)
           scanner.scanDouble(&c)
           let toTime = (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)

           // Get text & check if empty
           let range = NSMakeRange(0, to.range.location + to.range.length + 1)
           guard (group as NSString).length - range.length > 0 else {
             continue
           }
           let text = (group as NSString).replacingCharacters(in: range, with: "")

           // Create final object
           let final = NSMutableDictionary()
           final["from"] = fromTime
           final["to"] = toTime
           final["text"] = text
           parsed[index] = final

         }

         return parsed

       } catch {

         return nil

       }

     }

     static func searchSubtitles(_ payload: NSDictionary?, _ time: TimeInterval) -> String? {
       let predicate = NSPredicate(format: "(%f >= %K) AND (%f <= %K)", time, "from", time, "to")
       guard let values = payload?.allValues, let result = (values as NSArray).filtered(using: predicate).first as? NSDictionary else {
         return nil
       }
       guard let text = result.value(forKey: "text") as? String else {
         return nil
       }
       return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
     }
    static func generateVideoToken(callback: @escaping (Dictionary<String, AnyObject?>) -> Void) {
        var parameterDict: [String: String?] = [ : ]
        
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        if let getVideoTokenApi = ApiRESTUrlString().generateVideoToken(parameterDictionary: parameterDict as? Dictionary<String, String>),let accesToken = Application.shared.accessToken {
        AF.request(getVideoTokenApi, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["access-token": accesToken])
            .responseJSON{ (response) in
                switch(response.result) {
                case .success(let value):
                   let responseDict = value as! [String: AnyObject]
                    var tokenDict = Dictionary<String, AnyObject>()
                    guard let status = responseDict["success"] as? NSNumber  else {
                        return
                    }
                    if status == 1 {
                        let dataArray = responseDict["data"]
                        tokenDict["data"] = dataArray
                       
                    } else {
                       tokenDict["error"] = responseDict["message"]
                    }
                    callback(tokenDict)
                    
                    break
                    
                case .failure(let error):
                    
                    print(error)
                    break
                    
                }
        }
        }
//        ApiCallManager.apiCallREST(mainUrl: getLanguagesApi!, httpMethod: "GET", headers: ["access-token": accesToken], postData: nil) { (responseDictionary: Dictionary) in
//            var channelResponse = Dictionary<String, AnyObject>()
//            guard let status = responseDictionary["success"] as? NSNumber  else {
//                return
//            }
//            if status == 1 {
//                // Create a user!
//                let dataArray = responseDictionary["data"]
//
//                channelResponse["Channels"]=dataArray
//            } else {
//                channelResponse["error"]=responseDictionary["message"]
//            }
//            callback(channelResponse)
//        }
    }

}


extension Dictionary {
  func percentEncoded() -> Data? {
      return map { key, value in
          let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
          let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
          return escapedKey + "=" + escapedValue
      }
      .joined(separator: "&")
      .data(using: .utf8)
  }
}

extension CharacterSet {
  static let urlQueryValueAllowed: CharacterSet = {
      let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
      let subDelimitersToEncode = "!$&'()*+,;="
      
      var allowed = CharacterSet.urlQueryAllowed
      allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
      return allowed
  }()
}




