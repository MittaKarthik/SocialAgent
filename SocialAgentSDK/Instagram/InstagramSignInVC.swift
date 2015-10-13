//
//  File.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/9/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

class InstagramSignInVC: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var instagramWebView: UIWebView!
    var isVerified = false
    var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        instagramWebView.delegate = self
        
        self.navigationItem.title = "Instagram Login"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
    }
    
    override func viewWillAppear(animated: Bool) {
        let url = NSURL(string: "https://instagram.com/oauth/authorize/?client_id=\(SocialAgentSettings.getInstagramClientId())&redirect_uri=\(SocialAgentConstants.instagramRedirectURI)&response_type=token".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        let request = NSURLRequest(URL: url)
        instagramWebView.loadRequest(request)
        print("viewWillAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @IBAction func calcelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            if let delegate = self.delegate {
                delegate.didUserCancelLogin()
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL!.absoluteString.rangeOfString("http://localhost/oauth2#access_token=") != nil) {
            if !isVerified {
                isVerified = true
                print(request)
                SocialAgent.instagramSharedInstance().userModel.accessToken = request.URL!.absoluteString.componentsSeparatedByString("access_token=")[1]
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    if let delegate = self.delegate {
                        delegate.didLoginCompleteSuccessfully()
                    }
                })
            }
            return false
        }
        return true
    }
    
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
}
