//
//  YoutubeAgent.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class YoutubeAgent: SocialAgentDelegate
{
    
    static let sharedInstance = YoutubeAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    
    
    var userModel = SocialAgentUserModel()

    
    func login(delegate: LoginDelegate, completion: CompletionBlock)
    {
        
    }
    
    func getUserInfo(completion: CompletionBlock) {
    }
}

extension YoutubeAgent {
    
    //MARK: - Constants
    struct ThisConstants
    {
        static let storyboardName = "SocialAgentUI"
        static let instagramSignInVCStoryboardID = "InstagramSignInVC"
        static let instagramSignInNCStoryboardID = "InstagramSignInNC"
        static let accessTokenKey = "accessToken"
        static let userIDKey = "userID"
        static let fullNameKey = "fullName"
        static let userNameKey = "userName"
        static let bioKey = "bio"
        static let followedByCountKey = "followedByCount"
        static let followsCountKey = "followsCount"
        static let mediaCountKey = "mediaCount"
    }
    
    //MARK: - User Data Persistance Constants
    private func setUpUserPersistanceConstants() -> SocialAgentPersistanceConstants {
        let youTubePersistanceConstants : SocialAgentPersistanceConstants  = SocialAgentPersistanceConstants()
        youTubePersistanceConstants.accessTokenKey = ThisConstants.accessTokenKey
        youTubePersistanceConstants.userIDKey = ThisConstants.userIDKey
        youTubePersistanceConstants.fullNameKey = ThisConstants.fullNameKey
        youTubePersistanceConstants.userNameKey = ThisConstants.userNameKey
        youTubePersistanceConstants.bioKey = ThisConstants.bioKey
        youTubePersistanceConstants.followedByCountKey = ThisConstants.followedByCountKey
        youTubePersistanceConstants.followsCountKey = ThisConstants.followsCountKey
        youTubePersistanceConstants.mediaCountKey = ThisConstants.mediaCountKey
        
        return youTubePersistanceConstants
    }
}