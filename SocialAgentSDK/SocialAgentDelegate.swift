//
//  SocialAgentDelegate.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

typealias CompletionBlock = (error : NSError?) -> ()

protocol SocialAgentDelegate : class
{
    func login(completion: CompletionBlock)
    func loginAndGetUserInfo(completion: CompletionBlock)
    func logout(completion: CompletionBlock)
    
    //Identifer 
    //pass 'nil' for self
    //OR
    //For Youtube - channelID
    //For Instagram - userID
    //For Twitter - userID
    //For SoundCloud - userID
    //For MixCloud - userName
    func getUserInfoFor(identifier: String?, userID: String?, completion: CompletionBlock) //Twitter
    func getUserInfoFor(identifier: String?, completion: CompletionBlock) //Other Platforms

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    func applicationDidBecomeActive(application: UIApplication)
    
    var userModel: SocialAgentUserModel {get set}
    
}