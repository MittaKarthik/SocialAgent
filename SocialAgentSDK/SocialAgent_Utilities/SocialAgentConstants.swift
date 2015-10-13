//
//  SocialAgentConstants.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import Foundation

class SocialAgentConstants
{
    //MARK: - General Constants
    
    static let storyboardName = "SocialAgentUI"
    static let loginVCStoryboardID = "LoginVC"
    //MARK: - Common constants
    
    static let authenticationCancelMsg : String = "Authentication Cancelled"
    
    //MARK: - Instagram Constants
    static let instagramClientIdKey : String =  "SAInstagramClientId"
    static let instagramClientSecretKey : String =  "SAInsatagramClientSecret"
    static let instagramRedirectURI : String = "http://localhost/oauth2"
    
    //<ARK: - Youtube Constants
    static let youtubeApiKey : String =  "SAYoutubeApiKey"
    static let youtubeClientIdKey : String =  "SAYoutubeClientId"
    static let youtubeClientSecretKey : String =  "SAYoutubeClientSecret"
    static let youtubeScope : String = "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtubepartner https://www.googleapis.com/auth/youtubepartner-channel-audit https://www.googleapis.com/auth/youtube.upload https://www.googleapis.com/auth/userinfo.profile"
}

struct loginData {
    let naviGationTitle: String
    let requestURL: String
    let rangeCheckingString: String
    let accessTokenLimiterString: String
    
    let socialProfile: SocialAgentType
    
    init(naviGationTitle: String, requestURL: String, rangeCheckingString: String, accessTokenLimiterString: String, socialProfile: SocialAgentType) {
        self.naviGationTitle = naviGationTitle
        self.requestURL = requestURL
        self.rangeCheckingString = rangeCheckingString
        self.accessTokenLimiterString = accessTokenLimiterString
        self.socialProfile = socialProfile
    }
}

enum SocialAgentType {
    case Facebook
    case Twitter
    case Instagram
    case YouTube
}