//
//  SwipeViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let googleURL = NSURL(string: "http://www.google.com/")
    @IBOutlet weak var collectionView: UICollectionView!
    
    let identifier = "CellIdentifier"
    var collectionEventLocationData: [String] = ["Xcel Energy Center, Chicago, IL", "The Forum", "Hollywood Palladium"]
    var collectionTimeData: [String] = ["6/10/2016 7:30pm", "2/21/2016", "2/22/2016"]
    var collectionImages: [String] = ["Adele.jpeg", "JCole.jpg", "Rihanna"]
    
    @IBAction func TMLink(sender: AnyObject) {
        if let url = NSURL(string: "http://m.ticketmaster.com/event/06004F8BEAE7A3CD?") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToMatchesTableView" {
            let viewController: MatchesCollectionViewController = segue.destinationViewController as! MatchesCollectionViewController
            viewController.tableArray = collectionImages
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        collectionView.addGestureRecognizer(gesture)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "action", name: "imageSelected", object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func action() {
        collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var eventTimeAndLocationIndex = 0
        if indexPath.row == 0 {
            let cell: EventImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventImageCellID", forIndexPath: indexPath) as! EventImageCollectionViewCell
            cell.eventImage.image = UIImage(named: collectionImages[indexPath.row])
            return cell
        }
        else if indexPath.row == 1 {
            let cell: EventLocationAndTimeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventLocationAndTimeCellID", forIndexPath: indexPath) as! EventLocationAndTimeCollectionViewCell
            cell.eventLocation.text = collectionEventLocationData[eventTimeAndLocationIndex]
            cell.eventTime.text = collectionTimeData[eventTimeAndLocationIndex]
            eventTimeAndLocationIndex += 1
            return cell
        }
        
        return UICollectionViewCell.init()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected \(indexPath.row)")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSize()
        if indexPath.row == 0 {
            size = CGSize.init(width: 414, height: 253)
        }
        else if indexPath.row == 1 {
            size = CGSize.init(width: 414, height: 150)
        }
        return size
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
