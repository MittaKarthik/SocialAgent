//
//  SocialAgent.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import Foundation

class SocialAgent {
    
    static func facebookSharedInstance() ->SocialAgentDelegate
    {
        return FacebookAgent.sharedInstance
    }
    
    static func twitterSharedInstance() ->SocialAgentDelegate
    {
        return TwitterAgent.sharedInstance
    }
    
    static func instagramSharedInstance() ->SocialAgentDelegate
    {
        return InstagramAgent.sharedInstance
    }
    
    static func youTubeSharedInstance() ->SocialAgentDelegate
    {
        return YoutubeAgent.sharedInstance
    }


}