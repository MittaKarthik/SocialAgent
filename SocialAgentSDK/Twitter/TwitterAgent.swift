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
    
    //MARK: - Constants
    struct ThisConstants
    {
 
    }
    
    var userModel = SocialAgentUserModel()

    
    func login(completion: CompletionBlock)
    {
        
    }
    
    func getUserInfo(completion: CompletionBlock) {
    }
    
    func  loginAndGetUserInfo(completion: CompletionBlock) {
        
    }
    

}