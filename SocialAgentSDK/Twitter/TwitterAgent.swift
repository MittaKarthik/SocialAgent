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
    private var loginView : SocialAgentLoginView!

    var twitterHandle = STTwitterAPI()
    let accountStore = ACAccountStore()
    
    //MARK: - Authentication methods
    func login(completion: CompletionBlock)
    {
        twitterHandle = STTwitterAPI(OAuthConsumerKey: SocialAgentSettings.getTwitterConsumerKey(), consumerSecret: SocialAgentSettings.getTwitterConsumerSecret())
        self.completionBlock = completion
        
        twitterHandle.postTokenRequest({(url: NSURL!, oauthToken: String!) in
     
            if self.loginView != nil
            {
                self.loginView == nil
            }
            
            let topViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            self.loginView = NSBundle.mainBundle().loadNibNamed(ThisConstants.loginNIBName, owner:topViewController, options: nil)[0] as! SocialAgentLoginView
            self.loginView.delegate = self
            self.loginView.localLoginData = ThisConstants.TWTloginData
            self.loginView.createTheWebviewRequest()
            topViewController?.view.addSubview(self.loginView)
            topViewController?.view.bringSubviewToFront(self.loginView)
            let request: NSURLRequest = NSURLRequest(URL: url)
            self.loginView.loginWebview.loadRequest(request)

            }, authenticateInsteadOfAuthorize: false, forceLogin: true, screenName: nil, oauthCallback: ThisConstants.TWTloginData.rangeCheckingString, errorBlock: {(error: NSError!) in
        })
    }
    
    //Login+UserInfo
    
    func loginAndGetUserInfo(completion: CompletionBlock) {
        self.login { (error) -> () in
            if error == nil {
                self.getUserInfoFor(nil, userID: self.userModel.userID, completion: { (error) -> () in
                    completion(error: error)
                })
            }
            else {
                completion(error: error)
            }
        }
    }
    
    
    //MARK: - Getting user info methods
    func getUserInfoFor(screenName: String?, userID: String?, completion: CompletionBlock)
    {
        twitterHandle.getUsersLookupForScreenName(screenName, orUserID: userID, includeEntities: 5, successBlock: { (outPut) -> Void in
            if let dict = outPut[0] as? NSDictionary {
                if let bio = dict[APIResponseDictionaryKeys.bioKey] as? String {
                    self.userModel.bio = bio
                }
                if let followedByCount = dict[APIResponseDictionaryKeys.followedByCountKey] as? Int {
                    self.userModel.followedByCount = followedByCount
                }
                if let followersCount = dict[APIResponseDictionaryKeys.followsCountKey] as? Int {
                    self.userModel.followsCount = followersCount
                }
                if let username = dict[APIResponseDictionaryKeys.userNameKey] as? String {
                    self.userModel.userName = username
                }
                if let fullName = dict[APIResponseDictionaryKeys.fullNameKey] as? String {
                    self.userModel.fullName = fullName
                }
                
                
            }
            completion(error: nil)
            }) { (error) -> Void in
                completion(error: error)
        }
    }
    
    
    //Logout
    
    func logout(completion: CompletionBlock)
    {
        self.userModel.clearAllData()
        completion(error: nil)
    }
    
    //MARK: - Validation and refreshing methods
    
    //Login Delegate Methods
    
    func didLoginCompleteSuccessfully(userInfo: [String : String]?) {
        let dict = userInfo!
        let oAuthVerifier = dict[SocialAgentConstants.twitterOAuthVerifierKey]!
        twitterHandle.postAuthAccessTokenRequestWith(oAuthVerifier, successBlock: { (oAuth_token, oAuth_tokenSecret, userId, screenName) -> Void in
            
            self.userModel.oAuthToken = oAuth_token
            self.userModel.oAuthTokenSecret = oAuth_tokenSecret
            self.userModel.userID = userId
            self.userModel.userName = screenName
            
            if let completion = self.completionBlock {
                self.removeTheLoginView()
                completion(error: nil)
            }
            
            }) { (error) -> Void in
                if let completion = self.completionBlock {
                    self.removeTheLoginView()
                    completion(error: error)
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


extension TwitterAgent {
    
    //MARK: - Constants
    private struct ThisConstants
    {
        static let loginNIBName = "SocialAgentLoginView"
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
    
    private struct APIResponseDictionaryKeys {
        static let bioKey = "description"
        static let followedByCountKey = "followers_count"
        static let followsCountKey = "friends_count"
        static let userNameKey = "screen_name"
        static let fullNameKey = "name"
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