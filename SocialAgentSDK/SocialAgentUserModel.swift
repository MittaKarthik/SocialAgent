//
//  SocialAgentUserModel.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/13/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import Foundation

class SocialAgentUserModel
{
    var userConstants = SocialAgentPersistanceConstants()
    
    var accessToken : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.accessTokenKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.accessTokenKey)
        }
    }
    
    var userID : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.userIDKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.userIDKey)
        }
    }
    
    var fullName : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.fullName)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.fullName)
        }
    }
    
    var userName : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.userName)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.userName)
        }
    }
    
    var bio : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.userName)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.userName)
        }
    }
    
    var followedByCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(userConstants.followedByCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.followedByCount)
        }
    }
    
    var followsCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(userConstants.followsCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.followsCount)
        }
    }
    
    var mediaCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(userConstants.mediaCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.mediaCount)
        }
    }

    
}