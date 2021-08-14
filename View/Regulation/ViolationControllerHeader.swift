//
//  ViolationControllerHeader.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

class ViolationControllerHeaderView:UIView {
    //MARK: - DATA
    var viewModel:ViolationHeaderViewModel? {
        didSet { configure() }
    }
    var warningHeaderViewModel:WarningHeaderViewModel? {
        didSet{ configureWarningHeaderViewModel() }
    }
    //MARK: - PROPERTIES
    private let headerImage:UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.slash"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .label
        iv.setDimensions(height: 55, width: 55)
        return iv
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .sunFlowerSlim
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .flowerSystem
        label.textAlignment = .center
        return label
    }()
    private lazy var violationHeaderStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerImage,titleLabel,descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 13
        stack.setCustomSpacing(21, after: headerImage)
        return stack
    }()
    //MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(violationHeaderStackView)
        violationHeaderStackView.centerX(inView: self, topAnchor: topAnchor, paddingTop: 34)
        violationHeaderStackView.anchor(left:leadingAnchor,right: trailingAnchor,paddingLeft: 13,paddingRight: 13)
        
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
        descriptionLabel.text = viewModel.descriptionText
        
    }
    func configureWarningHeaderViewModel() {
        guard let viewModel = warningHeaderViewModel else {return}
        
        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        headerImage.isHidden = true
    }
}
//MARK: - EXTENSIONS
