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
    let googleURL = NSURL(string: "http://www.google.com/")
    
    var tableArray: [String] = []
    
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
        return tableArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) 
        
        cell.textLabel?.text = tableArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("imageSelected", object: self, userInfo: nil)
    }

    func loadURL() {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var request = NSMutableURLRequest(URL: googleURL!)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: { [unowned self] (data, response, error) -> Void in
            if (error != nil){
                print(error)
            }
            print(response)
            self.matchesTableView.reloadData()
            
            })
        
        task.resume()
        
        matchesTableView.reloadData()
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
