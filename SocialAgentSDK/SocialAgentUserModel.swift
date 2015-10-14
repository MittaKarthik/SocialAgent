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
    let persistedCredentials = NSUserDefaults.standardUserDefaults()
    var accessToken : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.accessTokenKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.accessTokenKey)
            let myDate: NSDate = NSDate()
            let myDateTimeInterval: NSTimeInterval = myDate.timeIntervalSince1970
            persistedCredentials.setDouble(myDateTimeInterval, forKey: userConstants.accessTokenIssueTimeKey)
        }
    }
    
    var accessTokenIssueTime: NSDate? {
        get {
            let myDateTimeInterval: NSTimeInterval = persistedCredentials.doubleForKey(userConstants.accessTokenIssueTimeKey)
            let dateInterval = NSDate(timeIntervalSince1970: myDateTimeInterval)
            return dateInterval
        }
    }
    
    var expiresIn : Double? {
        get {
            return persistedCredentials.doubleForKey(userConstants.expiresInKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.expiresInKey)
        }
    }
    
    var refreshToken : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.refreshTokenKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.refreshTokenKey)
        }
    }
    
    var userID : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.userIDKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.userIDKey)
        }
    }
    
    var channelID : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.channelIDKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.channelIDKey)
        }
    }
    
    var fullName : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.fullNameKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.fullNameKey)
        }
    }
    
    var userName : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.userNameKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.userNameKey)
        }
    }
    
    var userEmailId : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.emailKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.emailKey)
        }
    }
    
    var bio : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.bioKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.bioKey)
        }
    }
    
    var age : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.ageKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.ageKey)
        }
    }
    
    var gender : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.genderKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.genderKey)
        }
    }
    
    var profilePicUrl : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.profilePicUrlKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.profilePicUrlKey)
        }
    }
    
    var followedByCount : Int? {
        get {
            return persistedCredentials.integerForKey(userConstants.followedByCountKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.followedByCountKey)
        }
    }
    
    var followsCount : Int? {
        get {
            return persistedCredentials.integerForKey(userConstants.followsCountKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.followsCountKey)
        }
    }
    
    var mediaCount : Int? {
        get {
            return persistedCredentials.integerForKey(userConstants.mediaCountKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.mediaCountKey)
        }
    }
    
    var subscriberCount : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.subscriberCount)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.subscriberCount)
        }
    }
    
    var videoCount : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.videoCountKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.videoCountKey)
        }
    }
    
    var viewCount : String? {
        get {
            return persistedCredentials.stringForKey(userConstants.viewCountKey)
        }
        set {
            persistedCredentials.setValue(newValue, forKey: userConstants.viewCountKey)
        }
    }
    
    func clearAllData() {
        self.accessToken = nil
        self.expiresIn = nil
        self.refreshToken = nil
        self.userID = nil
        self.channelID = nil
        self.fullName = nil
        self.userName = nil
        self.bio = nil
        self.followedByCount = nil
        self.followsCount = nil
        self.mediaCount = nil
        self.subscriberCount = nil
        self.videoCount = nil
        self.viewCount = nil
        self.age = nil
        self.userEmailId = nil
        self.gender = nil
        self.profilePicUrl = nil
    }

    
}