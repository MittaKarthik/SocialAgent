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
            let myDate: NSDate = NSDate()
            let myDateTimeInterval: NSTimeInterval = myDate.timeIntervalSince1970
            persistedCredentials.setDouble(myDateTimeInterval, forKey: userConstants.accessTokenIssueTimeKey)
        }
    }
    
    var accessTokenIssueTime: NSDate? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            let myDateTimeInterval: NSTimeInterval = persistedCredentials.doubleForKey(userConstants.accessTokenIssueTimeKey)
            let dateInterval = NSDate(timeIntervalSince1970: myDateTimeInterval)
            return dateInterval
        }
    }
    
    var expiresIn : Double? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.doubleForKey(userConstants.expiresInKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.expiresInKey)
        }
    }
    
    var refreshToken : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.refreshTokenKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.refreshTokenKey)
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
    
    var channelID : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.channelIDKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.channelIDKey)
        }
    }
    
    var fullName : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.fullNameKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.fullNameKey)
        }
    }
    
    var userName : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.userNameKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.userNameKey)
        }
    }
    
    var userEmailId : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.emailKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.emailKey)
        }
    }
    
    var bio : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.bioKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.bioKey)
        }
    }
    
    var age : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.ageKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.ageKey)
        }
    }
    
    var gender : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.genderKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.genderKey)
        }
    }
    
    var profilePicUrl : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.profilePicUrlKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.profilePicUrlKey)
        }
    }
    
    var followedByCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(userConstants.followedByCountKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.followedByCountKey)
        }
    }
    
    var followsCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(userConstants.followsCountKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.followsCountKey)
        }
    }
    
    var mediaCount : Int? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.integerForKey(userConstants.mediaCountKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.mediaCountKey)
        }
    }
    
    var subscriberCount : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.subscriberCount)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.subscriberCount)
        }
    }
    
    var videoCount : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.videoCountKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.videoCountKey)
        }
    }
    
    var viewCount : String? {
        get {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            return persistedCredentials.stringForKey(userConstants.viewCountKey)
        }
        set {
            let persistedCredentials = NSUserDefaults.standardUserDefaults()
            persistedCredentials.setValue(newValue, forKey: userConstants.viewCountKey)
        }
    }
    
    func clearAllData() {
        self.accessToken = nil
        self.userID = nil
        self.fullName = nil
        self.userName = nil
        self.bio = nil
        self.followedByCount = nil
        self.followsCount = nil
        self.mediaCount = nil
    }

    
}