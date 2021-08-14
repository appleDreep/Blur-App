//
//  ViolationControllerCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

class ViolationControllerCell:UITableViewCell {
    //MARK: - DATA
    var viewModel:ViolationViewModel? {
        didSet { configure() }
    }
    var warningViewModel:WarningViewModel? {
        didSet { configureWarningViewModel() }
    }
    //MARK: - PROPERTIES
    private let titleImage:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        return button
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .flowerSystem
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let secondaryTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .flowerSystem
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let violationImage:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.setDimensions(height: 45, width: 45)
        return iv
    }()
    private let arrowButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        return button
    }()
    private lazy var labelStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,secondaryTitleLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    private lazy var violationCellStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleImage,labelStackView,violationImage,arrowButton])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 13
        stack.alignment = .top
        return stack
    }()
    private var rowTopAnchorLayoutConstraint:NSLayoutConstraint?
    private var rowBottomAnchorLayoutConstraint:NSLayoutConstraint?
    //MARK: - LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        addSubview(violationCellStackView)
        violationCellStackView.centerY(inView: self)
        
        rowTopAnchorLayoutConstraint = violationCellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 21)
        rowTopAnchorLayoutConstraint?.isActive = true
        
        rowBottomAnchorLayoutConstraint = violationCellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        rowBottomAnchorLayoutConstraint?.isActive = true
        
        violationCellStackView.anchor(left: leadingAnchor, right: trailingAnchor, paddingLeft: 21, paddingRight: 21)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    //MARK: - API
    //MARK: - HELPERS
    func configure() {
        guard let viewModel = viewModel else {return}
        
        violationImage.sd_setImage(with: viewModel.violationImageUrl)
        titleImage.setImage(viewModel.titleImage, for: .normal)
        titleLabel.text = viewModel.titleText
        secondaryTitleLabel.text = viewModel.secondaryTitleText
        
        violationCellStackView.alignment = viewModel.titleImageAlignment
        
        violationImage.isHidden = viewModel.hiddenElements
        arrowButton.isHidden = viewModel.hiddenElements
        secondaryTitleLabel.isHidden = !viewModel.hiddenElements
        
        rowTopAnchorLayoutConstraint?.constant = viewModel.layoutConstraintConstant
        rowBottomAnchorLayoutConstraint?.constant = -viewModel.layoutConstraintConstant
        
    }
    func configureWarningViewModel() {
        guard let viewModel = warningViewModel else {return}
        
        violationImage.sd_setImage(with: viewModel.violationImageUrl)
        titleImage.setImage(viewModel.titleImage, for: .normal)
        titleLabel.text = viewModel.titleText
        
        violationCellStackView.alignment = .center
        
        secondaryTitleLabel.isHidden = true
        arrowButton.isHidden = true
        
        rowTopAnchorLayoutConstraint?.constant = viewModel.layoutConstraintConstant
        rowBottomAnchorLayoutConstraint?.constant = -viewModel.layoutConstraintConstant
    }
}
//MARK: - EXTENSIONS
