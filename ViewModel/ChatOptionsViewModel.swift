//
//  ChatOptionsViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

enum ChatOptions:Int,CaseIterable {
    case Block
    case Report
    
    var description:String {
        switch self {
        
        case .Block:
            return "Block"
        case .Report:
            return "Report"
        }
    }
    var descriptionUnblock:String {
        switch self {
        
        case .Block:
            return "Unblock"
        case .Report:
            return "Report"
        }
    }
}

struct ChatOptionsViewModel {
    private let chatOptions:ChatOptions
    private let userBlocked:Bool
    
    var chatOptionsDescription:String {
        return userBlocked ? chatOptions.descriptionUnblock : chatOptions.description
    }
    var chatOptionsImage:UIImage? {
        switch chatOptions {
        
        case .Block:
            return UIImage(systemName: "lock")
        case .Report:
            return UIImage(systemName: "exclamationmark.circle")
        }
    }
    
    init(option:ChatOptions,userBlocked:Bool) {
        self.chatOptions = option
        self.userBlocked = userBlocked
    }
}
