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
    
    static func getInstagramAppId() -> String
    {
        return self.getRequiredAppKey(SocialAgentConstants.instagramClientIdKey)!
    }
    
    
    static func getInstagramAppSecret() -> String
    {
        return self.getRequiredAppKey(SocialAgentConstants.instagramClientSecretKey)!
    }
    
    
    private static func getRequiredAppKey( key : String ) -> String?
    {
        let infoDict : Dictionary = NSBundle.mainBundle().localizedInfoDictionary!
        return infoDict[key] as? String
    }
}