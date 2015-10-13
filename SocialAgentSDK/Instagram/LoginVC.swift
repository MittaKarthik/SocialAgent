//
//  File.swift
//  SocialAgentDemoApp
//
//  Created by Vishal on 10/9/15.
//  Copyright © 2015 Vishal. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var loginWebView: UIWebView!
    var isVerified = false
    var delegate: LoginDelegate?
    var localLoginData: loginData!
    var sToken: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let url = NSURL(string: localLoginData.requestURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
        let request = NSURLRequest(URL: url)
        loginWebView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @IBAction func calcelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            if let delegate = self.delegate {
                delegate.didUserCancelLogin(nil)
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL!.absoluteString.rangeOfString(localLoginData.rangeCheckingString) != nil) {
            if !isVerified {
                isVerified = true
                print(request)
                
                if localLoginData.socialProfile == SocialAgentType.Instagram {
                    SocialAgent.instagramSharedInstance().userModel.accessToken = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    
                    if let delegate = self.delegate {
                        delegate.didLoginCompleteSuccessfully(nil)
                    }
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                }
                else if localLoginData.socialProfile == SocialAgentType.YouTube {
                    sToken = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    
                    if let delegate = self.delegate {
                        delegate.didLoginCompleteSuccessfully(["sToken": self.sToken])
                    }
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                }
            }
            return false
        }
        return true
    }
    
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        
    }
    
}
