//
//  EditProfileCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// cells in profile edit menu.

class EditProfileCell:UITableViewCell {
    //MARK: - DATA
    var viewModel:EditProfileViewModel? {
        didSet { configure() }
    }
    //MARK: - PROPERTIES
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .flower
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    private lazy var infoTextField:UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.isUserInteractionEnabled = false
        tf.font = .flower
        tf.textColor = .secondaryLabel
        tf.textAlignment = .right
        return tf
    }()
    private lazy var editProfileCellStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,infoTextField])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 34
        return stack
    }()
    //MARK: - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        addSubview(editProfileCellStackView)
        editProfileCellStackView.centerY(inView: self)
        editProfileCellStackView.anchor(left: leadingAnchor, right: trailingAnchor, paddingLeft: 21,paddingRight: 21)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configure() {
        guard let viewModel = viewModel else {return}
        
        titleLabel.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
        infoTextField.attributedPlaceholder = viewModel.placeHolderValue
    }
}
//MARK: - EXTENSIONS
