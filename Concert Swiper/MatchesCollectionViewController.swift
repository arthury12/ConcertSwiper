//
//  MatchesCollectionViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit
import SafariServices

class MatchesCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate {
    @IBOutlet weak var matchesTableView: UITableView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    let tableArrayDefaults = NSUserDefaults.standardUserDefaults()
    var tableArray: [String] = []
    
    var artist: Artist?
    var artistDict = [String : String]()
    var arrayAsData = NSData()
    //var tableArrayDefaults = NSUserDefaults.standardUserDefaults()
    var matchesArray = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //TO DO: add slide to remove functionality
//        if editingStyle == .Delete {
//            deleteIndexPath = indexPath
//            let artistToDelete =
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as? MatchesCell {
       
            cell.artistName.text = matchesArray[indexPath.row].artistName
            cell.artistName.font = cell.artistName.font.fontWithSize(13)
        
            if let urlString = matchesArray[indexPath.row].artistImageUrl {
                if let url = NSURL(string: urlString) {
                    if let imageData = NSData(contentsOfURL: url) {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSNotificationCenter.defaultCenter().postNotificationName("imageSelected", object: self, userInfo: nil)
        if let currentEventTMLink = matchesArray[indexPath.row].artistLinkId {
            if let url = NSURL(string: currentEventTMLink) {
                let safariVC = SFSafariViewController(URL: url)
                self.presentViewController(safariVC, animated: true, completion: nil)
            }
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
