//
//  YoutubeAgent.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class YoutubeAgent: SocialAgentDelegate
{
    
    static let sharedInstance = YoutubeAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    //MARK: - Constants
    struct ThisConstants
    {

    }
    
    func login(_: CompletionBlock)
    {
        
    }
}