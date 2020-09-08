//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 07/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit

struct TweetViewModel {
    
    // MARK: - Properties
    
    let tweet: Tweet
    let user: User
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var userInfoText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: user.fullname,
                                                 attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: " @\(user.username)",
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        attributedString.append(NSAttributedString(string: " ・\(timestamp)",
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedString
    }
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
}
