//
//  ChatControllerHeaderView.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the supplementary table header view to show the user information.

class ChatControllerHeaderView:UIView {
    //MARK: - DATA
    private let user:User
    //MARK: - PROPERTIES
    private lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 89 / 2
        iv.setDimensions(height: 89, width: 89)
        return iv
    }()
    private let usernameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font =  .flowerLabelSuperBold
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .flower
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var chatControllerStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView,usernameLabel,descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        stack.setCustomSpacing(10, after: profileImageView)
        return stack
    }()
    //MARK: - LIFECYCLE
    init(user:User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        
        addSubview(chatControllerStackView)
        chatControllerStackView.widthAnchor.constraint(equalToConstant: 233).isActive = true
        chatControllerStackView.center(inView: self)
        
        let profileImageUrl = URL(string: user.profileImageUrl)
        profileImageView.sd_setImage(with: profileImageUrl)
        usernameLabel.text = user.username
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let date =  formatter.string(from: user.date.dateValue())
        
        descriptionLabel.text = "\(user.fullname.isEmpty ? user.username : user.fullname)・\(user.username) joined on \(date)"
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
}
//MARK: - EXTENSIONS
