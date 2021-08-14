//
//  EditProfileInfoController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the EditProfileInfoController is the main controller that displays the interface to edit the username or any other information.

protocol EditProfileInfoControllerDelegate:AnyObject {
    func didUpdateInProfileInfoController(_ controller:EditProfileInfoController)
}

class EditProfileInfoController:UIViewController {
    
    //MARK: - DATA
    var viewModel:EditProfileViewModel? {
        didSet { configureUI() }
    }
    
    weak var delegate:EditProfileInfoControllerDelegate?
    
    //MARK: - PROPERTIES
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .flowerSystem
        label.textColor = .secondaryLabel
        return label
    }()
    let inputTextField:UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.keyboardType = .alphabet
        tf.font = .flower
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        tf.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        return tf
    }()
    private let adviceLabel:UILabel = {
        let label = UILabel()
        label.font = .flowerSystem
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var infoStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,inputTextField,adviceLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    private lazy var doneButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    private let infoTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .flowerLabelSuperBold
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        inputTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        view.addSubview(infoStackView)
        infoStackView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor,paddingTop: 21)
        infoStackView.anchor(left: view.leadingAnchor, right: view.trailingAnchor, paddingLeft: 21,paddingRight: 21)
        
    }
    
    //MARK: - SELECTORS
    @objc func handleDone(){
        self.delegate?.didUpdateInProfileInfoController(self)
        navigationController?.popViewController(animated: true)
    }
    @objc func handleTextField() {
        checkMaxLenghtTextField(inputTextField)
    }
    
    //MARK: - API
    //MARK: - HELPERS
    func configureUI() {
        guard let viewModel = viewModel else {return}
        
        navigationItem.titleView = infoTitleLabel
        infoTitleLabel.text = viewModel.titleText
        titleLabel.text = viewModel.titleText
        inputTextField.text = viewModel.optionValue
        inputTextField.attributedPlaceholder = NSAttributedString(string: viewModel.titleText, attributes: [NSAttributedString.Key.foregroundColor:UIColor.placeholderText,NSAttributedString.Key.font: UIFont.flower])
        
        switch viewModel.option {
        
        case .username:
            inputTextField.becomeFirstResponder()
            adviceLabel.text = "You can change your username again for 14 more days."
        case .fullname:
            inputTextField.becomeFirstResponder()
            adviceLabel.text = "Help people discover your account by using the name you're known by: either your full name, nickname."
        }
    }
    func checkMaxLenghtTextField(_ textField:UITextField) {
        guard let viewModel = viewModel else {return}
        if let text = textField.text?.count  {
            if text > 21 {
                textField.deleteBackward()
            }
        }
        switch viewModel.option {
        case .username:
            if let empty = textField.text?.isEmpty {
                if empty {
                    doneButton.isUserInteractionEnabled = false
                }else {
                    doneButton.isUserInteractionEnabled = true
                }
            }
        case .fullname:
            break
        }
    }
}
//MARK: - EXTENSIONS
//MARK:-UITextFieldDelegate
extension EditProfileInfoController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet.letters.inverted
        let numbersSet = CharacterSet.alphanumerics.inverted
        
        if string.rangeOfCharacter(from: characterSet) != nil && string.rangeOfCharacter(from: numbersSet) != nil {
            return false
        }
        return true
    }
}
