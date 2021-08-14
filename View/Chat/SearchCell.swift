//
//  SearchCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the cells of the search controller to show a specific user.

class SearchCell:UITableViewCell {
    //MARK: - DATA
    var viewModel:UserCellViewModel? {
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
    private let fullnameLabel:UILabel = {
        let label = UILabel()
        label.font = .flowerSystem
        label.textColor = .secondaryLabel
        return label
    }()
    private lazy var labelStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [usernameLabel,fullnameLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        return stack
    }()
    private lazy var searchCellStackView:UIStackView = {
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
        
        addSubview(searchCellStackView)
        searchCellStackView.centerY(inView: self)
        searchCellStackView.anchor(left: leadingAnchor, right: trailingAnchor, paddingLeft: 21,paddingRight: 21)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configure() {
        guard let viewModel = viewModel else {return}
        
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
        fullnameLabel.isHidden = viewModel.fullname.isEmpty
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
//MARK: - EXTENSIONS
