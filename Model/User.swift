//
//  User.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// the user object struct.
enum UserKey:String {
    case username
    case fullname
    case profileImageUrl
    case uid
    case date
    case violation
    case disabled
}

struct User {
    let uid:String
    let date:Timestamp
    var username:String
    var fullname:String
    var profileImageUrl:String
    var violation:Bool
    var disabled:Bool
    
    var isCurrentUser:Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary:[String:Any]) {
        self.username = dictionary[UserKey.username.rawValue] as? String ?? ""
        self.fullname = dictionary[UserKey.fullname.rawValue] as? String ?? ""
        self.profileImageUrl = dictionary[UserKey.profileImageUrl.rawValue] as? String ?? ""
        self.uid = dictionary[UserKey.uid.rawValue] as? String ?? ""
        self.date = dictionary[UserKey.date.rawValue] as? Timestamp ?? Timestamp(date: Date())
        self.violation = dictionary[UserKey.violation.rawValue] as? Bool ?? false
        self.disabled = dictionary[UserKey.disabled.rawValue] as? Bool ?? false
    }
}
