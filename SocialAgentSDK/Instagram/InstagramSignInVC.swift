//
//  File.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/9/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

class InstagramSignInVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var googleWebView: UIWebView!
    var isVerified = false
    var sToken = String()
    let instagramConstants = InstagramConstants()
    let instagramUser = InstagramUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let url = NSURL(string: "https://instagram.com/oauth/authorize/?client_id=\(instagramConstants.clientID)&redirect_uri=\(instagramConstants.redirectURI)&response_type=token".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        let request = NSURLRequest(URL: url)
        googleWebView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @IBAction func calcelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("View Dismissed")
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL!.absoluteString.rangeOfString("http://localhost/oauth2#access_token=") != nil) {
            if !isVerified {
                isVerified = true
                print(request)
                instagramUser.accessToken = request.URL!.absoluteString.componentsSeparatedByString("access_token=")[1]
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            return false
        }
        return true
    }
    
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
}
