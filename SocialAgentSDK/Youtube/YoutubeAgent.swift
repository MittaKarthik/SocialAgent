//
//  YoutubeAgent.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class YoutubeAgent: SocialAgentDelegate, LoginDelegate
{
    //MARK: - Initializers
    static let sharedInstance = YoutubeAgent()
    private init() {
        self.userModel.userConstants = setUpUserPersistanceConstants()
    }
    
    var completionBlock: CompletionBlock?
    
    var userModel = SocialAgentUserModel()
    private var loginView : SocialAgentLoginView!

    
    //MARK: - Authentication methods
    func login(completion: CompletionBlock)
    {
        self.completionBlock = completion
        if self.loginView != nil
        {
            self.loginView == nil
        }
        
        let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        self.loginView = NSBundle.mainBundle().loadNibNamed(ThisConstants.loginNIBName, owner:topViewController, options: nil)[0] as! SocialAgentLoginView
        self.loginView.delegate = self
        self.loginView.localLoginData = ThisConstants.YTLoginData
        self.loginView.createTheWebviewRequest()
        topViewController?.view.addSubview(self.loginView)
        topViewController?.view.bringSubviewToFront(self.loginView)

    }
    
    func loginAndGetUserInfo(completion: CompletionBlock) {
        self.login { (error) -> () in
            if error != nil {
                completion(error: error)
            }
            else {
                self.getChannelInfoFor(nil, completion: { (error) -> () in
                    completion(error: error)

                })
            }
        }
    }
    
    func logout(completion: CompletionBlock)
    {
        self.userModel.clearAllData()
        completion(error: nil)
    }
    
    
    
    //MARK: - Validation and refreshing methods
    private func validateAccessToken(completion: (validationSuccess: Bool) -> Void) {
        
        if self.userModel.accessToken != nil {
            var timeIntervalSinceTokenIssue = self.userModel.accessTokenIssueTime!.timeIntervalSinceNow
            if timeIntervalSinceTokenIssue < 0 {
                timeIntervalSinceTokenIssue = timeIntervalSinceTokenIssue * (-1)
            }
            if timeIntervalSinceTokenIssue < self.userModel.expiresIn! {
                completion(validationSuccess: true)
            }
            else {
                self.refreshAccessToken({ (error) -> Void in
                    if error == nil {
                        completion(validationSuccess: true)
                    }
                })
            }
        }
        else {
            completion(validationSuccess: false)
        }
    }
    
    func getAccessToken(sToken: String, completion: CompletionBlock) {
        let postbody: String = "code=\(sToken)&client_id=\(SocialAgentSettings.getYouTubeClientID())&client_secret=\(SocialAgentSettings.getYouTubeClientSecret())&redirect_uri=http://localhost/oauth2callback&grant_type=authorization_code"
        let postData: NSData = postbody.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: "https://accounts.google.com/o/oauth2/token")
        request.HTTPMethod = HTTPMethodString.POST.getString()
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let dataObtained = data {
                            do {
                                if let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves) as? NSDictionary {
                                    var count = 0
                                    if let accessToken = json["access_token"] as? String {
                                        self.userModel.accessToken = accessToken
                                        count++
                                    }
                                    if let expiresIn = json["expires_in"] as? Double {
                                        self.userModel.expiresIn = expiresIn
                                        count++
                                    }
                                    if let refreshToken = json["refresh_token"] as? String {
                                        self.userModel.refreshToken = refreshToken
                                        count++
                                    }
                                    if count >= 2 {
                                        completion(error: nil)
                                    }
                                    else {
                                        completion(error: NSError(domain: "Missing Data from API response", code: 2, userInfo: nil))
                                    }
                                }
                            }
                            catch {
                                
                            }
                        }
                    }
                }
            }
            else {
                completion(error: error)
                NSLog("Get Token Error: %@", error!.description)
            }
        }
        task.resume()
    }
    
    func refreshAccessToken(completion: (error: NSError?) -> Void) {
        let postbody: String = "client_id=\(SocialAgentSettings.getYouTubeClientID())&client_secret=\(SocialAgentSettings.getYouTubeClientSecret())&refresh_token=\(self.userModel.refreshToken!)&grant_type=refresh_token"
        let postData: NSData = postbody.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: "https://accounts.google.com/o/oauth2/token")
        request.HTTPMethod = HTTPMethodString.POST.getString()
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let dataObtained = data {
                            do {
                                if let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves) as? NSDictionary {
                                    var count = 0
                                    if let accessToken = json["access_token"] as? String {
                                        self.userModel.accessToken = accessToken
                                        count++
                                    }
                                    if let expiresIn = json["expires_in"] as? Double {
                                        self.userModel.expiresIn = expiresIn
                                        count++
                                    }
                                    if count == 2 {
                                        completion(error: nil)
                                    }
                                    else {
                                        completion(error: NSError(domain: "Missing Data from API response", code: 2, userInfo: nil))
                                    }
                                    
                                }
                                else {
                                    completion(error: NSError(domain: "No JSON response", code: 5, userInfo: nil))
                                }
                                
                            }
                            catch {
                                
                            }
                        }
                    }
                    else {
                        if let dataObtained = data {
                            do {
                                    let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves)
                                    completion(error: NSError(domain: "Response code not 200", code: 6, userInfo: json as? [NSObject : AnyObject]))
                            }
                            catch {
                                
                            }
                        }
                    }
                }
            }
            else {
                completion(error: error)
            }
        }
        task.resume()
    }
    
    //MARK: - Getting user info methods
    func getChannelInfoFor(channelID: String?, completion: CompletionBlock) {
        self.validateAccessToken { (validationSuccess) -> Void in
            if validationSuccess {
                let request: NSMutableURLRequest = NSMutableURLRequest()
                var URLString = ""
                if let channelID = channelID {
                    URLString = APIResponseDictionaryKeys.APIBaseURL + "id=\(channelID)&key=\(SocialAgentSettings.getYouTubeApiKey())"
                }
                else {
                    URLString = APIResponseDictionaryKeys.APIBaseURL + "mine=true&key=\(SocialAgentSettings.getYouTubeApiKey())"
                }
                request.URL = NSURL(string: URLString)
                request.HTTPMethod = HTTPMethodString.GET.getString()
                request.setValue("Bearer \(self.userModel.accessToken!)", forHTTPHeaderField: "Authorization")
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if error == nil {
                        if let httpResponse = response as? NSHTTPURLResponse {
                            if httpResponse.statusCode == 0 {
                            }
                            else {
                                if let dataObtained = data {
                                    do {
                                        if let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves) as? NSDictionary {
                                            if let channels = json["items"] as? NSArray {
                                                if let channelDetails = channels[0] as? NSDictionary {
                                                    if let channelStatistics = channelDetails["statistics"] as? NSDictionary {
                                                        if let subscriberCount = channelStatistics["subscriberCount"] as? String {
                                                            self.userModel.subscriberCount = subscriberCount
                                                        }
                                                        if let videoCount = channelStatistics["videoCount"] as? String {
                                                            self.userModel.videoCount = videoCount
                                                        }
                                                        if let viewCount = channelStatistics["viewCount"] as? String {
                                                            self.userModel.viewCount = viewCount
                                                        }
                                                    }
                                                    if let channelID = channelDetails["id"] as? String {
                                                        self.userModel.channelID = channelID
                                                    }
                                                }
                                            }
                                            completion(error: nil)
                                        }
                                        else {
                                            completion(error: NSError(domain: "JSON Parsing Error", code: 3, userInfo: nil))
                                        }
                                        
                                    }
                                    catch {
                                        completion(error: NSError(domain: "JSON Parsing Error", code: 3, userInfo: nil))
                                    }
                                }
                            }
                        }
                    }
                    else {
                        completion(error: error)
                    }
                }
                task.resume()
            }
            else {
                completion(error: NSError(domain: "No Token", code: 0, userInfo: nil))
            }
        }
    }
    
    
    //Login Delegate Methods
    
    func didLoginCompleteSuccessfully(userInfo: [String : String]?) {
        let dict = userInfo!
        let sToken = dict[SocialAgentConstants.youtubeSTokenKey]!
        self.getAccessToken(sToken) { (error) -> () in
            if let completion = self.completionBlock {
                self.removeTheLoginView()
                completion(error: nil)
            }
        }
        
    }
    
    func didUserCancelLogin(userInfo: [String : String]?) {
        if let completion = self.completionBlock {
            self.removeTheLoginView()
            completion(error: NSError(domain: SocialAgentConstants.authenticationCancelMsg, code: 1, userInfo: nil))
        }
    }
    
    func removeTheLoginView()
    {
        if self.loginView != nil
        {
            self.loginView.removeFromSuperview()
            self.loginView = nil
        }
    }
    
}

extension YoutubeAgent {
    
    //MARK: - Constants
    struct ThisConstants
    {
        static let loginNIBName = "SocialAgentLoginView"
        
        static let accessTokenKey = "YTaccessToken"
        static let userIDKey = "YTuserID"
        static let fullNameKey = "YTfullName"
        static let userNameKey = "YTuserName"
        static let bioKey = "YTbio"
        static let followedByCountKey = "YTfollowedByCount"
        static let followsCountKey = "YTfollowsCount"
        static let mediaCountKey = "YTmediaCount"
        
        static let accessTokenIssueTimeKey = "YTaccessTokenIssueTimeKey"
        static let expiresInKey = "YTexpiresInKey"
        static let refreshTokenKey = "YTrefreshTokenKey"
        static let channelIDKey = "YTchannelIDKey"
        static let subscriberCount = "YTsubscriberCount"
        static let videoCountKey = "YTvideoCountKey"
        static let viewCountKey = "YTviewCountKey"
        
        
        static let oAuthToken = "YToAuthToken"
        static let oAuthTokenSecret = "YToAuthTokenSecret"
        
        static let YTLoginData = loginData(
            naviGationTitle: "Google Login",
            requestURL: "https://accounts.google.com/o/oauth2/auth?client_id=\(SocialAgentSettings.getYouTubeClientID())&redirect_uri=http://localhost/oauth2callback&scope=\(SocialAgentConstants.youtubeScope)&response_type=code&access_type=offline",
            cookieDomainName: "accounts.google.com",
            rangeCheckingString: "http://localhost/oauth2callback?code=",
            accessTokenLimiterString: "code=",
            socialProfile: SocialAgentType.YouTube
        )
        
    }
    
    private struct APIResponseDictionaryKeys {
        static let APIBaseURL = "https://www.googleapis.com/youtube/v3/channels?part=id,statistics,status,topicDetails&"
        static let bioKey = "description"
        static let followedByCountKey = "followers_count"
        static let followsCountKey = "friends_count"
        static let userNameKey = "screen_name"
        static let fullNameKey = "name"
    }
    
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants {
        let youTubePersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        youTubePersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        youTubePersistanceConstants.userIDKey = ThisConstants.userIDKey
        youTubePersistanceConstants.fullNameKey = ThisConstants.fullNameKey
        youTubePersistanceConstants.userNameKey = ThisConstants.userNameKey
        youTubePersistanceConstants.bioKey = ThisConstants.bioKey
        youTubePersistanceConstants.followedByCountKey = ThisConstants.followedByCountKey
        youTubePersistanceConstants.followsCountKey = ThisConstants.followsCountKey
        youTubePersistanceConstants.mediaCountKey = ThisConstants.mediaCountKey
        
        youTubePersistanceConstants.accessTokenIssueTimeKey = ThisConstants.accessTokenIssueTimeKey
        youTubePersistanceConstants.expiresInKey = ThisConstants.expiresInKey
        youTubePersistanceConstants.refreshTokenKey = ThisConstants.refreshTokenKey
        youTubePersistanceConstants.channelIDKey = ThisConstants.channelIDKey
        youTubePersistanceConstants.subscriberCount = ThisConstants.subscriberCount
        youTubePersistanceConstants.videoCountKey = ThisConstants.videoCountKey
        youTubePersistanceConstants.viewCountKey = ThisConstants.viewCountKey
        
        return youTubePersistanceConstants
    }
}