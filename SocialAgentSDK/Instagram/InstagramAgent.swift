//
//  InstagramAgent.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/12/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class InstagramAgent: SocialAgentDelegate
{
    
    static let sharedInstance = InstagramAgent()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    //MARK: - Constants
    struct ThisConstants
    {
    }
    
    
    func login(_: CompletionBlock)
    {
        
    }
}