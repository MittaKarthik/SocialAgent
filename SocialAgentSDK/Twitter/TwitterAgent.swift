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
    
    //MARK: - Initializers
    static let sharedInstance = TwitterAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    var userModel = SocialAgentUserModel()

    //MARK: - Authentication methods
    func login(completion: CompletionBlock)
    {
        
    }
    
    func loginAndGetUserInfo(completion: CompletionBlock)
    {
        
    }
    
    func logout(completion: CompletionBlock)
    {
        
    }
    
    //MARK: - Getting user info methods
    func getUserInfo(completion: CompletionBlock)
    {
        
    }
    
    //MARK: - Validation and refreshing methods
}


extension FacebookAgent {
    
    //MARK: - Constants
    private struct ThisConstants
    {
       
    }
    
//    //MARK: - User Data Persistance Constants
//    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants
//    {
//    }
}