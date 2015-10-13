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