//
//  Tweet.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 05/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct Tweet {
    let tweetID: String
    let caption: String
    let uid: String
    var likesCount: Int
    let retweetsCount: Int
    var timestamp: Date!
    let user: User
    var isLiked = false
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.user = user
        self.tweetID = tweetID
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likesCount = dictionary["likesCount"] as? Int ?? 0
        self.retweetsCount = dictionary["retweetsCount"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
