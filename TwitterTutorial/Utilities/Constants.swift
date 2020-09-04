//
//  Constants.swift
//  TwitterTutorial
//
//  Created by Filip Krzyzanowski on 03/09/2020.
//  Copyright © 2020 Filip Krzyzanowski. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

