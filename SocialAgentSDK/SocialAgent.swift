//
//  SocialAgent.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import Foundation

class SocialAgent {
    
    static func fbSharedInstance() ->SocialAgentDelegate
    {
        return FacebookAgent.sharedInstance
    }
    
    static func twitterSharedInstance() ->SocialAgentDelegate
    {
        return TwitterAgent.sharedInstance
    }


}