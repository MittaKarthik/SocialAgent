//
//  FacebookAgent.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class FacebookAgent: SocialAgentDelegate
{
    //MARK: - Initializers
    static let sharedInstance = FacebookAgent()
    private init() {
        self.userModel.userConstants = setUpUserPersistanceConstants()
    }
    //This prevents others from using the default '()' initializer for this class.

    
    var userModel = SocialAgentUserModel()

    
    //MARK: - Application level observers
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        FBSDKAppEvents.activateApp()
    }

    //MARK: - Authentication methods
    func login(completion: CompletionBlock)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.SystemAccount
        
        fbLoginManager.logInWithReadPermissions(nil, handler: { (result, error) -> Void in
            if ((error) != nil)
            {
                // Process error
                fbLoginManager.logOut()
                completion(error: NSError(domain:SocialAgentConstants.authenticationCancelMsg, code: 1, userInfo: [NSLocalizedDescriptionKey: SocialAgentConstants.authenticationCancelMsg,NSLocalizedFailureReasonErrorKey: SocialAgentConstants.authenticationCancelMsg]))
            }
            else if result.isCancelled
            {
                // Handle cancellations
                fbLoginManager.logOut()
                completion(error: NSError(domain:SocialAgentConstants.authenticationCancelMsg, code: 1, userInfo: [NSLocalizedDescriptionKey: SocialAgentConstants.authenticationCancelMsg,NSLocalizedFailureReasonErrorKey: SocialAgentConstants.authenticationCancelMsg]))
            }
            else {
                
                completion(error: nil)
                //Success. Retrieve the user data
            }
        })

    }

    func loginAndGetUserInfo(completion: CompletionBlock) {
        self.login { (error) -> () in
            if let error = error {
                completion(error: error)
            }
            else {
                self.getUserInfo({ (error) -> () in
                    completion(error: error)
                })
            }
        }
    }
    
    func logout(completion: CompletionBlock)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        self.userModel.clearAllData()
        completion(error: nil)
    }
    
    func getChannelInfo(completion: CompletionBlock) {
        
    }
    
    //MARK: - Reconnection
    
    func connectSocialAccount(withDetails: SAConnectionDetails, completion: CompletionBlock) {
        self.userModel.accessToken = withDetails.accessToken
        self.userModel.userID = withDetails.uniqueID
        self.userModel.userName = withDetails.userName
        completion(error: nil)
    }
    
    func getSocialAccountInfo() -> SAConnectionDetails
    {
        return SAConnectionDetails(uniqueID: self.userModel.userID!, accessToken: self.userModel.accessToken!, userName: self.userModel.userName!, refreshToken: nil, expirationTime: nil)
    }
    
    //MARK: - Getting user info methods
      func getUserInfo(completion: CompletionBlock)
      {
        self.validateAccessToken { (validationSuccess) -> Void in
            if validationSuccess == true
            {
                FBSDKGraphRequest(graphPath:ThisConstants.fbUserInfoPath, parameters:ThisConstants.fbUserFields).startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if (error == nil)
                    {
                        self.userModel.userID = FBSDKAccessToken.currentAccessToken().userID
                        self.userModel.accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                        self.userModel.expiresAt = FBSDKAccessToken.currentAccessToken().expirationDate.timeIntervalSince1970
                        self.userModel.userName = result[ThisConstants.fbName] as? String
                        self.userModel.userEmailId = result[ThisConstants.fbEmail] as? String
                        self.userModel.age = result.objectForKey(ThisConstants.fbAgeRange)?.objectForKey(ThisConstants.fbAgeMin) as? String
                        if let profilePicURL = result.objectForKey(ThisConstants.fbPicture)?.objectForKey(ThisConstants.fbPicData)?.objectForKey(ThisConstants.fbPicUrl) {
                            self.userModel.profilePicUrl = profilePicURL as? String
                        }
                        self.userModel.gender = result[ThisConstants.gender] as? String 
                        
                        completion(error: nil)
                        
                    }
                    else
                    {
                        completion(error: error)
                    }
                })
                
            }
            else
            {
                completion(error: NSError(domain:SocialAgentConstants.authenticationFailedMsg, code: 1, userInfo: [NSLocalizedDescriptionKey: SocialAgentConstants.authenticationFailedMsg,NSLocalizedFailureReasonErrorKey: SocialAgentConstants.authenticationFailedMsg]))
            }
        }
    }
    

    //MARK: - Validation and refreshing methods
    private func validateAccessToken(completion: (validationSuccess: Bool) -> Void) {
        
        if self.userModel.accessToken != nil {
            let presentTime = NSDate().timeIntervalSince1970
            if presentTime < self.userModel.expiresAt! {
                completion(validationSuccess: true)
            }
            else {
               self.refreshAccessToken({ (error) -> () in
                if error != nil
                {
                    completion(validationSuccess: false)
                }
                else
                {
                    completion(validationSuccess: true)
                }
               })
            }
        }
        else {
            completion(validationSuccess: true)
        }
    }
    
    
    func refreshAccessToken(compeltion : CompletionBlock)
    {
        FBSDKAccessToken.refreshCurrentAccessToken { (connection, result, error) -> Void in
            self.userModel.accessToken = FBSDKAccessToken.currentAccessToken().tokenString ?? ""
            self.userModel.expiresAt = FBSDKAccessToken.currentAccessToken().expirationDate.timeIntervalSince1970
            compeltion(error: nil)
        }
    }
    
    func getPageInfo()
    {
        
//        /me/accounts - get graph api service
//        
//        /1575574989362988?fields=country_page_likes - get graph api service for page likes
//            
//            /me/friends - get graph api service for friends list.
        
        
                        FBSDKGraphRequest(graphPath:"me/posts", parameters: ["fields": "likes"] , HTTPMethod: "GET").startWithCompletionHandler({ (connection, result, error) -> Void in
        
        
                            print(result as! Dictionary<String, AnyObject>)
        
        
                        })
        
                        //Archieve and store the user data in UserDefaults
//                        let userData = NSKeyedArchiver.archivedDataWithRootObject(self.fbObject)
//                        NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "CurrentUser")
//                        print("Saved")
//                        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

extension FacebookAgent {
    
    //MARK: - Constants
    private struct ThisConstants
    {
        // FB constants
        static let fbName = "name"
        static let fbEmail = "email"
        static let fbAgeRange = "age_range"
        static let fbAgeMin = "min"
        static let fbPicture = "picture"
        static let fbPicData = "data"
        static let fbPicUrl = "url"

        static let accessTokenKey = "fbAccessToken"
        static let accessTokenIssueTimeKey = "fbAccessTokenIssueTimeKey"
        static let expiresInKey = "fbExpiresInKey"
        static let profilePicUrlKey = "fbProfilePicUrlKey"
        static let userIDKey = "fbUserID"
        static let userNameKey = "fbUserName"
        static let ageKey = "fbUserAge"
        static let email = "fbEmail"
        static let gender = "fbGender"
        static let pageFollowCount = "fbPageFollowCount"
        static let fbUserInfoPath = "me"
        static let fbPermissionsArray = ["public_profile", "email", "read_stream", "user_likes", "user_friends"]
        static let fbUserFields = ["fields": "id, name, picture.type(large), email, location, age_range, gender, likes"]
    }
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants
    {
        let facebookPersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        facebookPersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        facebookPersistanceConstants.userIDKey = ThisConstants.userIDKey
        facebookPersistanceConstants.userNameKey = ThisConstants.userNameKey
        facebookPersistanceConstants.ageKey = ThisConstants.ageKey
        facebookPersistanceConstants.genderKey = ThisConstants.gender
        facebookPersistanceConstants.pageFollowCountKey = ThisConstants.pageFollowCount
        facebookPersistanceConstants.emailKey = ThisConstants.email
        facebookPersistanceConstants.accessTokenIssueTimeKey = ThisConstants.accessTokenIssueTimeKey
        facebookPersistanceConstants.expiresInKey = ThisConstants.expiresInKey
        facebookPersistanceConstants.profilePicUrlKey = ThisConstants.profilePicUrlKey
        return facebookPersistanceConstants
    }
    
}
