//
//  SignUpViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/1/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBAction func continueButton(sender: AnyObject) {
        if let storyboard = self.storyboard {
            if let swipeViewController = storyboard.instantiateViewControllerWithIdentifier("SwipeViewController") as? SwipeViewController {
                self.presentViewController(swipeViewController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func backButton(sender: AnyObject) {
        if let storyboard = self.storyboard {
            if let signInFBViewController = storyboard.instantiateViewControllerWithIdentifier("signInFBviewController") as? signInFBviewController {
                self.presentViewController(signInFBViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
