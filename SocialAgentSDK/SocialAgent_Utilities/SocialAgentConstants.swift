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
    
    static let mainScreenHeight                                                         = UIScreen.mainScreen().bounds.size.height
    static let mainScreenWidth                                                          = UIScreen.mainScreen().bounds.size.width

    
    static let storyboardName = "SocialAgentUI"
    static let loginVCStoryboardID = "LoginVC"
    //MARK: - Common constants
    
    static let authenticationCancelMsg : String = "Authentication Cancelled."
    static let authenticationFailedMsg : String = "Authentication Failed."

    static let invalidAccesToken : String = "Access token is invalid."

    //MARK: - Instagram Constants
    static let instagramClientIdKey : String =  "SAInstagramClientId"
    static let instagramClientSecretKey : String =  "SAInsatagramClientSecret"
    static let instagramRedirectURI : String = "http://localhost/oauth2"
    
    //MARK: - Youtube Constants
    static let youtubeApiKey : String =  "SAYoutubeApiKey"
    static let youtubeClientIdKey : String =  "SAYoutubeClientId"
    static let youtubeClientSecretKey : String =  "SAYoutubeClientSecret"
    static let youtubeScope : String = "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtubepartner https://www.googleapis.com/auth/youtubepartner-channel-audit https://www.googleapis.com/auth/youtube.upload https://www.googleapis.com/auth/userinfo.profile"
    static let youtubeSTokenKey : String = "sToken"
    
    //MARK: - Twitter Constants
    static let twitterConsumerKey : String =  "SATwitterConsumerKey"
    static let twitterConsumerSecret : String =  "SATwitterConsumerSecret"
    static let twitterOAuthVerifierKey : String = "oAuthVerifier"
    
    //MARK: - SoundCloud Constants
    static let soundCloudClientID : String = "SASoundCloudClientID"
    static let soundCloudClientSecret : String = "SASoundCloudClientSecret"
    static let soundCloudAuthorizationCode : String = "SCAuthorizationCode"
    //MARK: - MixCloud Constants
    static let mixCloudClientID : String = "SAMixCloudClientID"
    static let mixCloudClientSecret : String = "SAMixCloudClientSecret"

}

struct loginData {
    let naviGationTitle: String
    let requestURL: String
    let cookieDomainName: String
    let rangeCheckingString: String
    let accessTokenLimiterString: String
    
    let socialProfile: SocialAgentType
    
    init(naviGationTitle: String, requestURL: String, cookieDomainName: String, rangeCheckingString: String, accessTokenLimiterString: String, socialProfile: SocialAgentType) {
        self.naviGationTitle = naviGationTitle
        self.requestURL = requestURL
        self.cookieDomainName = cookieDomainName
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
    case SoundCloud
    case MixCloud
}

enum HTTPMethodString {
    case GET
    case POST
    case DELETE
    
    func getString() -> String {
        if self == .GET {
            return "GET"
        }
        else if self == .POST {
            return "POST"
        }
        else {
            return "DELETE"
        }
    }
}