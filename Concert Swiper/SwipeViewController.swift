//
//  SwipeViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {
    let url = NSURL(string: "http://app.map.jash1.syseng.tmcs:8080/api/mapping/hp?domain=US&marketId=27")
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitleTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    var artist: Artist?
    var arrayOfStruct = [Artist]()
    var storedEvents = [Artist]()
    
    let identifier = "CellIdentifier"
    var arrayIndex = 0
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToMatchesTableView" {
            let viewController: MatchesCollectionViewController = segue.destinationViewController as! MatchesCollectionViewController
            viewController.matchesArray = storedEvents
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
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
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if image.center.x < 100 {
                //print("not chosen")
                arrayIndex++
                //print(self.arrayOfStruct[arrayIndex].largeArtistImageUrl)
                self.load_image(self.arrayOfStruct[arrayIndex].largeArtistImageUrl!)
                self.load_artistName(self.arrayOfStruct[arrayIndex].artistName!)
            } else if image.center.x > self.view.bounds.width - 100 {
                //print("chosen")
                storedEvents.append(self.arrayOfStruct[arrayIndex])
                arrayIndex++
                self.load_image(self.arrayOfStruct[arrayIndex].largeArtistImageUrl!)
                self.load_artistName(self.arrayOfStruct[arrayIndex].artistName!)
                print("event stored \(self.arrayOfStruct[arrayIndex-1].artistName!)")
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            image.transform = stretch
            image.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2 - 70)
        }
        //print(translation)
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
                                        self.arrayOfStruct.append(currArtist)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch {
                print ("Error serializing JSON: \(error)")
            }
            print(self.arrayOfStruct[self.arrayIndex].largeArtistImageUrl)
            self.load_image(self.arrayOfStruct[self.arrayIndex].largeArtistImageUrl!)
            self.load_artistName(self.arrayOfStruct[self.arrayIndex].artistName!)
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
        self.eventTitleTime.text = self.arrayOfStruct[arrayIndex].artistName
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func action() {
        //collectionView.reloadData()
    }
    
    @IBAction func TMLink(sender: AnyObject) {
        if let url = NSURL(string: "http://m.ticketmaster.com/event/06004F8BEAE7A3CD?") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var eventTimeAndLocationIndex = 0
//        if indexPath.row == 0 {
//            let cell: EventImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventImageCellID", forIndexPath: indexPath) as! EventImageCollectionViewCell
//            cell.eventImage.image = UIImage(named: collectionImages[indexPath.row])
//            return cell
//        }
//        else if indexPath.row == 1 {
//            let cell: EventLocationAndTimeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventLocationAndTimeCellID", forIndexPath: indexPath) as! EventLocationAndTimeCollectionViewCell
//            cell.eventLocation.text = collectionEventLocationData[eventTimeAndLocationIndex]
//            cell.eventTime.text = collectionTimeData[eventTimeAndLocationIndex]
//            eventTimeAndLocationIndex += 1
//            return cell
//        }
//        
//        return UICollectionViewCell.init()
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print("Selected \(indexPath.row)")
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        var size = CGSize()
//        if indexPath.row == 0 {
//            size = CGSize.init(width: 414, height: 253)
//        }
//        else if indexPath.row == 1 {
//            size = CGSize.init(width: 414, height: 150)
//        }
//        return size
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
