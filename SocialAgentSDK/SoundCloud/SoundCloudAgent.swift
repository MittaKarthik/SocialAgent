//
//  File.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 11/5/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class SoundCloudAgent: SocialAgentDelegate, LoginDelegate
{
    //MARK: - Initializers
    static let sharedInstance = SoundCloudAgent()
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
    private func validateAccessToken(completion: (validationSuccess: Bool, didUpdate: Bool) -> Void) {
        
        if self.userModel.accessToken != nil {
            let presentTime = NSDate().timeIntervalSince1970
            if presentTime < self.userModel.expiresAt! {
                completion(validationSuccess: true, didUpdate: false)
            }
            else {
                self.refreshAccessToken({ (error) -> Void in
                    if error == nil {
                        completion(validationSuccess: true, didUpdate: true)
                    }
                    else {
                        completion(validationSuccess: false, didUpdate: true)
                    }
                })
            }
        }
        else {
            completion(validationSuccess: false, didUpdate: true)
        }
    }
    
    func getAccessToken(sToken: String, completion: CompletionBlock) {
        let postbody: String = "code=\(sToken)&client_id=\(SocialAgentSettings.getSoundCloudClientID())&client_secret=\(SocialAgentSettings.getSoundCloudClientSecret())&redirect_uri=http://localhost/oauth2&grant_type=authorization_code"
        
        let postData: NSData = postbody.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: "https://api.soundcloud.com/oauth2/token")
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
                                    print(json)
                                    var count = 0
                                    if let accessToken = json["access_token"] as? String {
                                        self.userModel.accessToken = accessToken
                                        count++
                                    }
                                    if let expiresAt = json["expires_in"] as? Double {
                                        self.userModel.expiresAt = NSDate().timeIntervalSince1970 + expiresAt
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
                                    if let expiresAt = json["expires_in"] as? Double {
                                        self.userModel.expiresAt = NSDate().timeIntervalSince1970 + expiresAt
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
        self.validateAccessToken { (validationSuccess, didUpdate) -> Void in
            if validationSuccess {
                let request: NSMutableURLRequest = NSMutableURLRequest()
                var URLString = ""
                if let userID = identifier {
                    URLString = APIResponseDictionaryKeys.APIBaseURL + "users/\(userID)?client_id=\(SocialAgentSettings.getSoundCloudClientID())"
                }
                else {
                    URLString = APIResponseDictionaryKeys.APIBaseURL + "me?oauth_token=\(self.userModel.accessToken!)"
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
                                            
                                            if let followedByCount = json["followers_count"] as? Int {
                                                self.userModel.followedByCount = followedByCount
                                            }
                                            if let followsCount = json["followings_count"] as? Int {
                                                self.userModel.followsCount = followsCount
                                            }
                                            if let userID = json["id"] as? Int {
                                                self.userModel.userID = String(userID)
                                            }
                                            if let fullName = json["full_name"] as? String {
                                                self.userModel.fullName = fullName
                                            }
                                            if let bio = json["description"] as? String {
                                                self.userModel.bio = bio
                                            }
                                            if let userName = json["username"] as? String {
                                                self.userModel.userName = userName
                                            }
                                            if let mediaCount = json["track_count"] as? Int {
                                                self.userModel.mediaCount = mediaCount
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
    
    //MARK: - Reconnection
    
    func connectSocialAccount(withDetails: SAConnectionDetails, completion: CompletionBlock) {
        self.userModel.accessToken = withDetails.accessToken
        self.userModel.refreshToken = withDetails.refreshToken!
        self.userModel.expiresAt = withDetails.expirationTime!
        self.userModel.userID = withDetails.uniqueID
        self.userModel.userName = withDetails.userName
        self.validateAccessToken { (validationSuccess, didUpdate) -> Void in
            if validationSuccess {
                if didUpdate {
                    completion(error: nil)
                }
                else {
                    completion(error: nil)
                }
            }
            else {
                completion(error: NSError(domain:"Reconnection failed", code: 65, userInfo: [NSLocalizedDescriptionKey: "Reconnection failed", NSLocalizedFailureReasonErrorKey: "Reconnection failed"]))
            }
        }
    }
    
    func getSocialAccountInfo() -> SAConnectionDetails
    {
        return SAConnectionDetails(uniqueID: self.userModel.userID!, accessToken: self.userModel.accessToken!, userName: self.userModel.userName!, refreshToken: self.userModel.refreshToken!, expirationTime: self.userModel.expiresAt)
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

extension SoundCloudAgent {
    
    //MARK: - Constants
    struct ThisConstants
    {
        static let loginNIBName = "SocialAgentLoginView"
        
        static let accessTokenKey = "SCaccessToken"
        static let userIDKey = "SCuserID"
        static let fullNameKey = "SCfullName"
        static let userNameKey = "SCuserName"
        static let bioKey = "SCbio"
        static let followedByCountKey = "SCfollowedByCount"
        static let followsCountKey = "SCfollowsCount"
        static let mediaCountKey = "SCmediaCount"
        
        static let accessTokenIssueTimeKey = "SCaccessTokenIssueTimeKey"
        static let expiresInKey = "SCexpiresInKey"
        static let refreshTokenKey = "SCrefreshTokenKey"
        static let channelIDKey = "SCchannelIDKey"
        static let subscriberCount = "SCsubscriberCount"
        static let videoCountKey = "SCvideoCountKey"
        static let viewCountKey = "SCviewCountKey"
        
        
        static let oAuthToken = "SCoAuthToken"
        static let oAuthTokenSecret = "SCoAuthTokenSecret"
        
        static let SCLoginData = loginData (
            naviGationTitle: "SoundCloud Login",
            requestURL: "https://soundcloud.com/connect" + "?client_id=\(SocialAgentSettings.getSoundCloudClientID())&redirect_uri=http://localhost/oauth2&response_type=code&display=popup",
            cookieDomainName: "soundcloud.com",
            rangeCheckingString: "http://localhost/oauth2?code=",
            accessTokenLimiterString: "code=",
            socialProfile: SocialAgentType.SoundCloud
        )
        
    }
    
    private struct APIResponseDictionaryKeys {
        static let APIBaseURL = "https://api.soundcloud.com/"
        static let bioKey = "description"
        static let followedByCountKey = "followers_count"
        static let followsCountKey = "friends_count"
        static let userNameKey = "screen_name"
        static let fullNameKey = "name"
    }
    
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants {
        let soundCloudPersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        soundCloudPersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        soundCloudPersistanceConstants.userIDKey = ThisConstants.userIDKey
        soundCloudPersistanceConstants.fullNameKey = ThisConstants.fullNameKey
        soundCloudPersistanceConstants.userNameKey = ThisConstants.userNameKey
        soundCloudPersistanceConstants.bioKey = ThisConstants.bioKey
        soundCloudPersistanceConstants.followedByCountKey = ThisConstants.followedByCountKey
        soundCloudPersistanceConstants.followsCountKey = ThisConstants.followsCountKey
        soundCloudPersistanceConstants.mediaCountKey = ThisConstants.mediaCountKey
        
        soundCloudPersistanceConstants.accessTokenIssueTimeKey = ThisConstants.accessTokenIssueTimeKey
        soundCloudPersistanceConstants.expiresInKey = ThisConstants.expiresInKey
        soundCloudPersistanceConstants.refreshTokenKey = ThisConstants.refreshTokenKey
        soundCloudPersistanceConstants.channelIDKey = ThisConstants.channelIDKey
        soundCloudPersistanceConstants.subscriberCount = ThisConstants.subscriberCount
        soundCloudPersistanceConstants.videoCountKey = ThisConstants.videoCountKey
        soundCloudPersistanceConstants.viewCountKey = ThisConstants.viewCountKey
        
        return soundCloudPersistanceConstants
    }
}
