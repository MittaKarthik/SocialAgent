//
//  SocialAgentDelegateExtension.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 13/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

extension SocialAgentDelegate
{
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication)
    {
        
    }
    
    
    //MARK: - Twitter Methods
    
    func getUserInfoFor(screenName: String?, userID: String?, completion: CompletionBlock)
    {
        
    }
    
    
    //MARK: - Other platforms
    
    func getUserInfoFor(identifier: String?, completion: CompletionBlock)
    {
        
    }
    
    //MARK: - Facebook
    
    func getPageInfo()
    {
    
    }

}