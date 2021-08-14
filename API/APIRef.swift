//
//  APIRef.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// references to firebase collections.

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_REGULATION = Firestore.firestore().collection("regulation")
