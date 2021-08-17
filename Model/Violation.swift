//
//  Violation.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// user violation model
enum ViolationKey:String {
    case type
    case url
    case timeCreated
}

struct Violation {
    let type:String
    let url:String
    let timeCreated:String
    
    init(dictionary:[String:Any]) {
        self.type = dictionary[ViolationKey.type.rawValue] as? String ?? ""
        self.url = dictionary[ViolationKey.url.rawValue] as? String ?? ""
        self.timeCreated = dictionary[ViolationKey.timeCreated.rawValue] as? String ?? ""
    }
}
