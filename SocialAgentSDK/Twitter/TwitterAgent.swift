//
//  TwitterAgent.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class TwitterAgent: SocialAgentDelegate, LoginDelegate
{
    
    //MARK: - Initializers
    static let sharedInstance = TwitterAgent()
    private init() {
        self.userModel.userConstants = setUpUserPersistanceConstants()
    } //This prevents others from using the default '()' initializer for this class.
    
    var completionBlock: CompletionBlock?
    
    var userModel = SocialAgentUserModel()

    var twitterHandle = STTwitterAPI()
    let accountStore = ACAccountStore()
    
    //MARK: - Authentication methods
    func login(completion: CompletionBlock)
    {
        twitterHandle = STTwitterAPI(OAuthConsumerKey: SocialAgentSettings.getTwitterConsumerKey(), consumerSecret: SocialAgentSettings.getTwitterConsumerSecret())
        self.completionBlock = completion
        
        twitterHandle.postTokenRequest({(url: NSURL!, oauthToken: String!) in
            let window = UIApplication.sharedApplication().keyWindow
            let viewControllerOnTop = window?.rootViewController
            
            let storyboard = UIStoryboard(name: SocialAgentConstants.storyboardName, bundle: nil)
            let twitterSignInVC = storyboard.instantiateViewControllerWithIdentifier(SocialAgentConstants.loginVCStoryboardID) as! LoginVC
            twitterSignInVC.delegate = self
            twitterSignInVC.localLoginData = ThisConstants.TWTloginData
            let naviCon = UINavigationController(rootViewController: twitterSignInVC)
            viewControllerOnTop?.presentViewController(naviCon, animated: true, completion: { () -> Void in
                let request: NSURLRequest = NSURLRequest(URL: url)
                twitterSignInVC.loginWebView.loadRequest(request)
            })
            
            }, authenticateInsteadOfAuthorize: false, forceLogin: true, screenName: nil, oauthCallback: ThisConstants.TWTloginData.rangeCheckingString, errorBlock: {(error: NSError!) in
                print("Error:", error)
        })
    }
    
    //Login+UserInfo
    
    func loginAndGetUserInfo(completion: CompletionBlock) {
        self.login { (error) -> () in
            if error == nil {
                self.getUserInfo(nil, userID: self.userModel.userID, completion: { (error) -> () in
                    completion(error: error)
                })
            }
            else {
                completion(error: error)
            }
        }
    }
    
    func logout(completion: CompletionBlock)
    {
        self.userModel.clearAllData()
        completion(error: nil)
    }
    
    //MARK: - Getting user info methods
    func getUserInfo(screenName: String?, userID: String?, completion: CompletionBlock)
    {
        twitterHandle.getUsersLookupForScreenName(screenName, orUserID: userID, includeEntities: 5, successBlock: { (outPut) -> Void in
            if let dict = outPut[0] as? NSDictionary {
                print(dict)
                
                if let bio = dict["description"] as? String {
                    self.userModel.bio = bio
                }
                if let followedByCount = dict["followers_count"] as? Int {
                    self.userModel.followedByCount = followedByCount
                }
                if let followersCount = dict["friends_count"] as? Int {
                    self.userModel.followsCount = followersCount
                }
                if let username = dict["screen_name"] as? String {
                    self.userModel.userName = username
                }
                if let fullName = dict["name"] as? String {
                    self.userModel.fullName = fullName
                }
                
                
            }
            completion(error: nil)
            }) { (error) -> Void in
                completion(error: error)
        }
    }
    
    func getChannelInfo(completion: CompletionBlock) {
        
    }
    
    //MARK: - Validation and refreshing methods
    
    //Login Delegate Methods
    
    func didLoginCompleteSuccessfully(userInfo: [String : String]?) {
        let dict = userInfo!
        let oAuthVerifier = dict["oAuthVerifier"]!
        twitterHandle.postAuthAccessTokenRequestWith(oAuthVerifier, successBlock: { (oAuth_token, oAuth_tokenSecret, userId, screenName) -> Void in
            
            self.userModel.oAuthToken = oAuth_token
            self.userModel.oAuthTokenSecret = oAuth_tokenSecret
            self.userModel.userID = userId
            self.userModel.userName = screenName
            
            if let completion = self.completionBlock {
                completion(error: nil)
            }
            
            }) { (error) -> Void in
                if let completion = self.completionBlock {
                    completion(error: error)
                }
        }
        
    }
    
    func didUserCancelLogin(userInfo: [String : String]?) {
        if let completion = self.completionBlock {
            completion(error: NSError(domain: "User Cancelled Login", code: 1, userInfo: nil))
        }
    }
}


extension TwitterAgent {
    
    //MARK: - Constants
    private struct ThisConstants
    {
        static let accessTokenKey = "TWTaccessToken"
        static let userIDKey = "TWTuserID"
        static let fullNameKey = "TWTfullName"
        static let userNameKey = "TWTuserName"
        static let bioKey = "TWTbio"
        static let followedByCountKey = "TWTfollowedByCount"
        static let followsCountKey = "TWTfollowsCount"
        static let mediaCountKey = "TWTmediaCount"
        
        static let accessTokenIssueTimeKey = "TWTaccessTokenIssueTimeKey"
        static let expiresInKey = "TWTexpiresInKey"
        static let refreshTokenKey = "TWTrefreshTokenKey"
        static let channelIDKey = "TWTchannelIDKey"
        static let subscriberCount = "TWTsubscriberCount"
        static let videoCountKey = "TWTvideoCountKey"
        static let viewCountKey = "TWTviewCountKey"
        
        static let oAuthToken = "TWToAuthToken"
        static let oAuthTokenSecret = "TWToAuthTokenSecret"
        
        static let TWTloginData = loginData(
            naviGationTitle: "Twitter Login",
            requestURL: "",
            cookieDomainName: "twitter",
            rangeCheckingString: "http://localhost/outh2callback",
            accessTokenLimiterString: "oauth_verifier=",
            socialProfile: SocialAgentType.Twitter
        )
        
    }
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants {
        let twitterPersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        twitterPersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        twitterPersistanceConstants.userIDKey = ThisConstants.userIDKey
        twitterPersistanceConstants.fullNameKey = ThisConstants.fullNameKey
        twitterPersistanceConstants.userNameKey = ThisConstants.userNameKey
        twitterPersistanceConstants.bioKey = ThisConstants.bioKey
        twitterPersistanceConstants.followedByCountKey = ThisConstants.followedByCountKey
        twitterPersistanceConstants.followsCountKey = ThisConstants.followsCountKey
        twitterPersistanceConstants.mediaCountKey = ThisConstants.mediaCountKey
        
        twitterPersistanceConstants.accessTokenIssueTimeKey = ThisConstants.accessTokenIssueTimeKey
        twitterPersistanceConstants.expiresInKey = ThisConstants.expiresInKey
        twitterPersistanceConstants.refreshTokenKey = ThisConstants.refreshTokenKey
        twitterPersistanceConstants.channelIDKey = ThisConstants.channelIDKey
        twitterPersistanceConstants.subscriberCount = ThisConstants.subscriberCount
        twitterPersistanceConstants.videoCountKey = ThisConstants.videoCountKey
        twitterPersistanceConstants.viewCountKey = ThisConstants.viewCountKey
        
        twitterPersistanceConstants.oAuthTokenKey = ThisConstants.oAuthToken
        twitterPersistanceConstants.oAuthTokenSecretKey = ThisConstants.oAuthTokenSecret
        
        return twitterPersistanceConstants
    }
    
    
    
    
}