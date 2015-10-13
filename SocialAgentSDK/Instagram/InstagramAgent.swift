//
//  InstagramAgent.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/12/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class InstagramAgent: SocialAgentDelegate
{
    //Singleton Instance Creation
    static let sharedInstance = InstagramAgent()
    private init() {
        self.userModel.userConstants = setUpUserPersistanceConstants()
    }
    
    var userModel = SocialAgentUserModel()
    //MARK: - Login
    func login(delegate: LoginDelegate, completion: CompletionBlock)
    {
        let window = UIApplication.sharedApplication().keyWindow
        let viewControllerOnTop = window?.rootViewController
        
        let storyboard = UIStoryboard(name: ThisConstants.storyboardName, bundle: nil)
        let instagramSignInVC = storyboard.instantiateViewControllerWithIdentifier(ThisConstants.instagramSignInVCStoryboardID) as! InstagramSignInVC
        instagramSignInVC.delegate = delegate
        let naviCon = UINavigationController(rootViewController: instagramSignInVC)
        viewControllerOnTop?.presentViewController(naviCon, animated: true, completion: { () -> Void in
            print("Presented Instagram SignIn VC")
        })
    }
    
    //MARK: - User Info
    func getUserInfo(completion: CompletionBlock) {
        if let accessToken = userModel.accessToken {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string: "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)")
            request.HTTPMethod = "GET"
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error == nil {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode == 0 {
                            print("Logout")
                        }
                        else if httpResponse.statusCode == 200 {
                            if let dataObtained = data {
                                do {
                                    if let json = try NSJSONSerialization.JSONObjectWithData(dataObtained, options: .MutableLeaves) as? NSDictionary {
                                        print(json)
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
                                            completion(responseObject: json, error: nil)
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
                    print("Get Token Error: %@", error!.description)
                }
            }
            task.resume()
        }
        else {
            completion(responseObject: nil, error: NSError(domain: "No AccessToken", code: 0, userInfo: nil))
        }
    }
    
    func logout() {
        self.userModel.clearAllData()
    }
    
    
}

extension InstagramAgent {
    
    //MARK: - Constants
    private struct ThisConstants
    {
        static let storyboardName = "SocialAgentUI"
        static let instagramSignInVCStoryboardID = "InstagramSignInVC"
        static let instagramSignInNCStoryboardID = "InstagramSignInNC"
        static let accessTokenKey = "accessToken"
        static let userIDKey = "userID"
        static let fullNameKey = "fullName"
        static let userNameKey = "userName"
        static let bioKey = "bio"
        static let followedByCountKey = "followedByCount"
        static let followsCountKey = "followsCount"
        static let mediaCountKey = "mediaCount"
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
        
        return instagramPersistanceConstants
    }
}