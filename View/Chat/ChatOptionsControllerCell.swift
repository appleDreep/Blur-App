//
//  ChatOptionsControllerCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

class ChatOptionsControllerCell:UITableViewCell {
    //MARK: - DATA
    var viewModel:ChatOptionsViewModel? {
        didSet { configure() }
    }
    //MARK: - PROPERTIES
    private let optionsUserImage:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        return button
    }()
    private let optionsUserTitle:UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .flower
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = false
        return button
    }()
    private lazy var optionsStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [optionsUserImage,optionsUserTitle])
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
        
        contentView.addSubview(optionsStackView)
        optionsStackView.centerY(inView: self)
        optionsStackView.anchor(left: leadingAnchor,paddingLeft: 21)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configure() {
        guard let viewModel = viewModel else { return }
        
        optionsUserTitle.setTitle(viewModel.chatOptionsDescription, for: .normal)
        optionsUserImage.setImage(viewModel.chatOptionsImage, for: .normal)
        
    }
}
//MARK: - EXTENSIONS
