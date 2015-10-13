//
//  InstagramConstants.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/13/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import Foundation

class InstagramConstants {
    
    let accessTokenKey = "SAIGaccessToken"
    let userIDKey = "SAIGuserID"
    let fullName = "SAIGfullName"
    let userName = "SAIGuserName"
    let bio = "SAIGbio"
    let followedByCount = "SAIGfollowedByCount"
    let followsCount = "SAIGfollowsCount"
    let mediaCount = "SAIGmediaCount"
    var redirectURI = "http://localhost/oauth2"
    
    var clientID: String? {
        return readPlist(SocialAgentConstants.instagramClientIdKey)
    }
    
    var clientSecret: String? {
        return readPlist(SocialAgentConstants.instagramClientSecretKey)
    }
    
    func readPlist(key: String) -> String? {
        var clientID: String?
        if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                clientID = dict[key] as? String
            }
            else {
                clientID = nil
            }
        }
        else {
            clientID = nil
        }
        return clientID
    }
}