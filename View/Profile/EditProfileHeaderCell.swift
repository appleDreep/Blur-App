//
//  EditProfileHeaderCell.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the supplementary table header view to show the user information.

protocol EditProfileHeaderCellDelegate:AnyObject {
    func changePhoto(header:EditProfileHeaderCell)
}

class EditProfileHeaderCell:UICollectionReusableView {
    
    //MARK: - DATA
    private var user:User
    weak var delegate:EditProfileHeaderCellDelegate?
    
    //MARK: - PROPERTIES
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 89 / 2
        iv.setDimensions(height: 89, width: 89)
        return iv
    }()
    private lazy var editProfilePhotoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(handleEditProfilePhoto), for: .touchUpInside)
        return button
    }()
    //MARK: - LIFECYCLE
    init(user:User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        profileImageView.center(inView: self)
        
        profileImageView.addSubview(editProfilePhotoButton)
        editProfilePhotoButton.fillSuperview()
        
        let profileImageUrl = URL(string: user.profileImageUrl)
        profileImageView.sd_setImage(with: profileImageUrl)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    @objc func handleEditProfilePhoto() {
        delegate?.changePhoto(header: self)
    }
    //MARK: - API
    //MARK: - HELPERS
}
//MARK: - EXTENSIONS
