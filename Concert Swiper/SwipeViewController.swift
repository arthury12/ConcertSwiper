//
//  SwipeViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit
import SafariServices

class SwipeViewController: UIViewController {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitleTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBAction func matchesButton(sender: AnyObject) {
        if let storyboard = self.storyboard {
            if let matchesViewController = storyboard.instantiateViewControllerWithIdentifier("ConcertMatches") as? MatchesCollectionViewController {
                self.presentViewController(matchesViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func settingsButton(sender: AnyObject) {
        if let storyboard = self.storyboard {
            if let signUpViewController = storyboard.instantiateViewControllerWithIdentifier("signUpViewController") as? SignUpViewController {
                self.presentViewController(signUpViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func TMLink(sender: AnyObject) {
        if staticVars.artistStructArray.count > 0 && staticVars.arrayIndex+1 < staticVars.artistStructArray.count {
            if let currentEventTMLink = staticVars.artistStructArray[staticVars.arrayIndex].artistLinkId {
                if let url = NSURL(string: currentEventTMLink) {
                    let safariVC = SFSafariViewController(URL: url)
                    self.presentViewController(safariVC, animated: true, completion: nil)
                }
            }
        } else {
            let TMURL = NSURL(string: "http://m.ticketmaster.com")
            let safariVC = SFSafariViewController(URL: TMURL!)
            self.presentViewController(safariVC, animated: true, completion: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToMatchesTableView" {
            defaults.setInteger(staticVars.arrayIndex, forKey: "arrayIndex")
            let viewController: MatchesCollectionViewController = segue.destinationViewController as! MatchesCollectionViewController
            viewController.matchesArray = staticVars.storedEvents
        }
    }
    
    struct staticVars {
        static var artistStructArray = [Artist]()
        static var storedEvents = [Artist]()
        static var arrayIndex = 0
    }
    var artist: Artist?
    let identifier = "CellIdentifier"

    let defaults = NSUserDefaults.standardUserDefaults()
    let jsonURL = NSURL(string: "http://app.map.jash1.syseng.tmcs:8080/api/mapping/hp?domain=US&marketId=27")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        if (staticVars.artistStructArray.count < 1) {
            loadURL()
        } else {
            loadCurrentSwipeContent(staticVars.artistStructArray[defaults.integerForKey("arrayIndex")])
        }
        eventImage.addGestureRecognizer(gesture)
        eventImage.userInteractionEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "action", name: "imageSelected", object: nil)
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer){
        if staticVars.artistStructArray.count > 0 {
        let translation = gesture.translationInView(self.view)
        let image = gesture.view!
        
        image.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y - 70)
        let xFromCenter = image.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        image.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if image.center.x < 100 {
                if (staticVars.arrayIndex+1) < staticVars.artistStructArray.count {
                    staticVars.arrayIndex++
                    self.loadCurrentSwipeContent(staticVars.artistStructArray[staticVars.arrayIndex])
                } else {
                    // When run out of swipes
                    self.loadNetworkNotAvaliable()
                }
            } else if image.center.x > self.view.bounds.width - 100 {
                if staticVars.arrayIndex+1 < staticVars.artistStructArray.count {
                    staticVars.storedEvents.append(staticVars.artistStructArray[staticVars.arrayIndex])
                    staticVars.arrayIndex++
                    self.loadCurrentSwipeContent(staticVars.artistStructArray[staticVars.arrayIndex])
                    print("event stored \(staticVars.artistStructArray[staticVars.arrayIndex-1].artistName!)")
                } else {
                    // When run out of swipes
                    self.loadNetworkNotAvaliable()
                }
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            image.transform = stretch
            image.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2 - 70)
            }
        }
    }
    
    func loadURL() {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = NSMutableURLRequest(URL: jsonURL!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) {
            [unowned self] (data, response, error) -> Void in
            if (error == nil && data != nil){
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    
                    guard let dict = json as? [String: AnyObject] else { return }
                        
                    guard let recommendations = dict["recommendations"] as? [String: AnyObject] else { return }
                            
                    guard let optional = recommendations["top"] as? [String: AnyObject] else { return }
                    
                    guard let recommendedArtists = optional["recommendedArtists"] as? [NSObject] else { return }
                    
                    for artist: NSObject in recommendedArtists {
                        guard let artistDict = artist as? [String: AnyObject] else { return }
                        
                        var currArtist = Artist()
                        guard let artistObject = artistDict["artist"] as? [String: AnyObject] else { return }
                        
                        currArtist.artistId = artistObject["artistId"] as? Int
                        currArtist.artistImageUrl = artistObject["artistImageUrl"] as? String
                        currArtist.artistLinkId = artistObject["artistLinkId"] as? String
                        currArtist.artistName = artistObject["artistName"] as? String
                        currArtist.largeArtistImageUrl = artistObject["largeArtistImageUrl"] as? String
                        staticVars.artistStructArray.append(currArtist)
                    }
                
                } catch {
                    print ("Error serializing JSON: \(error)")
                }
                if staticVars.artistStructArray.count > 0 {
                    self.loadCurrentSwipeContent(staticVars.artistStructArray[staticVars.arrayIndex])
                    print(staticVars.artistStructArray)
                }
                print(staticVars.artistStructArray.count)
            } else {
                self.loadNetworkNotAvaliable()
            }
        }
        task.resume()
    }

    func loadCurrentSwipeContent(currentArtist:Artist) {
        if currentArtist.artistName != nil {
            NSOperationQueue.mainQueue().addOperationWithBlock(){
                self.eventTitleTime.text = currentArtist.artistName
            }
        }
        if let largeArtistImageUrlString = currentArtist.largeArtistImageUrl {
            if let imgURL = NSURL(string: largeArtistImageUrlString) {
                let artistImgSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                let request = NSMutableURLRequest(URL: imgURL)
                let task = artistImgSession.dataTaskWithRequest(request) {
                    (data, response, error) -> Void in
                    if (error == nil && data != nil) {
                        NSOperationQueue.mainQueue().addOperationWithBlock(){
                            self.eventImage.image = UIImage(data: data!)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func loadNetworkNotAvaliable() {
        let sadFace = "http://images.moneysavingexpert.com/images/sadface.jpg"
        let imageSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        if let sadFaceURL = NSURL(string: sadFace) {
                let request = NSMutableURLRequest(URL: sadFaceURL)
                request.HTTPMethod = "GET"
                let task = imageSession.dataTaskWithRequest(request) {
                    (data, response, error) -> Void in
                    if (error == nil && data != nil) {
                        NSOperationQueue.mainQueue().addOperationWithBlock(){
                            self.eventImage.image = UIImage(data: data!)
                            self.eventTitleTime.text = "No artist avaliable"
                        }
                    }
                }
                task.resume()
        }
    }


    func structToArray (artistStructArray: [Artist]) -> [Dictionary<String, String>] {
        var artistDict = [String : String]()
        var artistDictArray = [artistDict]
        for var i = 0; i < artistStructArray.count; i++ {
            if artistStructArray[i].artistName != nil && artistStructArray[i].artistImageUrl != nil {
                artistDict = ["Artist Name": artistStructArray[i].artistName!,
                    "Artist Image URL": artistStructArray[i].artistImageUrl!]
                artistDictArray.append(artistDict)
            }
        }
        return artistDictArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
