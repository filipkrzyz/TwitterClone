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
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
}
