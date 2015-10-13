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
}