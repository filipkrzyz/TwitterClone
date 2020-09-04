//
//  User.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 04/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct User {
    let fullname: String
    let email: String
    let username: String
    let profileImage: String
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullname       = dictionary["fullname"] as? String ?? ""
        self.email          = dictionary["email"] as? String ?? ""
        self.username       = dictionary["username"] as? String ?? ""
        self.profileImage   = dictionary["profileImage"] as? String ?? ""
    }
}

