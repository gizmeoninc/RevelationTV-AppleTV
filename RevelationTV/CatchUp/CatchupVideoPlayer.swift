//
//  CatchupVideoPlayer.swift
//  KICCTV
//
//  Created by sinitha sidharthan on 16/11/22.
//  Copyright © 2022 Firoze Moosakutty. All rights reserved.
//

//
//  ViewController.swift
//  ImaSdkAddSample
//
//  Created by GIZMEON on 24/12/20.
//

import UIKit
import GoogleInteractiveMediaAds
import AVFoundation
import AVKit
import Reachability
import SimpleSubtitles

class CatchupVideoPlayer: UIViewController,IMAAdsLoaderDelegate ,IMAAdsManagerDelegate,SubtitleDelegate{
   
    
    
    
    var token = ""
    var videos = [VideoModel]()
    var categoryModel : VideoModel!
    var subtitles :[subtitleModel]?
    var subtitlesController: SubtitlesController?
    var selectedvideoItem: VideoModel?
    var avPlayer: AVPlayer? = AVPlayer()
    var contentPlayerLayer: AVPlayerLayer?
    var observer: Any!
    var video: VideoModel!
    var isVideoPlaying = false
    var selectedIndex = -1
    
    var subtitleIsOn = false
    var subtitleUrl = String()
    var isAdPlayback = false
    var isLandscape = false
    let playerItem: AVPlayerItem? = nil
    var videoHeight = CGFloat()
    var videoPlayerHeight = CGFloat()
    var adPositionsArray = Array<Float>()
    var isPlaying = true
    var videoName = ""
    var videoTitle = ""
    var addLink = ""
    var videoId = Int()
    var channelId = ""
    var channelName = ""
    var liked = ""
    var theme = ""
    var programeTitle = ""
    var appStoreEncodedUrl = ""
    var videoStartTime = ""
    var categoryList = ""
    var videoDuration = Double()
    var watchUpdateFlag = false
    //    var reachability = Reachability()!
    var sampleArray = Array<Float>()
    var videoDescription = ""
    var isFromSub = false
    
    var fullScreenValue = Int()
    var videoPlayerWidth = Int()
    var videoPlayerMacroHeight = Int()
    var btnLeftMenu : UIButton = UIButton()
    var hidevideoController = true
    var normalScreenButtonflag = false
    //    var adDisplayContainer:IMAAdDisplayContainer?
    var fromNotification = Bool()
    var fromPartner = false
    var dropDownflag = true
    var videoNotificationId = Int()
    var interstitial_status = Int()
    var mobpub_interstitial_status = Int()
    private var imageView: UIImageView!
    var isPresentController = false
    var subscribedUser = false
    var premium_flag = Int()
    var isfromSubscription = false
    var isbackActionPerformed = false
    
    var pointsArr = Array<String>()
    var LabelDict: [String: NSRange?] = [ : ]
    var replacedString = ""
    var countTimer:Timer!
    var counter = 15
    var videoPlayingeventValue = false
    var parsedPayload: NSDictionary?
    var rotationAngle : CGFloat!
    var showId = Int()
    var subtitleListArray = [subtitleModel]()
    var dummyarray = [subtitleModel]()
  
    let listArray: NSDictionary = [
      "language_name": "Off",
        "short_code": "off",
        "code": "off",
        "subtitle_url": "off",
      
    ]

    static let ContentURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonly&cmsid=496&vid=short_onecue&correlator="
    static var AdTagURLString = " "
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    
    var playerViewController: AVPlayerViewController!
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private let subTitleLabel: SubtitlesLabel = {
        let label = SubtitlesLabel()
        label.numberOfLines = 0
        label.insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 44)
//        label.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        label.layer.cornerRadius = 10
        return label
    } ()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.watchUpdateFlag = false
        self.view.backgroundColor = ThemeManager.currentTheme().viewBackgroundColor
        self.view.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        subTitleLabel.isHidden = true
      
    }
    @objc func menuButtonAction() {
        print("menu pressed")
        self.dismiss(animated: true)
    }
    @objc func menuButtonAction(recognizer:UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        print("viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
//        playerViewController?.player!.pause()

        if playerViewController?.player?.timeControlStatus == .playing{
            hideContentPlayer()
            playerViewController?.player!.pause()
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.isUserInteractionEnabled = true
        
        
       
    }

   
   
    func generateToken() {
        print("generateToken")
        commonClass.startActivityIndicator(onViewController: self)
        ApiCommonClass.generateToken { (responseDictionary: Dictionary) in
            DispatchQueue.main.async {
                if let val = responseDictionary["error"] {
                } else {
                    self.token = responseDictionary["Channels"] as! String
                    print("didSelectNonPremiumVideo token")
                    self.setUpContentPlayer()

                   
                }
            }
        }
    }
  
    func setUpAdsLoader() {
        adsLoader = IMAAdsLoader(settings: nil)
        adsLoader.delegate = self
        //        adsManager.delegate = self
        //        adsManager.initialize(with: nil)
        
        
    }
  
    func requestAds() {
      // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
      // Create an ad request with your ad tag, display container, and optional user context.
      let request = IMAAdsRequest(
          adTagUrl: CatchupVideoPlayer.AdTagURLString,
          adDisplayContainer: adDisplayContainer,
          contentPlayhead: contentPlayhead,
          userContext: nil)

      adsLoader.requestAds(with: request)
    }
    
    
    func setUpContentPlayer() {
        print("setUpContentPlayer")
      // Load AVPlayer with path to your content.
        let contentUrl = URL(string: String(format:videoName))
       let headers = ["token": token]
       let asset: AVURLAsset = AVURLAsset(url: contentUrl!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
       let playerItem: AVPlayerItem = AVPlayerItem(asset: asset)
       avPlayer = AVPlayer(playerItem: playerItem)
         playerViewController = CustomAVPlayerViewController()
         playerViewController.player = avPlayer
        if #available(tvOS 14.0, *) {
            playerViewController.allowsPictureInPicturePlayback = true
        } else {
            // Fallback on earlier versions
        }
//        playerViewController.showsPlaybackControls = false
        playerViewController.view.isUserInteractionEnabled = true
        playerViewController.allowedSubtitleOptionLanguages = [""]
        dummyarray.removeAll()
        let dummyList = subtitleModel.from(listArray)
        
        if !subtitleListArray.isEmpty{
            let subtitleSelection = SubtitleSelectionViewController()

            subtitleSelection.subtileOn = self

            self.dummyarray.append(dummyList!)
//            subtitleSelection.languages = dummyarray + self.subtitleListArray
            subtitleSelection.selectedRow = self.selectedIndex
            playerViewController.customInfoViewController = subtitleSelection


        }
           contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: avPlayer)
               NotificationCenter.default.addObserver(
                 self,
                 selector: #selector(CatchupVideoPlayer.playerDidFinish(_:)),
                 name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                 object: avPlayer?.currentItem);
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
        if top is CatchupVideoPlayer {
        print("topcontroller5",topController)
            showContentPlayer()
            //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            hideContentPlayer()
            playerViewController.player?.pause()
        }
        avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (progressTime) -> Void in
          let seconds = CMTimeGetSeconds(progressTime)
            if self.subtitleIsOn {
                self.subTitleLabel.isHidden = false
                self.subTitleLabel.text = ApiCommonClass.searchSubtitles(self.parsedPayload, progressTime.seconds)
            } else {
                self.subTitleLabel.isHidden = true
                self.subTitleLabel.text = nil
            }

          if Int((seconds.truncatingRemainder(dividingBy: 60))) ==  0 && Int(seconds) != 0 {
            print("seconds",Int(seconds))
            self.videoPlayingEvent()
          }
          
        }

     
    }
    func showContentPlayer() {
        commonClass.stopActivityIndicator(onViewController: self)

        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
        if top is CatchupVideoPlayer {
        print("topcontroller5",topController)
            self.addChild(playerViewController)
            playerViewController.view.frame = self.view.bounds
            self.view.insertSubview(playerViewController.view, at: 0)
            playerViewController.didMove(toParent:self)
              playerViewController.player?.play()            //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            hideContentPlayer()
            playerViewController.player?.pause()
        }
        if playerViewController?.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay {
          if let isPlaybackLikelyToKeepUp = playerViewController?.player?.currentItem?.isPlaybackLikelyToKeepUp {
            if  isPlaybackLikelyToKeepUp == false {
              print("isPlaybackLikelyToKeepUp",isPlaybackLikelyToKeepUp)
             
            } else {
              if self.watchUpdateFlag == false {
                self.videoStartEvent()
                self.watchUpdateFlag = true
              
              }
             }
          }
        }
    }
    func hideContentPlayer() {
      // The whole controller needs to be detached so that it doesn't capture  events from the remote.
      playerViewController.willMove(toParent:nil)
      playerViewController.view.removeFromSuperview()
      playerViewController.removeFromParent()
    }
    
    func showSubtitle(urlString :String?,index: Int?) {
        print("url string",urlString)
        print("subtile show")
        self.subtitleUrl = urlString!
        self.subtitleIsOn = true
        self.selectedIndex = index!
        self.parseSubTitle(Url: self.subtitleUrl)
        
    }
    func hideSubtitle(index:Int?) {
        print("index")
       
        self.subtitleIsOn = false
        self.selectedIndex = index!
        
    }
    func parseSubTitle(Url: String){
        let urlString = Url
        ApiCommonClass.parseSrtFile(urlString: urlString) { (responseDictionary: Dictionary) in
            if let response = responseDictionary["data"] as? String{
                print(response)
                self.subtitleIsOn = true
                self.parsedPayload =  ApiCommonClass.parseSubRip(response)
            }
        }
    }

    @objc func playerDidFinish(_ notification: Notification) {
        print("Video Finished")
        self.VideoEndEvent()
    }
 
    func videoStartEvent() {
        print("POP02")
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = device_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["event_type"] = "POP02"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
        }
        if let videoName = self.video.video_title {
            parameterDict["video_title"] = videoName
        }
        if let video_id = self.video.video_id {
            parameterDict["video_id"] = String(video_id)
        }
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        parameterDict["category"] = self.categoryList
        print("POP02",parameterDict)
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    func videoPlayingEvent() {
        print("POP03")
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = device_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        
        parameterDict["event_type"] = "POP03"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
        }
        if let videoName = self.video.video_title {
            parameterDict["video_title"] = videoName
        }
        if let video_id = self.video.video_id {
            parameterDict["video_id"] = String(video_id)
        }
        if let channel_id = video.channel_id {
            parameterDict["channel_id"] = String(channel_id)
        }
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        parameterDict["category"] = self.categoryList
        if let video_time = playerViewController.player?.currentTime().seconds {
        let time = Int(video_time)
        parameterDict["video_time"] = String(time)
        print("time",time)
  }
        print("pop03",parameterDict)
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
    }
    func VideoPauseEvent() {
        print("POP04")
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP04"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        
        if let videoName = self.video.video_title {
            parameterDict["video_title"] = videoName
        }
        if let video_id = self.video.video_id {
            parameterDict["video_id"] = String(video_id)
        }
        if let channel_id = video.channel_id {
            parameterDict["channel_id"] = String(channel_id)
        }
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        parameterDict["category"] = self.categoryList
        if let video_time = playerViewController.player?.currentTime().seconds {
        let time = Int(video_time)
        parameterDict["video_time"] = String(time)
        print("time",time)
  }
        print("pop04",parameterDict)
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
    }
    func VideoResumeEvent() {
        print("POP09")
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP09"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        
        if let videoName = self.video.video_title {
            parameterDict["video_title"] = videoName
        }
        if let video_id = self.video.video_id {
            parameterDict["video_id"] = String(video_id)
        }
        if let channel_id = video.channel_id {
            parameterDict["channel_id"] = String(channel_id)
        }
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        parameterDict["category"] = self.categoryList
        if let video_time = playerViewController.player?.currentTime().seconds {
        let time = Int(video_time)
        parameterDict["video_time"] = String(time)
        print("time",time)
  }
        print("pop09",parameterDict)
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
    }
    func VideoEndEvent() {
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP05"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        
        if let videoName = self.video.video_title {
            parameterDict["video_title"] = videoName
        }
        if let video_id = self.video.video_id {
            parameterDict["video_id"] = String(video_id)
        }
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        parameterDict["category"] = self.categoryList
        if let channelid = UserDefaults.standard.string(forKey:"channelid") {
            parameterDict["channel_id"] = channelid
        }
        if let video_time = playerViewController.player?.currentTime().seconds {
        let time = Int(video_time)
        parameterDict["video_time"] = String(time)
        print("time",time)
  }
        print("param pop05",parameterDict)
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
        
    }
    func videoPlayingError(error_code:String?,error_message:String?) {
        var parameterDict: [String: String?] = [ : ]
        let currentDate = Int(Date().timeIntervalSince1970)
        parameterDict["timestamp"] = String(currentDate)
        parameterDict["user_id"] = UserDefaults.standard.string(forKey:"user_id")
        if let device_id = UserDefaults.standard.string(forKey:"UDID") {
            parameterDict["device_id"] = device_id
        }
        parameterDict["event_type"] = "POP08"
        if let app_id = UserDefaults.standard.string(forKey: "application_id") {
            parameterDict["app_id"] = app_id
        }
        if let videoName = self.video.video_title {
            parameterDict["video_title"] = videoName
        }
        if let video_id = self.video.video_id {
            parameterDict["video_id"] = String(video_id)
        }
        if let error_code = error_code {
            parameterDict["error_code"] = error_code
        }
        if let error_message = error_message {
            parameterDict["error_message"] = error_message
        }
        if let channel_id = video.channel_id {
            parameterDict["channel_id"] = String(channel_id)
        }
        parameterDict["publisherid"] = UserDefaults.standard.string(forKey:"pubid")
        
        parameterDict["session_id"] = UserDefaults.standard.string(forKey:"session_id")
        parameterDict["category"] = self.categoryList
        print("pop08",parameterDict)
        ApiCommonClass.analayticsEventAPI(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
    }
//    func setUpInitial() {
//        
//        
//        if self.video.video_name != nil {
//            videoName = video.video_name!
//            
//        }
//        
//        if self.video.video_name != nil {
//            self.GenerateToken(flag: false)
//        }
//    }
    func GenerateToken(flag : Bool)  {
        ApiCommonClass.generateVideoToken { (responseDictionary: Dictionary) in
            DispatchQueue.main.async {
                if let val = responseDictionary["error"] {
                    //WarningDisplayViewController().customAlert(viewController:self, messages: val as! String)
                } else {
                    self.token = responseDictionary["data"] as! String
                    
                    if ((self.interstitial_status == 0) || (flag == true )) {
                        //
                    }
                }
                
            }
        }
    }
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader.contentComplete()
    }
var pauseFlag = false
    var playFlag = false
var pauseFlaglagCount = 1
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
        
            if (press.type == UIPress.PressType.select) {
                if playerViewController.player?.timeControlStatus == .playing{
                    
                    if !pauseFlag{
                        print("pop04")
                        pauseFlag = true
                        playerViewController.player?.pause()
                    }
                    else{
                        print("pop04 else")
                    }
                    
                    
                }
                else if playerViewController.player?.timeControlStatus == .paused{
                    
                    
                    if pauseFlag
                    {
                        print("pop09")
                        playerViewController.player?.play()
                        pauseFlag = false
                    }
                    else{
                        print("pop09 else")

                    }
                    

                }
                else{
                    print("player none")
                }
        }
            else  if presses.first?.type == .menu { // Detect the menu button
                self.dismiss(animated: true)
            }
            else {
            print("pressesEnded")
            
            super.pressesEnded(presses, with: event)
        }
        }
    }
    

//    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
//        for press in presses {
//            if (press.type == .playPause) {
//                print("Select is pressed")
//                // Select is pressed
//            }  else {
//                print("pressesEnded")
//                super.pressesEnded(presses, with: event)
//            }
//        }
//    }
    func replaceMacros() {
      let bundleID = Bundle.main.bundleIdentifier
      if bundleID != nil {
        let originalBundleIdString = bundleID
        let encodedBundleIdUrl = originalBundleIdString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
      } else {
        let originalBundleIdString = "com.ios.Justwatchme.tv"
        let encodedBundleIdUrl = originalBundleIdString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[BUNDLE]", with: encodedBundleIdUrl!)
      }
      videoPlayerWidth = 640
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[WIDTH]", with: "\(videoPlayerWidth)")
      videoPlayerMacroHeight = 480
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[HEIGHT]", with: "\(videoPlayerMacroHeight)")
        let videoPlayingViewHeightInt = Int(view.frame.width)
      let videoPlayingViewWidthInt = Int(self.view.frame.width)
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[[PLAYER_HEIGHT]]", with: "\(videoPlayingViewHeightInt)")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[PLAYER_WIDTH]", with: "\(videoPlayingViewWidthInt)")
      if UserDefaults.standard.string(forKey:"countryCode") != nil {
        let countryCode = UserDefaults.standard.string(forKey:"countryCode")
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[COUNTRY]", with: countryCode!)
      }
      if UserDefaults.standard.string(forKey:"userAgent") != nil {
        let userAgent = UserDefaults.standard.string(forKey:"userAgent")!
        let encodeduserAgent = String(format: "%@", userAgent.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        CatchupVideoPlayer.AdTagURLString =  CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[USER_AGENT]", with: encodeduserAgent)
      }
      let UDID = UserDefaults.standard.string(forKey:"UDID")!
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[UUID]", with: UDID)
      if UserDefaults.standard.string(forKey:"IPAddress") != nil {
        let ipAddress = UserDefaults.standard.string(forKey:"IPAddress")!
              CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[IP_ADDRESS]", with:ipAddress)
         
      }
      
      let originalAppNameString = "Justwatchme.tv"
      let encodedAppNameUrl = String(format: "%@", originalAppNameString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[APP_NAME]", with: encodedAppNameUrl)

      if UserDefaults.standard.string(forKey:"lattitude") != nil {
        let lattitude = UserDefaults.standard.string(forKey: "lattitude")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[LATITUDE]", with: lattitude)
      }
      if UserDefaults.standard.string(forKey:"longitude") != nil {
        let longitude = UserDefaults.standard.string(forKey:"longitude")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[LONGITUDE]", with: longitude)
      }
      if UserDefaults.standard.string(forKey:"Idfa") != nil {
        let Idfa = UserDefaults.standard.string(forKey:"Idfa")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DEVICE_IFA]", with: Idfa)
      }
      if UserDefaults.standard.string(forKey:"city") != nil {
        let city = UserDefaults.standard.string(forKey:"city")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CITY]", with: city)
      }
        if UserDefaults.standard.string(forKey:"region") != nil {
          let Region = UserDefaults.standard.string(forKey:"region")!
            let encodedRegion = String(format: "%@",Region.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

            CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[REGION]", with: encodedRegion)
        }
      if UserDefaults.standard.string(forKey:"Geo_Type") != nil {
        let Geo_Type = UserDefaults.standard.string(forKey:"Geo_Type")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[GEO_TYPE]", with: Geo_Type)
      }

      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[GDPR]", with: "0")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[AUTOPLAY]", with: "1")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[GDPR]", with: "0")
      if videoDescription != "" {
        let encodedvideoDescription = String(format: "%@",videoDescription.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DESCRIPTION]", with: encodedvideoDescription)
      }
        if self.video.video_title != nil{
            let encodedvideoTitle = String(format: "%@",self.video.video_title! .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CONTENT_TITLE]", with: encodedvideoTitle)
        }
        
      let originalDeviceType = "iOS"
      let encodedDeviceType = String(format: "%@",originalDeviceType.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DEVICE_TYPE]", with: encodedDeviceType)
      let originalDevicemake = "Apple"
      let encodedDevicemake = String(format: "%@",originalDevicemake.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DEVICE_MAKE]", with: encodedDevicemake)
      let deviceModel = "AppleTv"
        let encodedDeviceModel = String(format: "%@", deviceModel.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DEVICE_MODEL]", with:encodedDeviceModel)
      let deviceId = UserDefaults.standard.string(forKey:"UDID")!
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DEVICE_ID]", with:deviceId)
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[VIDEO_ID]", with:String(videoId))
        CatchupVideoPlayer.AdTagURLString =  CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[SHOW_ID]", with:String(showId))

      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CHANNEL_ID]", with:channelId)
      if video.video_durationadd != nil {
        let duration1 = video.video_durationadd
        print("duration add",duration1)
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[TOTAL_DURATION]", with: duration1!)
      }
      let user_id = UserDefaults.standard.string(forKey:"user_id")!
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[USER_ID]", with:user_id)
      if UserDefaults.standard.string(forKey:"CARRIER") != nil {
        let carrier = UserDefaults.standard.string(forKey:"CARRIER")
        let encodedCarrier = String(format: "%@", carrier!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CARRIER]", with: encodedCarrier)
      }
      if UserDefaults.standard.string(forKey:"NETWORK") != nil {
        let network = UserDefaults.standard.string(forKey:"NETWORK")!
        let encodedNetwork = String(format: "%@", network.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[NETWORK]", with:encodedNetwork)
      }
      if UserDefaults.standard.string(forKey:"appVersion") != nil {
        let appVersion = UserDefaults.standard.string(forKey:"appVersion")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[APP_VERSION]", with:appVersion)
      }
      if UserDefaults.standard.string(forKey:"TYPE") != nil {
        let type = UserDefaults.standard.string(forKey:"TYPE")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[TYPE]", with:type)
      }
      if video.video_durationadd != nil {
        let duration = video.video_durationadd!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DURATION]", with:duration)
      }
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DNT]", with:""  + "0")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[VPAID]", with:""  + "0")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[VPAID]", with:"" + "0")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[PL]", with:"" + "0")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[LOCSOURCE]", with:"2")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[DEVICE_ORIGIN]", with:"IA")
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CACHEBUSTER]", with:"AA")
      if UserDefaults.standard.string(forKey:"languageId") != nil {
        let languageId = UserDefaults.standard.string(forKey:"languageId")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[LANGUAGE]", with:languageId)
      }
      if video.category_name != nil{
      if let category_name = self.video.category_name{
        if !category_name.isEmpty {
          var name = ""
          for categoryListArray in category_name {
            print(categoryListArray)
            name =  name + "," + (categoryListArray)
              
          }
          let keywords = String(name.dropFirst())
          let encodedAppStoreUrl = keywords.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
          CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[KEYWORDS]", with:encodedAppStoreUrl)

         print("encoded url",encodedAppStoreUrl)
         
        }
      }
        if let category_id = self.video.category_id{
          if !category_id.isEmpty {
            var name = ""
            for categoryListArray in category_id {
              print(categoryListArray)
              name =  name + "," + String(categoryListArray)
                
            }
            let ids = String(name.dropFirst())
            let encodedAppStoreUrl = ids.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CATEGORIES]", with:encodedAppStoreUrl)

           print("encoded url",encodedAppStoreUrl)
           
          }
        }

      }
      let originalAppstoreString = "https://apps.apple.com/in/app/boondock-nation/id1448300263"
      let encodedAppStoreUrl = originalAppstoreString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
      CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[APP_STORE_URL]", with: encodedAppStoreUrl)

      if UserDefaults.standard.string(forKey:"currentTimeStamp") != nil {
        let currentTimeStamp = UserDefaults.standard.string(forKey:"currentTimeStamp")!
        CatchupVideoPlayer.AdTagURLString = CatchupVideoPlayer.AdTagURLString.replacingOccurrences(of: "[CACHEBUSTER]", with:currentTimeStamp)
      }
      print("CatchupVideoPlayer.AdTagURLString",CatchupVideoPlayer.AdTagURLString)
      

    }
    

    // MARK: - IMAAdsLoaderDelegate

    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        print("IMAAdsLoadedData")
        adsManager = adsLoadedData.adsManager
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsRenderingSettings.webOpenerPresentingController = self
        adsManager.initialize(with: adsRenderingSettings)
        adsManager.delegate = self
    }

    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
      print("Error loading ads: " + adErrorData.adError.message)
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
        if top is CatchupVideoPlayer {
        print("topcontroller5",topController)
            showContentPlayer()
            playerViewController.player?.play()
              self.videoPlayingError(error_code: String(format: "%d", adErrorData.adError.code.rawValue), error_message: String(format: "%@", adErrorData.adError.message))       //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
        }
     
     
    }
    // MARK: - IMAAdsManagerDelegate

      func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print("didReceive event")
        // Play each ad once it has been loaded
        if event.type == IMAAdEventType.LOADED {
          adsManager.start()
        }
       
      }
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Fall back to playing content
        print("AdsManager error: " + error.message)
       
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is CatchupVideoPlayer {
        print("topcontroller5",topController)

            showContentPlayer()
            playerViewController.player?.play()
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
        }
       
      }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
      // Pause the content for the SDK to play ads.
        print("adsManagerDidRequestContentPause")
        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is CatchupVideoPlayer {
        print("topcontroller5",topController)

            playerViewController.player?.pause()
            hideContentPlayer()
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
        }
      
    }

    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
      // Resume the content since the SDK is done playing ads (at least for now).
        print("adsManagerDidRequestContentResume")

        let topController = UIApplication.topViewController()
        let top = topController as! UIViewController
       
        if top is CatchupVideoPlayer {
        print("topcontroller5",topController)

            showContentPlayer()
            playerViewController.player?.play()
            //do something if it's an instance of that class
        }
        else{
            print("topcontroller error",topController)
            commonClass.stopActivityIndicator(onViewController: self)
            playerViewController.player?.pause()
        }
    }
    
    
    
}


