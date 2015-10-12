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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        return true
    }
    
    func login(_: CompletionBlock)
    {
        
    }
}