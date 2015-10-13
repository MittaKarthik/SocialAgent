//
//  ViewController.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 12/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(SocialAgent.instagramSharedInstance())")
        print("\(SocialAgent.instagramSharedInstance())")
        print("\(SocialAgent.instagramSharedInstance())")
        print("\(SocialAgent.instagramSharedInstance())")

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

