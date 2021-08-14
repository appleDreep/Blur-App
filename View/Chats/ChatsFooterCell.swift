//
//  ChatsFooterCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// cells in the table footer supplemental view.

class ChatsFooterCell:UICollectionViewCell {
    //MARK: - DATA
    var viewModel:UserCellViewModel? {
        didSet{ configure() }
    }
    //MARK: - PROPERTIES
    private lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBackground
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
        label.font = .flowerLabelBold
        label.textAlignment = .center
        return label
    }()
    private let fullnameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .flowerSystem
        label.textAlignment = .center
        return label
    }()
    private let messageButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Message", for: .normal)
        button.titleLabel?.font = .flowerSystemBold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.setDimensions(height: 30, width: 100)
        button.isUserInteractionEnabled = false
        return button
    }()
    private lazy var chatsControllerStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView,usernameLabel,fullnameLabel,messageButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        stack.setCustomSpacing(10, after: profileImageView)
        stack.setCustomSpacing(10, after: fullnameLabel)
        return stack
    }()
    //MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = 21
        clipsToBounds = true
        
        let effect = UIBlurEffect(style: .systemChromeMaterial)
        let view = UIVisualEffectView(effect: effect)
        
        addSubview(view)
        view.fillSuperview()
        
        addSubview(chatsControllerStackView)
        chatsControllerStackView.center(inView: self)
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
        fullnameLabel.text = viewModel.fullname.isEmpty ? viewModel.username : viewModel.fullname
    }
}
//MARK: - EXTENSIONS
