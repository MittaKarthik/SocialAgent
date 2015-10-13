//
//  ViewController.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoginDelegate {

    let x = SocialAgent.instagramSharedInstance()
    var didLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        x.login(self) { (responseObject, error) -> () in
            print("Done Login")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didLoginCompleteSuccessfully() {
        print("Login success")
        self.x.getUserInfo({ (responseObject, error) -> () in
            print(responseObject)
        })
    }
    
    func didUserCancelLogin() {
        print("cancelled")
    }


}

