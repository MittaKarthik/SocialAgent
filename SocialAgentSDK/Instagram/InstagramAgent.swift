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
    
    static let sharedInstance = InstagramAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    //MARK: - Constants
    struct ThisConstants
    {
        
    }
    let instagramUser = InstagramUser()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        UIApplication.sharedApplication().keyWindow?.rootViewController
        return true
    }
    
    func login(_: CompletionBlock)
    {
        let window = UIApplication.sharedApplication().keyWindow
        var viewControllerOnTop = window?.rootViewController
        while (viewControllerOnTop?.presentedViewController != nil)
        {
            viewControllerOnTop = viewControllerOnTop?.presentedViewController
        }
        let storyboard = UIStoryboard(name: "InstagramUI", bundle: nil)
        let instagramSignInVC = storyboard.instantiateViewControllerWithIdentifier("InstagramSignInVC")
        viewControllerOnTop?.presentViewController(instagramSignInVC, animated: true, completion: { () -> Void in
            print("Presented Instagram SignIn VC")
        })
    }
    
    func getUserInfo(completion: CompletionBlock) {
        if let accessToken = instagramUser.accessToken {
            let request: NSMutableURLRequest = NSMutableURLRequest()
            request.URL = NSURL(string: "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)")
            request.HTTPMethod = "GET"
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                print(accessToken)
                print("task response")
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
                                                self.instagramUser.bio = bio
                                            }
                                            if let fullName = userInfo["full_name"] as? String {
                                                self.instagramUser.fullName = fullName
                                            }
                                            if let id = userInfo["id"] as? String {
                                                self.instagramUser.userID = id
                                            }
                                            if let username = userInfo["username"] as? String {
                                                self.instagramUser.userName = username
                                            }
                                            if let counts = userInfo["counts"] {
                                                if let followedBy = counts["followed_by"] as? Int {
                                                    self.instagramUser.followedByCount = followedBy
                                                }
                                                if let follows = counts["follows"] as? Int {
                                                    self.instagramUser.followsCount = follows
                                                }
                                                if let media = counts["media"] as? Int {
                                                    self.instagramUser.mediaCount = media
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
    
    
}