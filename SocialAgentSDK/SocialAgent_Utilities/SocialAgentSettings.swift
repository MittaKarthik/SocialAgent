//
//  SocialAgentSettings.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class SocialAgentSettings
{
    
    static func getInstagramClientId() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.instagramClientIdKey)!
    }
    
    static func getInstagramClientSecret() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.instagramClientSecretKey)!
    }
    
    static func getYouTubeClientID() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.youtubeClientIdKey)!
    }
    
    static func getYouTubeClientSecret() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.youtubeClientSecretKey)!
    }
    
    static func getYouTubeApiKey() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.youtubeApiKey)!
    }
    
    static func getTwitterConsumerKey() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.twitterConsumerKey)!
    }
    
    static func getTwitterConsumerSecret() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.twitterConsumerSecret)!
    }
    
    static func getSoundCloudClientID() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.soundCloudClientID)!
    }
    
    static func getSoundCloudClientSecret() -> String {
        return self.getRequiredAppKey(SocialAgentConstants.soundCloudClientSecret)!
    }
    
    private static func getRequiredAppKey( key : String ) -> String?
    {
        let infoDict : Dictionary = NSBundle.mainBundle().infoDictionary!
        return infoDict[key] as? String
        
//        let myDict: NSDictionary?
//        let valueForKey: String?
//        if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
//            myDict = NSDictionary(contentsOfFile: path)
//            if let dict = myDict {
//                valueForKey = dict[key] as? String
//            }
//            else {
//                valueForKey = nil
//            }
//        }
//        else {
//            valueForKey = nil
//        }
//        return valueForKey
    }
}