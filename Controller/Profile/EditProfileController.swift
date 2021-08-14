//
//  EditProfileController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the EditProfileController is the main controller that displays the interface for editing user information.

let editProfileCellIdentifier = "ProfileCell"

class EditProfileController:UITableViewController {
    //MARK: - DATA
    private var user:User {
        didSet { tableView.reloadData() }
    }
    
    private lazy var headerView = EditProfileHeaderCell(user: user)
    private let imagePicker = UIImagePickerController()
    
    private var userInfoChanged = false
    
    private var imageChanged:Bool { return selectedImage != nil }
    
    private var selectedImage:UIImage? {
        didSet { headerView.profileImageView.image = selectedImage}
    }
    
    //MARK: - PROPERTIES
    private lazy var cancelButton:UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        button.tintColor = .systemBlue
        return button
    }()
    private lazy var doneButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    private let backBarButtonItem:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .label
        return button
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .label
        label.font = .flowerLabelSuperBold
        label.textAlignment = .center
        return label
    }()
    //MARK: - LIFECYCLE
    init(user:User) {
        self.user = user
        super.init(style: .plain)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        configureTableView()
        configureImagePicker()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleDone() {
        view.endEditing(true)
        guard imageChanged || userInfoChanged else {return}
        
        showLoader(true)
        updateUserInfo()
    }
    //MARK: - API
    func updateUser() {
        UserService.updateUser(user: self.user) { (error) in
            self.showLoader(false)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("SUCCESSFULLY_UPDATE_USER_INFO")
            self.dismiss(animated: true, completion: nil)
        }
    }
    func uploadProfileImageView() {
        guard let image = selectedImage else {return}
        UserService.uploadProfileImage(image: image) { (url) in
            print("SUCCESSFULLY_UPLOAD_PROFILE_IMAGE")
            self.showLoader(false)
            self.user.profileImageUrl = url
            self.dismiss(animated: true , completion: nil)
        }
    }
    func updateProfileImageView() {
        guard let image = selectedImage else {return}
        UserService.updateProfileImage(forUser: user, image: image) { (url, error) in
            self.showLoader(false)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("SUCCESSFULLY_UPDATE_PROFILE_IMAGE")
            guard let profileImageUrl = url else {return}
            self.user.profileImageUrl = profileImageUrl
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - HELPERS
    func updateUserInfo() {
        let isDoneButtonEnabled = !(imageChanged && !userInfoChanged || !imageChanged && userInfoChanged || imageChanged && userInfoChanged)
        doneButton.isUserInteractionEnabled = isDoneButtonEnabled
        
        if imageChanged && !userInfoChanged {
            if user.profileImageUrl.isEmpty {
                uploadProfileImageView()
            }else {
                updateProfileImageView()
            }
        }else if !imageChanged && userInfoChanged {
            updateUser()
        }else if imageChanged && userInfoChanged {
            updateUser()
            if user.profileImageUrl.isEmpty {
                uploadProfileImageView()
            }else {
                updateProfileImageView()
            }
        }
    }
    func configureUI() {
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: backBarButtonItem)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    func configureTableView() {
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 144)
        tableView.tableFooterView = UIView()
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: editProfileCellIdentifier)
    }
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}
//MARK: - EXTENSIONS
//MARK:-EditProfileController
extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editProfileCellIdentifier,for: indexPath) as! EditProfileCell
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return cell}
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = EditProfileInfoController()
        controller.delegate = self
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return}
        controller.viewModel = EditProfileViewModel(user: user, option: option)
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK:-EditProfileController
extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
//MARK:-EditProfileHeaderCellDelegate
extension EditProfileController:EditProfileHeaderCellDelegate {
    func changePhoto(header: EditProfileHeaderCell) {
        present(imagePicker, animated: true, completion: nil)
    }
}
//MARK:-UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension EditProfileController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let profileImage = image.withRenderingMode(.alwaysOriginal)
        self.selectedImage = profileImage
        dismiss(animated: true, completion: nil)
    }
}
//MARK:-EditProfileInfoControllerDelegate
extension EditProfileController:EditProfileInfoControllerDelegate {
    func didUpdateInProfileInfoController(_ controller: EditProfileInfoController) {
        guard let viewModel = controller.viewModel else {return}
        
        self.userInfoChanged = true
        
        switch viewModel.option {
        
        case .username:
            guard let username = controller.inputTextField.text else {return}
            return user.username = username
        case .fullname:
            guard let fullname = controller.inputTextField.text else {return}
            return user.fullname = fullname
        }
    }
}
