//
//  ViewController.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let socialSession = SocialAgent.mixCloudSharedInstance()
    var didLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        socialSession.loginAndGetUserInfo { [weak self] (error) -> () in
//            print(error)
//            print(self?.socialSession.userModel.followedByCount)
//            print(self?.socialSession.userModel.fullName)
//            print(self?.socialSession.userModel.userName)
//        }
        
        SocialAgent.mixCloudSharedInstance().getUserInfoForMC("djrusske") { [weak self] (error) -> () in
            print(error)
            print(self?.socialSession.userModel.followedByCount)
            print(self?.socialSession.userModel.followsCount)
            print(self?.socialSession.userModel.fullName)
            print(self?.socialSession.userModel.userName)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

