//
//  InstagramAgent.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/12/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class InstagramAgent: SocialAgentDelegate, LoginDelegate
{
    //Singleton Instance Creation
    static let sharedInstance = InstagramAgent()
    private init() {
        self.userModel.userConstants = setUpUserPersistanceConstants()
    }
    
    var completionBlock: CompletionBlock?
    var userModel = SocialAgentUserModel()
    private var loginView : SocialAgentLoginView!
    
    //MARK: - Login
    func login(completion: CompletionBlock)
    {
        self.completionBlock = completion
        if self.loginView != nil
        {
            self.loginView == nil
        }

        let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        self.loginView = NSBundle.mainBundle().loadNibNamed("SocialAgentLoginView", owner:topViewController, options: nil)[0] as! SocialAgentLoginView
        self.loginView.delegate = self
        self.loginView.localLoginData = ThisConstants.IGloginData
        self.loginView.createTheWebviewRequest()
        topViewController?.view.addSubview(self.loginView)
        topViewController?.view.bringSubviewToFront(self.loginView)
    }
    
    //MARK: - User Info
    func getUserInfoFor(userID: String, completion: CompletionBlock) {
        if let accessToken = userModel.accessToken {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string: APIResponseDictionaryKeys.getUserInfoURL + userID + "/?access_token=\(accessToken)")
            request.HTTPMethod = HTTPMethodString.GET.getString()
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error == nil {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 0 {
                        }
                        else if httpResponse.statusCode == 200 {
                            if let dataObtained = data {
                                do {
                                    if let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves) as? NSDictionary {
                                        if let userInfo = json["data"] as? NSDictionary {
                                            if let bio = userInfo["bio"] as? String {
                                                self.userModel.bio = bio
                                            }
                                            if let fullName = userInfo["full_name"] as? String {
                                                self.userModel.fullName = fullName
                                            }
                                            if let id = userInfo["id"] as? String {
                                                self.userModel.userID = id
                                            }
                                            if let username = userInfo["username"] as? String {
                                                self.userModel.userName = username
                                            }
                                            if let counts = userInfo["counts"] {
                                                if let followedBy = counts["followed_by"] as? Int {
                                                    self.userModel.followedByCount = followedBy
                                                }
                                                if let follows = counts["follows"] as? Int {
                                                    self.userModel.followsCount = follows
                                                }
                                                if let media = counts["media"] as? Int {
                                                    self.userModel.mediaCount = media
                                                }
                                            }
                                            completion(error: nil)
                                        }
                                    }
                                    else {
                                        
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
                }
            }
            task.resume()
        }
        else {
            completion(error: NSError(domain: "No AccessToken", code: 0, userInfo: nil))
        }
    }
    
    //Login+UserInfo
    
    func loginAndGetUserInfo(completion: CompletionBlock) {
        self.login { (error) -> () in
            if error != nil {
                completion(error: error)
            }
            else {
                self.getUserInfoFor("self", completion: { (error) -> () in
                    completion(error: error)
                })
            }
        }
    }
    
 
    //Logout
    
    func logout(completion: CompletionBlock)
    {
        self.userModel.clearAllData()
        completion(error: nil)
    }
    

    
    //Login Delegate Methods
    
    func didLoginCompleteSuccessfully(userInfo: [String : String]?) {
        if let completion = self.completionBlock
        {
            self.removeTheLoginView()
            completion(error: nil)
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

extension InstagramAgent {
    
    //MARK: - Constants
    private struct ThisConstants
    {
        static let accessTokenKey = "IGaccessToken"
        static let userIDKey = "IGuserID"
        static let fullNameKey = "IGfullName"
        static let userNameKey = "IGuserName"
        static let bioKey = "IGbio"
        static let followedByCountKey = "IGfollowedByCount"
        static let followsCountKey = "IGfollowsCount"
        static let mediaCountKey = "IGmediaCount"
        
        static let accessTokenIssueTimeKey = "IGaccessTokenIssueTimeKey"
        static let expiresInKey = "IGexpiresInKey"
        static let refreshTokenKey = "IGrefreshTokenKey"
        static let channelIDKey = "IGchannelIDKey"
        static let subscriberCount = "IGsubscriberCount"
        static let videoCountKey = "IGvideoCountKey"
        static let viewCountKey = "IGviewCountKey"
        
        static let oAuthToken = "IGoAuthToken"
        static let oAuthTokenSecret = "IGoAuthTokenSecret"
        
        static let IGloginData = loginData(
            naviGationTitle: "Instagram Login",
            requestURL: "https://instagram.com/oauth/authorize/?client_id=\(SocialAgentSettings.getInstagramClientId())&redirect_uri=\(SocialAgentConstants.instagramRedirectURI)&response_type=token",
            cookieDomainName: "instagram.com",
            rangeCheckingString: "http://localhost/oauth2#access_token=",
            accessTokenLimiterString: "access_token=",
            socialProfile: SocialAgentType.Instagram
        )
        
    }
    
    private struct APIResponseDictionaryKeys {
        static let getUserInfoURL = "https://api.instagram.com/v1/users/"
        static let bioKey = "description"
        static let followedByCountKey = "followers_count"
        static let followsCountKey = "friends_count"
        static let userNameKey = "screen_name"
        static let fullNameKey = "name"
    }
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants {
        let instagramPersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        instagramPersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        instagramPersistanceConstants.userIDKey = ThisConstants.userIDKey
        instagramPersistanceConstants.fullNameKey = ThisConstants.fullNameKey
        instagramPersistanceConstants.userNameKey = ThisConstants.userNameKey
        instagramPersistanceConstants.bioKey = ThisConstants.bioKey
        instagramPersistanceConstants.followedByCountKey = ThisConstants.followedByCountKey
        instagramPersistanceConstants.followsCountKey = ThisConstants.followsCountKey
        instagramPersistanceConstants.mediaCountKey = ThisConstants.mediaCountKey
        
        instagramPersistanceConstants.accessTokenIssueTimeKey = ThisConstants.accessTokenIssueTimeKey
        instagramPersistanceConstants.expiresInKey = ThisConstants.expiresInKey
        instagramPersistanceConstants.refreshTokenKey = ThisConstants.refreshTokenKey
        instagramPersistanceConstants.channelIDKey = ThisConstants.channelIDKey
        instagramPersistanceConstants.subscriberCount = ThisConstants.subscriberCount
        instagramPersistanceConstants.videoCountKey = ThisConstants.videoCountKey
        instagramPersistanceConstants.viewCountKey = ThisConstants.viewCountKey
        
        return instagramPersistanceConstants
    }
    
    
    
    
}