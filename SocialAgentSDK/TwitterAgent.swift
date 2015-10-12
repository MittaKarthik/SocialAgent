//
//  TwitterAgent.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class TwitterAgent: SocialAgentDelegate
{
    
    static let sharedInstance = TwitterAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        return true
    }
    
    func login(_: CompletionBlock)
    {
        
    }
}