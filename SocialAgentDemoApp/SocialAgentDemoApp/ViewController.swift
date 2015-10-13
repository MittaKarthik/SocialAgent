//
//  ViewController.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let socialSession = SocialAgent.youTubeSharedInstance()
    var didLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socialSession.loginAndGetUserInfo { (error) -> () in
            print(self.socialSession.userModel.subscriberCount!)
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

