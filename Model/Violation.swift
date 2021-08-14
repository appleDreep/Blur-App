//
//  Violation.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

// user violation model

struct Violation {
    let type:String
    let url:String
    let timeCreated:String
    
    init(dictionary:[String:Any]) {
        self.type = dictionary["type"] as? String ?? ""
        self.url = dictionary["url"] as? String ?? ""
        self.timeCreated = dictionary["timeCreated"] as? String ?? ""
    }
}
