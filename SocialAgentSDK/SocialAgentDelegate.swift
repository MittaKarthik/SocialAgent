//
//  SocialAgentDelegate.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

typealias CompletionBlock = ( responseObject : AnyObject?, error : NSError?) -> ()

protocol SocialAgentDelegate : class
{
    func login(_: CompletionBlock)
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
}