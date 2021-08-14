//
//  EditProfileViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the EditProfileViewModel used to model the controllers for editing profile.

enum EditProfileOptions: Int,CaseIterable {
    case username
    case fullname
    
    var description:String {
        switch self {
        case .username :
            return "Username"
        case .fullname:
            return "Fullname"
        }
    }
}
struct EditProfileViewModel {
    private let user:User
    let option: EditProfileOptions
    
    var titleText:String {
        return option.description
    }
    var optionValue:String? {
        switch option {
        
        case .username:
            return user.username
        case .fullname:
            return user.fullname
        }
    }
    var placeHolderValue:NSAttributedString{
        switch option{
        
        case .username:
            return NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor:UIColor.secondaryLabel])
        case .fullname:
            return NSAttributedString(string: "Fullname", attributes: [NSAttributedString.Key.foregroundColor:UIColor.secondaryLabel])
        }
    }
    init(user:User,option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
