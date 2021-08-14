//
//  ChatsCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit
import SDWebImage

// the cells in the conversations main menu.

class ChatsCell:UITableViewCell {
    //MARK: - DATA
    var viewModel:ChatViewModel? {
        didSet { configure() }
    }
    //MARK: - PROPERTIES
    private let profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 55 / 2
        iv.setDimensions(height: 55, width: 55)
        return iv
    }()
    private let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = .flowerLabelBold
        return label
    }()
    private let messageLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    private let timestampLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    private lazy var messageLabelStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [messageLabel,timestampLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    private lazy var labelStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel,messageLabelStackView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        return stack
    }()
    private lazy var ChatsCellStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView,labelStackView])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 13
        stack.alignment = .center
        return stack
    }()
    //MARK: - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        addSubview(ChatsCellStackView)
        ChatsCellStackView.centerY(inView: self)
        ChatsCellStackView.anchor(left: leadingAnchor, right: trailingAnchor, paddingLeft: 21,paddingRight: 21)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configure() {
        guard let viewModel = viewModel else {return}
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        usernameLabel.text = viewModel.username
        messageLabel.attributedText = viewModel.conversationsMessage
        timestampLabel.attributedText = viewModel.conversationsTimestamp
        
    }
}
//MARK: - EXTENSIONS
