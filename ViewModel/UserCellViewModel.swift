//
//  UserCellViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the UserCellViewModel used to model all referring classes with cells representing users.

struct UserCellViewModel {
    private let user:User
    
    var username:String {
        return user.username
    }
    var fullname:String {
        return user.fullname
    }
    var profileImageUrl:URL? {
        return URL(string: user.profileImageUrl)
    }
    init(user:User) {
        self.user = user
    }
}
