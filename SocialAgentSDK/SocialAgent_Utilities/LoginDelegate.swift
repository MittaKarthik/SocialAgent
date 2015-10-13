//
//  File.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/13/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func didLoginCompleteSuccessfully(userInfo: [String: String]?)
    func didUserCancelLogin(userInfo: [String: String]?)
}