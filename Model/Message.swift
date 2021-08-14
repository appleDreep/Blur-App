//
//  Message.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// the message object struct.

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
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.ownerProfileImageUrl = dictionary["ownerProfileImageUrl"] as? String ?? ""
    }
}
