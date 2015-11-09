//
//  MixCloudAgent.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 11/9/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class MixCloudAgent: SocialAgentDelegate, LoginDelegate
{
    //MARK: - Initializers
    static let sharedInstance = MixCloudAgent()
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
            self.loginView = nil
        }
        
        let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        self.loginView = NSBundle.mainBundle().loadNibNamed(ThisConstants.loginNIBName, owner:topViewController, options: nil)[0] as! SocialAgentLoginView
        self.loginView.delegate = self
        self.loginView.localLoginData = ThisConstants.SCLoginData
        self.loginView.createTheWebviewRequest()
        topViewController?.view.addSubview(self.loginView)
        topViewController?.view.bringSubviewToFront(self.loginView)
    }
    
    func loginAndGetUserInfo(completion: CompletionBlock) {
        self.login { [weak self] (error) -> () in
            if error != nil {
                completion(error: error)
            }
            else {
                self?.getUserInfoFor(nil, completion: { (error) -> () in
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
    
    func getAccessToken(sToken: String, completion: CompletionBlock) {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: "https://www.mixcloud.com/oauth/access_token?client_id=\(SocialAgentSettings.getMixCloudClientID())&redirect_uri=http://localhost/oauth2&client_secret=\(SocialAgentSettings.getMixCloudClientSecret())&code=\(sToken)")
        request.HTTPMethod = HTTPMethodString.POST.getString()
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let dataObtained = data {
                            do {
                                if let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves) as? NSDictionary {
                                    print(json)
                                    if let accessToken = json["access_token"] as? String {
                                        self.userModel.accessToken = accessToken
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
    
    func getUserInfoFor(identifier: String?, completion: CompletionBlock) {
        if let accessToken = self.userModel.accessToken {
            
            let request: NSMutableURLRequest = NSMutableURLRequest()
            var URLString = ""
            if let userName = identifier {
                URLString = APIResponseDictionaryKeys.APIBaseURL + "\(userName)/?access_token=\(accessToken)"
            }
            else {
                URLString = APIResponseDictionaryKeys.APIBaseURL + "me/?access_token=\(accessToken)"
            }
            request.URL = NSURL(string: URLString)
            request.HTTPMethod = HTTPMethodString.GET.getString()
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
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
                                        
                                        if let followedByCount = json["follower_count"] as? Int {
                                            self.userModel.followedByCount = followedByCount
                                        }
                                        if let followsCount = json["following_count"] as? Int {
                                            self.userModel.followsCount = followsCount
                                        }
                                        if let fullName = json["name"] as? String {
                                            self.userModel.fullName = fullName
                                        }
                                        if let bio = json["biog"] as? String {
                                            self.userModel.bio = bio
                                        }
                                        if let userName = json["username"] as? String {
                                            self.userModel.userName = userName
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
        else
        {
            completion(error: NSError(domain: "No access token", code: 3, userInfo: nil))
        }
    }
    
    
    //Login Delegate Methods
    
    func didLoginCompleteSuccessfully(userInfo: [String : String]?) {
        let dict = userInfo!
        let authorizationCode = dict[SocialAgentConstants.soundCloudAuthorizationCode]!
        self.getAccessToken(authorizationCode) { (error) -> () in
            if let completion = self.completionBlock {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.removeTheLoginView()
                    completion(error: nil)
                })
            }
        }
        
    }
    
    func didUserCancelLogin(userInfo: [String : String]?) {
        if let completion = self.completionBlock {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeTheLoginView()
                completion(error: NSError(domain: SocialAgentConstants.authenticationCancelMsg, code: 1, userInfo: nil))
            })
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

extension MixCloudAgent {
    
    //MARK: - Constants
    struct ThisConstants
    {
        static let loginNIBName = "SocialAgentLoginView"
        
        static let accessTokenKey = "MCaccessToken"
        static let userIDKey = "MCuserID"
        static let fullNameKey = "MCfullName"
        static let userNameKey = "MCuserName"
        static let bioKey = "MCbio"
        static let followedByCountKey = "MCfollowedByCount"
        static let followsCountKey = "MCfollowsCount"
        static let mediaCountKey = "MCmediaCount"
        
        static let accessTokenIssueTimeKey = "MCaccessTokenIssueTimeKey"
        static let expiresInKey = "MCexpiresInKey"
        static let refreshTokenKey = "MCrefreshTokenKey"
        static let channelIDKey = "MCchannelIDKey"
        static let subscriberCount = "MCsubscriberCount"
        static let videoCountKey = "MCvideoCountKey"
        static let viewCountKey = "MCviewCountKey"
        
        
        static let oAuthToken = "MCoAuthToken"
        static let oAuthTokenSecret = "MCoAuthTokenSecret"
        
        static let SCLoginData = loginData (
            naviGationTitle: "MixCloud Login",
            requestURL: "https://www.mixcloud.com/oauth/authorize?client_id=\(SocialAgentSettings.getMixCloudClientID())&redirect_uri=http://localhost/oauth2",
            cookieDomainName: "mixcloud.com",
            rangeCheckingString: "http://localhost/oauth2?code=",
            accessTokenLimiterString: "code=",
            socialProfile: SocialAgentType.MixCloud
        )
    }
    
    private struct APIResponseDictionaryKeys {
        static let APIBaseURL = "https://api.mixcloud.com/"
        static let bioKey = "description"
        static let followedByCountKey = "followers_count"
        static let followsCountKey = "friends_count"
        static let userNameKey = "screen_name"
        static let fullNameKey = "name"
    }
    
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants {
        let mixCloudPersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        mixCloudPersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        mixCloudPersistanceConstants.userIDKey = ThisConstants.userIDKey
        mixCloudPersistanceConstants.fullNameKey = ThisConstants.fullNameKey
        mixCloudPersistanceConstants.userNameKey = ThisConstants.userNameKey
        mixCloudPersistanceConstants.bioKey = ThisConstants.bioKey
        mixCloudPersistanceConstants.followedByCountKey = ThisConstants.followedByCountKey
        mixCloudPersistanceConstants.followsCountKey = ThisConstants.followsCountKey
        mixCloudPersistanceConstants.mediaCountKey = ThisConstants.mediaCountKey
        
        mixCloudPersistanceConstants.accessTokenIssueTimeKey = ThisConstants.accessTokenIssueTimeKey
        mixCloudPersistanceConstants.expiresInKey = ThisConstants.expiresInKey
        mixCloudPersistanceConstants.refreshTokenKey = ThisConstants.refreshTokenKey
        mixCloudPersistanceConstants.channelIDKey = ThisConstants.channelIDKey
        mixCloudPersistanceConstants.subscriberCount = ThisConstants.subscriberCount
        mixCloudPersistanceConstants.videoCountKey = ThisConstants.videoCountKey
        mixCloudPersistanceConstants.viewCountKey = ThisConstants.viewCountKey
        
        return mixCloudPersistanceConstants
    }
}

