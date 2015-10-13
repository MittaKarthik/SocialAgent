//
//  InstagramUser.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/13/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class InstagramUser {

    
    let instagramConstants = InstagramConstants()
    
    var accessToken : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(instagramConstants.accessTokenKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.accessTokenKey)
        }
    }
    
    var userID : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(instagramConstants.userIDKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.userIDKey)
        }
    }
    
    var fullName : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(instagramConstants.fullName)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.fullName)
        }
    }
    
    var userName : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(instagramConstants.userName)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.userName)
        }
    }
    
    var bio : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(instagramConstants.userName)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.userName)
        }
    }
    
    var followedByCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(instagramConstants.followedByCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.followedByCount)
        }
    }
    
    var followsCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(instagramConstants.followsCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.followsCount)
        }
    }
    
    var mediaCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(instagramConstants.mediaCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: instagramConstants.mediaCount)
        }
    }
}
