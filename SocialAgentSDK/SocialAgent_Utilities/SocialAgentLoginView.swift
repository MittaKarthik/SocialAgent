//
//  SocialAgentLoginView.swift
//  SocialAgentDemoApp
//
//  Created by MittaKarthik on 15/10/15.
//  Copyright © 2015 MittaKarthik. All rights reserved.
//

import UIKit

class SocialAgentLoginView: UIView, UIWebViewDelegate {
    
    @IBOutlet weak var loginWebview: UIWebView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginBackgroundView: UIView!
    var isVerified = false
    weak var delegate: LoginDelegate?
    var localLoginData: loginData!
    var sToken: String!
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let activityView : UIView = UIView()
    
    override func awakeFromNib()
    {
        self.hidden = true
        super.awakeFromNib()
    }
    
    override func didMoveToSuperview()
    {
        self.hidden = false
        self.frame = CGRect(x: 0, y: 0, width: SocialAgentConstants.mainScreenWidth, height: SocialAgentConstants.mainScreenHeight)
        // self.loginBackgroundView.transform = CGAffineTransformScale(self.loginWebview.transform, 0.3, 0.3);
        self.loginBackgroundView.transform  = CGAffineTransformMakeScale(0.3, 0.3);
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.loginBackgroundView.transform  = CGAffineTransformMakeScale(1.1, 1.1);
            }) { (completed) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.loginBackgroundView.transform  = CGAffineTransformMakeScale(0.9, 0.9);
                    }) { (completed) -> Void in
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.loginBackgroundView.transform  = CGAffineTransformMakeScale(1.0, 1.0);
                            }) { (completed) -> Void in
                                self.loginBackgroundView.transform = CGAffineTransformIdentity;
                        }
                }
        }
        
        //        let basicAnimation : CABasicAnimation = CABasicAnimation(keyPath:"transform")
        //        basicAnimation.autoreverses = true
        //        basicAnimation.duration = 0.4
        //        self.loginWebview.layer.addAnimation(basicAnimation, forKey: nil)
    }
    
    func createTheWebviewRequest()
    {
        if localLoginData.socialProfile == SocialAgentType.Twitter {
            clearCookies()
        }
        else {
            clearCookies()
            let url = NSURL(string: localLoginData.requestURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            let request = NSMutableURLRequest(URL: url)
            self.loginWebview.loadRequest(request)
        }
    }
    
    func clearCookies() {
        let storage: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie: NSHTTPCookie in storage.cookies!
        {
            print(cookie)
            let domainName: String = cookie.domain
            if let domainRange : Range = domainName.rangeOfString(localLoginData.cookieDomainName)
            {
                let length = domainRange.startIndex.distanceTo(domainRange.endIndex)
                if length > 0 {
                    storage.deleteCookie(cookie)
                }
            }
        }
    }
    
    @IBAction func calcelButton(sender: AnyObject)
    {
        if(self.delegate != nil && self.delegate?.didUserCancelLogin != nil)
        {
            self.stopActivityIndicator(self.loginWebview)
            self.delegate!.didUserCancelLogin(nil)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.startActivityIndicator(self)
        print(request.URL)
        if (request.URL!.absoluteString.rangeOfString(localLoginData.rangeCheckingString) != nil) {
            if !isVerified {
                isVerified = true
                
                if localLoginData.socialProfile == SocialAgentType.Instagram {
                    SocialAgent.instagramSharedInstance().userModel.accessToken = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    
                    if(self.delegate != nil && self.delegate?.didLoginCompleteSuccessfully != nil)
                    {
                        self.delegate!.didLoginCompleteSuccessfully(nil)
                    }
                }
                else if localLoginData.socialProfile == SocialAgentType.YouTube {
                    sToken = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    
                    if(self.delegate != nil && self.delegate?.didLoginCompleteSuccessfully != nil)
                    {
                        self.delegate!.didLoginCompleteSuccessfully([SocialAgentConstants.youtubeSTokenKey: self.sToken])
                    }
                }
                else if localLoginData.socialProfile == SocialAgentType.Twitter {
                    let oauthVerifier = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    
                    if(self.delegate != nil && self.delegate?.didLoginCompleteSuccessfully != nil)
                    {
                        self.delegate!.didLoginCompleteSuccessfully([SocialAgentConstants.twitterOAuthVerifierKey : oauthVerifier])
                    }
                }
                else if localLoginData.socialProfile == SocialAgentType.SoundCloud {
                    var authorizationCode = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    authorizationCode.removeAtIndex(authorizationCode.endIndex.predecessor())
                    if(self.delegate != nil && self.delegate?.didLoginCompleteSuccessfully != nil)
                    {
                        self.delegate!.didLoginCompleteSuccessfully([SocialAgentConstants.soundCloudAuthorizationCode : authorizationCode])
                    }
                }
                else if localLoginData.socialProfile == SocialAgentType.MixCloud {
                    print(request.URL)
                    let authorizationCode = request.URL!.absoluteString.componentsSeparatedByString(localLoginData.accessTokenLimiterString)[1]
                    if(self.delegate != nil && self.delegate?.didLoginCompleteSuccessfully != nil)
                    {
                        self.delegate!.didLoginCompleteSuccessfully([SocialAgentConstants.soundCloudAuthorizationCode : authorizationCode])
                    }
                }
            }
            return false
        }
        return true
    }
    
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.stopActivityIndicator(self)
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        self.stopActivityIndicator(self)
    }
    
    func startActivityIndicator(view : UIView)  {
        
        view.userInteractionEnabled = false
        
        activityView.frame = CGRectMake(0, 0, 60, 60)
        activityView.center = view.center
        activityView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        activityView.clipsToBounds = true
        activityView.layer.cornerRadius = 10
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.center = CGPointMake(activityView.frame.size.width / 2, activityView.frame.size.height / 2)
        activityIndicator.color = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        activityView.addSubview(activityIndicator)
        view.addSubview(activityView)
        activityIndicator.startAnimating()
        
    }
    
    func stopActivityIndicator(view : UIView) {
        
        view.userInteractionEnabled = true
        activityIndicator.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    deinit
    {
        print("deinit")
    }
    
}
