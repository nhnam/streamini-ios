//
//  LoginViewController.swift
//  Streamini
//
//  Created by Vasily Evreinov on 22/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit
import TwitterKit


class LoginViewController: BaseViewController {
    @IBOutlet weak var loginButton: UIButton!

    func loginSuccess(_ session: String) {
        loginButton.isEnabled = true
        A0SimpleKeychain().setString(session, forKey: "PHPSESSID")
        self.performSegue(withIdentifier: "LoginToMain", sender: self)
    }
    
    func loginFailure(_ error: NSError) {
        loginButton.isEnabled = true
    }
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        loginButton.isEnabled = false
        Twitter.sharedInstance().logIn(with: self, completion: { (session, error) -> Void in
            if error != nil {
                UIAlertView.notAuthorizedAlert(NSLocalizedString("login_twitter_error", comment: "")).show()
                self.loginButton.isEnabled = true
                return
            }
            self.loginWithTwitterSession(session!)
        })
    }
    
    func loginWithTwitterSession(_ session: TWTRSession) {
        let loginData       = NSMutableDictionary()
        loginData["id"]     = session.userID
        loginData["token"]  = session.authToken
        loginData["secret"] = session.authTokenSecret
        loginData["type"]   = "twitter"
        
        A0SimpleKeychain().setString(session.userID, forKey: "id")
        A0SimpleKeychain().setString(session.authToken, forKey: "token")
        A0SimpleKeychain().setString(session.authTokenSecret, forKey: "secret")
        A0SimpleKeychain().setString("twitter", forKey: "type")
        
        if let deviceToken = (UIApplication.shared.delegate as! AppDelegate).deviceToken {
            loginData["apn"] = deviceToken
        } else {
            loginData["apn"] = ""
        }
        
        let connector = UserConnector()
        connector.login(loginData, success: self.loginSuccess, failure: self.loginFailure)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButtonTitle = NSLocalizedString("login_with_twitter_button", comment: "")
        self.loginButton.setTitle(loginButtonTitle, for: UIControlState())

        if let session = A0SimpleKeychain().string(forKey: "PHPSESSID") {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootViewControllerId") 
            self.navigationController!.pushViewController(controller, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}