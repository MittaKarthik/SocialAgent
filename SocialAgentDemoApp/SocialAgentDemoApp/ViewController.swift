//
//  ViewController.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let socialSession = SocialAgent.facebookSharedInstance()
    var didLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socialSession.loginAndGetUserInfo { [weak self] (error) -> () in
            self?.socialSession.getPageInfo()
        }
//        socialSession.reconnectSocialAccount("UC-Ibm48rDsOwlBcSpK4LdXQ", accessToken: "ya29.NgKpmrDGEHvTk4stHUuncK7tcGpG4WryyFmAtklfeOm1iwrrqJyYndHRlVTZsy3uJi5g", userName: nil, refreshToken: "1/OGJ7BSKoVsaJDrw3cgtH3_0KQrlFEhFyaAFWn2UkdV5IgOrJDtdun6zK6XiATCKT", expirationTime: 1448370444.39252) { (error, isServerUpdateRequired) -> () in
//            print(error)
//            print(isServerUpdateRequired)
//        }
//        socialSession.loginAndGetUserInfo { [weak self] (error) -> () in
//            print(error)
//            print(self?.socialSession.userModel.channelID)
//            print(self?.socialSession.userModel.expiresAt)
//            print(self?.socialSession.userModel.accessToken)
//            print(self?.socialSession.userModel.refreshToken)
//
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

