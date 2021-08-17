//
//  Message.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// the message object struct.
enum MessageKey:String {
    case text
    case toId
    case fromId
    case profileImageUrl
    case username
    case timestamp
    case ownerUsername
    case ownerProfileImageUrl
}

struct Message {
    let text:String
    let toId:String
    let fromId:String
    let profileImageUrl:String
    let isFromCurrentUser:Bool
    let username:String
    let ownerUsername:String
    let ownerProfileImageUrl:String
    var timestamp:Timestamp
    
    var chatPartnerId:String {return isFromCurrentUser ? toId : fromId}
    
    init(dictionary:[String:Any]) {
        self.text = dictionary[MessageKey.text.rawValue] as? String ?? ""
        self.toId = dictionary[MessageKey.toId.rawValue] as? String ?? ""
        self.fromId = dictionary[MessageKey.fromId.rawValue] as? String ?? ""
        self.profileImageUrl = dictionary[MessageKey.profileImageUrl.rawValue] as? String ?? ""
        self.username = dictionary[MessageKey.username.rawValue] as? String ?? ""
        self.timestamp = dictionary[MessageKey.timestamp.rawValue] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUsername = dictionary[MessageKey.ownerUsername.rawValue] as? String ?? ""
        self.ownerProfileImageUrl = dictionary[MessageKey.ownerProfileImageUrl.rawValue] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
