//
//  ChatCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit
import Firebase

// the cells or chat bubbles in the chat controller.

class ChatCell:UITableViewCell {
    //MARK: - DATA
    var viewModel:ChatViewModel? {
        didSet { configure() }
    }
    //MARK: - PROPERTIES
    private let messageLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let bubbleView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40 / 2
        return view
    }()
    private var messageLabelLeftAnchor:NSLayoutConstraint?
    private var messageLabelRightAnchor:NSLayoutConstraint?
    private var messageLabelTopAnchor:NSLayoutConstraint?
    private var messageLabelBottomAnchor:NSLayoutConstraint?
    
    //MARK: - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        addSubview(bubbleView)
        addSubview(messageLabel)
        
        messageLabelLeftAnchor = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19)
        messageLabelLeftAnchor?.isActive = false
        
        messageLabelRightAnchor = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19)
        messageLabelRightAnchor?.isActive = false
        
        messageLabelTopAnchor = messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        messageLabelTopAnchor?.isActive = true
        
        messageLabelBottomAnchor = messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        messageLabelBottomAnchor?.isActive = true
        
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleView.anchor(top: messageLabel.topAnchor, left: messageLabel.leadingAnchor, bottom: messageLabel.bottomAnchor, right: messageLabel.trailingAnchor, paddingTop: -10.25, paddingLeft: -10.25, paddingBottom: -10.25, paddingRight: -10.25)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configure() {
        guard let viewModel = viewModel else {return}
        
        bubbleView.backgroundColor = viewModel.bubbleBackgroundColor
        
        messageLabel.text = viewModel.messageText
        messageLabel.font = viewModel.messageTextFont
        messageLabel.textColor = viewModel.messageTextColor
        messageLabel.textAlignment = viewModel.messageTextCenterAlignment ? .center : .natural
        
        messageLabelLeftAnchor?.isActive = viewModel.labelLeftAnchor
        messageLabelRightAnchor?.isActive = viewModel.labelRightAnchor
        
        messageLabelTopAnchor?.constant = viewModel.labelEmojiTopAnchor
        messageLabelBottomAnchor?.constant = viewModel.labelEmojiBottomAnchor
        messageLabelLeftAnchor?.constant = viewModel.labelEmojiLeftAnchor
        messageLabelRightAnchor?.constant = viewModel.labelEmojiRightAnchor
    }
}
//MARK: - EXTENSIONS
