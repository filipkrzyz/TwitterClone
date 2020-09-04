//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 04/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print("DEBUG: Snapshot: \(snapshot)")
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            print("DEBUG: Dictionary is: \(dictionary)")
            
            guard let username = dictionary["username"] as? String else { return }
            print("DEBUG: Username is: \(username)")
            
            let user = User(uid: uid, dictionary: dictionary)
            print("DEBUG: Username: \(user.username)")
        }
    }
}
