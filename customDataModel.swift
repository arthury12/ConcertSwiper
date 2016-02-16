//
//  customDataModel.swift
//  Concert Swiper
//
//  Created by Arthur Yu on 2/10/16.
//  Copyright © 2016 Arthur Yu. All rights reserved.
//

import Foundation

struct Artist {
    var artistId: Int?
    var artistImageUrl: String?
    var artistLinkId: String?
    var artistName: String?
    var largeArtistImageUrl: String?
    var score: Int?
    var strategy: String?
    
//    init (JSONdata: NSData){
//        do {
//            let json = try NSJSONSerialization.JSONObjectWithData(JSONdata, options: NSJSONReadingOptions.AllowFragments)
//            
//            if let dict = json as? [String: AnyObject] {
//                
//                if let recommendations = dict["recommendations"] as? [String: AnyObject] {
//                
//                    if let optional = recommendations["top"] as? [String: AnyObject] {
//                        
//                        if let recommendedArtists = optional["recommendedArtists"] as? [NSObject] {
//                            for artist: NSObject in recommendedArtists {
//                                
//                                if let artistDict = artist as? [String: AnyObject] {
//                                    
//                                    if let artistObject = artistDict["artist"] as? [String: AnyObject] {
//                                        self.artistId = artistObject["artistId"] as? Int
//                                        self.artistImageUrl = artistObject["artistImageUrl"] as? String
//                                        self.artistLinkId = artistObject["artistLinkId"] as? String
//                                        self.artistName = artistObject["artistName"] as? String
//                                        self.largeArtistImageUrl = artistObject["largeArtistImageUrl"] as? String
//                                        print (artistImageUrl)
//                                        print (largeArtistImageUrl)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        
//        } catch {
//            print ("Error serializing JSON: \(error)")
//        }
//
//        
//    }
}