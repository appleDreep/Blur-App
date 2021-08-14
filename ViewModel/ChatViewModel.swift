//
//  ChatViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the ChatViewModel used to model all the referring classes with the chat cells.

struct ChatViewModel {
    let message:Message
    
    var messageText:String {
        return message.text
    }
    var messageTextFont:UIFont {
        return messageText.containsOnlyEmoji ? .flowerEmoji : .flower
    }
    var messageTextColor:UIColor {
        return message.isFromCurrentUser ? .white : .label
    }
    var messageTextCenterAlignment:Bool {
        return messageText.count <= 5
    }
    var username:String {
        return message.isFromCurrentUser ? message.username : message.ownerUsername
    }
    var bubbleBackgroundColor:UIColor {
        if messageText.containsOnlyEmoji {
            return .clear
        }
        return message.isFromCurrentUser ? .systemPurple : .secondarySystemBackground
    }
    var labelLeftAnchor:Bool {
        return !message.isFromCurrentUser
    }
    var labelRightAnchor:Bool {
        return message.isFromCurrentUser
    }
    var labelEmojiTopAnchor:CGFloat {
        return messageText.containsOnlyEmoji ? 5: 11.25
    }
    var labelEmojiBottomAnchor:CGFloat {
        return messageText.containsOnlyEmoji ? -5 : -11.25
    }
    var labelEmojiLeftAnchor:CGFloat {
        return messageText.containsOnlyEmoji ? 13 : 18.25
    }
    var labelEmojiRightAnchor:CGFloat {
        return messageText.containsOnlyEmoji ? -13 : -18.25
    }
    var profileImageUrl:URL? {
        return message.isFromCurrentUser ?  URL(string: message.profileImageUrl) : URL(string: message.ownerProfileImageUrl)
    }
    var timestampString:String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: message.timestamp.dateValue(), to: Date())
    }
    var conversationsMessage:NSAttributedString {
        return messageAttributedString()
    }
    var conversationsTimestamp:NSAttributedString {
        return messageAttributedString(timestamp: timestampString)
    }
    
    init(message:Message) {
        self.message = message
    }
    
    func messageAttributedString(timestamp:String? = nil) -> NSAttributedString {
        
        if let timestamp = timestamp {
            let text = NSMutableAttributedString(string: "・\(timestamp)", attributes: [.font:UIFont.flowerSystem,.foregroundColor: UIColor.secondaryLabel])
            return text
        }
        let text = NSMutableAttributedString(string: message.isFromCurrentUser ? "You: \(messageText)" : "\(messageText)", attributes: [.font:UIFont.flowerSystem,.foregroundColor:message.isFromCurrentUser ? UIColor.secondaryLabel : UIColor.label])
        
        return text
    }
}
