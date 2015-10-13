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
    static let sharedInstance = FacebookAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    //MARK: - Constants
    struct ThisConstants
    {
        static let numberOfSections: Int = 3
        static let headerHeight : CGFloat = 23
        static let headerCellIdenitfier : String = "headerCell"
        static var detailCountTitles : Array = ["Reviews Written","Followers","Following"]
    }

    
    var userModel = SocialAgentUserModel()

    
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

    func login(_: CompletionBlock)
    {
        
    }
}
