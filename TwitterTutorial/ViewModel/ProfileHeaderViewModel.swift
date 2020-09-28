//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 09/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
            case .tweets: return "Tweets"
            case .replies: return "Tweets & Replies"
            case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(value: 2, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(value: 0, text: "following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit profile"
        } else {
            return "Follow"
        }
    }
    
    init(user: User) {
        self.user = user
        
        self.usernameText = "@\(user.username)"
    }
    
    fileprivate func attributedText(value: Int, text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: " \(text)",
            attributes: [.font: UIFont.systemFont(ofSize: 14),
                         .foregroundColor: UIColor.lightGray]))
        
        return attributedString
    }
}
