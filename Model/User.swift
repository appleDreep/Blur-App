//
//  User.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// the user object struct.

struct User {
    let uid:String
    let date:Timestamp
    var username:String
    var fullname:String
    var profileImageUrl:String
    var violation:Bool
    
    var isCurrentUser:Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary:[String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.date = dictionary["date"] as? Timestamp ?? Timestamp(date: Date())
        self.violation = dictionary["violation"] as? Bool ?? false
    }
}
