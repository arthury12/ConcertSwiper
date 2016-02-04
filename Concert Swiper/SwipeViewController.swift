//
//  SwipeViewController.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/3/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: EventImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventImageCellID", forIndexPath: indexPath) as! EventImageCollectionViewCell
//        let cell1: EventLocationCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("EventLocationCellID", forIndexPath: indexPath) as! EventLocationCollectionViewCell
//        let cell2: EventTimeCollectionViewCell =
//            collectionView.dequeueReusableCellWithReuseIdentifier("EventTimeCellID", forIndexPath: indexPath) as! EventImageCollectionViewCell
        
        cell.eventImage.image = UIImage(named: collectionImages[indexPath.row])
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
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
