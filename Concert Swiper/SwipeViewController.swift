//
//  SwipeViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

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

    var artist: Artist?
    var artistStructArray = [Artist]()
    var storedEvents = [Artist]()
    let identifier = "CellIdentifier"
    var arrayIndex = 0
    let arrayIndexDefault = NSUserDefaults.standardUserDefaults()
    let url = NSURL(string: "http://app.map.jash1.syseng.tmcs:8080/api/mapping/hp?domain=US&marketId=27")
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventImage.
            
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        loadURL()
        eventImage.addGestureRecognizer(gesture)
        eventImage.userInteractionEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "action", name: "imageSelected", object: nil)
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer){
        let translation = gesture.translationInView(self.view)
        let image = gesture.view!
        
        image.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y - 70)
        let xFromCenter = image.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        image.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended && artistStructArray.count > 0 {
            if image.center.x < 100 {
                if arrayIndex < artistStructArray.count {
                    arrayIndex++
                    self.load_image(self.artistStructArray[arrayIndex].largeArtistImageUrl!)
                    self.load_artistName(self.artistStructArray[arrayIndex].artistName!)
                }
            } else if image.center.x > self.view.bounds.width - 100 {
                //print("chosen")
                if arrayIndex+1 < artistStructArray.count {
                    storedEvents.append(self.artistStructArray[arrayIndex])
                    arrayIndex++
                    self.load_image(self.artistStructArray[arrayIndex].largeArtistImageUrl!)
                    self.load_artistName(self.artistStructArray[arrayIndex].artistName!)
                }
                print("event stored \(self.artistStructArray[arrayIndex-1].artistName!)")
            }
            arrayIndexDefault.setInteger(arrayIndex, forKey: "userArrayIndex")
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            image.transform = stretch
            image.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2 - 70)
        }
    }
    
    func loadURL() {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request) {
            [unowned self] (data, response, error) -> Void in
            if (error != nil){
                print(error)
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                
                if let dict = json as? [String: AnyObject] {
                    
                    if let recommendations = dict["recommendations"] as? [String: AnyObject] {
                        
                        if let optional = recommendations["top"] as? [String: AnyObject] {
                            
                            
                            if let recommendedArtists = optional["recommendedArtists"] as? [NSObject] {
                                for artist: NSObject in recommendedArtists {
                                    
                                    if let artistDict = artist as? [String: AnyObject] {
                                        var currArtist = Artist()
                                        if let artistObject = artistDict["artist"] as? [String: AnyObject] {
                                            currArtist.artistId = artistObject["artistId"] as? Int
                                            currArtist.artistImageUrl = artistObject["artistImageUrl"] as? String
                                            currArtist.artistLinkId = artistObject["artistLinkId"] as? String
                                            currArtist.artistName = artistObject["artistName"] as? String
                                            currArtist.largeArtistImageUrl = artistObject["largeArtistImageUrl"] as? String
                                        }
                                        self.artistStructArray.append(currArtist)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch {
                print ("Error serializing JSON: \(error)")
            }
            print(self.artistStructArray.count)
            if self.artistStructArray.count > 0 {
                self.load_image(self.artistStructArray[self.arrayIndex].largeArtistImageUrl!)
                self.load_artistName(self.artistStructArray[self.arrayIndex].artistName!)
            }
        }
        
        task.resume()
        
        eventImage.reloadInputViews()
        
    }

    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.eventImage.image = UIImage(data: data!)
                }
        })
    }
    
    func load_artistName(artistNameString:String)
    {
        self.eventTitleTime.text = self.artistStructArray[arrayIndex].artistName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func TMLink(sender: AnyObject) {
        if let url = NSURL(string: "http://m.ticketmaster.com/event/06004F8BEAE7A3CD?") {
            UIApplication.sharedApplication().openURL(url)
        }
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
