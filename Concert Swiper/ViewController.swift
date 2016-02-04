//
//  ViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/1/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func SignIn(sender: AnyObject) {
        performSegueWithIdentifier("showSigninScreen", sender: self)
    }
    @IBAction func loginWithFacebook(sender: AnyObject) {
            performSegueWithIdentifier("showSigninScreen", sender: self)
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

