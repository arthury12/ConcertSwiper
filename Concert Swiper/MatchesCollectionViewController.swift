//
//  MatchesCollectionViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class MatchesCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate {
    @IBOutlet weak var matchesTableView: UITableView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    let url = NSURL(string: "http://app.map.jash1.syseng.tmcs:8080/api/mapping/hp?domain=US&marketId=27")
    
    var tableArray: [String] = []
    
    var artist: Artist?
    var matchesArray = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) 
        
        cell.textLabel?.text = matchesArray[indexPath.row].artistName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("imageSelected", object: self, userInfo: nil)
    }

    func loadURL() {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: { [unowned self] (data, response, error) -> Void in
            if (error != nil){
                print(error)
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                
                if let dict = json as? [String: AnyObject] {
                    
                    if let recommendations = dict["recommendations"] as? [String: AnyObject] {
                        
                        if let optional = recommendations["top"] as? [String: AnyObject] {
                            
                            if let recommendedArtists = optional["recommendedArtists"] as? [NSObject] {
                                var index = 0
                                for artist: NSObject in recommendedArtists {
                                    
                                    if let artistDict = artist as? [String: AnyObject] {
                                        var currArtist = Artist()
                                        if let artistObject = artistDict["artist"] as? [String: AnyObject] {
                                            currArtist.artistId = artistObject["artistId"] as? Int
                                            currArtist.artistImageUrl = artistObject["artistImageUrl"] as? String
                                            currArtist.artistLinkId = artistObject["artistLinkId"] as? String
                                            currArtist.artistName = artistObject["artistName"] as? String
                                            currArtist.largeArtistImageUrl = artistObject["largeArtistImageUrl"] as? String
                                            print (currArtist.artistImageUrl)
                                            print (currArtist.artistLinkId)
                                        }
                                        self.arrayOfStruct.append(currArtist)
                                    }
                                    index++
                                }
                            }
                        }
                    }
                }
                
            } catch {
                print ("Error serializing JSON: \(error)")
            }
            
            self.matchesTableView.reloadData()
            
            })
        
        task.resume()
        
        matchesTableView.reloadData()
    }
    
//    func parseJSONIntoStruct(jsonDict: NSDictionary) -> Artist{
//        
//        
//        var artist = Artist(
//        artistId: 1, artistImageUrl: "abc", artistLinkId: "test", artistName: "test", largeArtistImageUrl: NSURL(string: "test"), score: 5, strategy: "test")
//        
//        return artist
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
