//
//  ViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/1/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class signInFBviewController: UIViewController {

    @IBAction func SignIn(sender: AnyObject) {
        if let storyboard = self.storyboard {
            if let signUpViewController = storyboard.instantiateViewControllerWithIdentifier("signUpViewController") as? SignUpViewController {
                self.presentViewController(signUpViewController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func loginWithFacebook(sender: AnyObject) {
        if let storyboard = self.storyboard {
            if let signUpViewController = storyboard.instantiateViewControllerWithIdentifier("signUpViewController") as? SignUpViewController {
                self.presentViewController(signUpViewController, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("showSigninScreen", sender: self)
    }
}

