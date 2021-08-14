//
//  RegistrationController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the RegistrationController is the controller to enter the application by registering your username.

class RegistrationController:UIViewController {
    //MARK: - DATA
    private var viewModel = AuthenticationButtonViewModel()
    
    weak var delegate:AuthenticationDelegate?
    
    //MARK: - PROPERTIES
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Add name"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .sunFlower
        label.alpha = 0
        label.isHidden = true
        return label
    }()
    private lazy var registrationTextFieldView:UIView = {
        let view = Utilities().createTextFieldView(textField: registrationTextField, title: "Username",height: 55,cornerRadius: 21,color: UIColor.secondarySystemBackground.withAlphaComponent(0.5))
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    private let registrationTextField:UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.keyboardType = .alphabet
        return tf
    }()
    private let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setDimensions(height: 55, width: 233)
        button.layer.cornerRadius = 21 / 2
        button.alpha = 0
        button.isHidden = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    private let policyButton:UIButton = {
        let button = Utilities().attributedButton(part1: "By signing up, you agree to our", part2: "Terms, Data Policy.", color1: .secondaryLabel, color2: .secondaryLabel)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.isHidden = true
        button.alpha = 0
        button.addTarget(self, action: #selector(handlePrivacyPolicy), for: .touchUpInside)
        return button
    }()
    private lazy var registrationStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel,registrationTextFieldView,signUpButton,policyButton])
        stack.axis = .vertical
        stack.spacing = 21
        stack.setCustomSpacing(13, after: registrationTextFieldView)
        stack.setCustomSpacing(34, after: titleLabel)
        return stack
    }()
    private lazy var viewResignKeyboard:UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyBoardDidTapUpInside)))
        return view
    }()
    private var stackCenterYAnchorConstraint:NSLayoutConstraint?
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        animateRegistrationStackView()
        
    }
    //MARK: - SELECTORS
    @objc func handleSignUp() {
        registrationTextField.resignFirstResponder()
        
        guard registrationTextField.text != nil else {return}
        guard let username = registrationTextField.text else {return}
        
        AuthService.registerUser(username: username) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.delegate?.AuthenticationDidComplete()
        }
    }
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        animateLogInStackTranslation(notification: notification)
    }
    @objc func handleDismissKeyBoardDidTapUpInside(_ gesture:UITapGestureRecognizer) {
        registrationTextField.resignFirstResponder()
    }
    @objc func textDidChange() {
        viewModel.text = registrationTextField.text
        updateForm()
    }
    @objc func handlePrivacyPolicy() {
        
    }
    //MARK: - API
    //MARK: - HELPERS
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        registrationTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        registrationTextField.delegate = self
        
        view.addSubview(viewResignKeyboard)
        viewResignKeyboard.fillSuperview()
        
        view.addSubview(registrationStackView)
        registrationStackView.center(inView: view)
        stackCenterYAnchorConstraint = registrationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        stackCenterYAnchorConstraint?.isActive = true
        registrationStackView.anchor(left: view.leadingAnchor, right: view.trailingAnchor,paddingLeft: 55,paddingRight: 55)
    }
    func animateLogInStackTranslation(notification:Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyBoardShowing = notification.name == RegistrationController.keyboardWillShowNotification
            
            stackCenterYAnchorConstraint?.constant = isKeyBoardShowing ? -keyboardHeight / 3 : 0
            
            UIView.animate(withDuration: 0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func animateRegistrationStackView() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            UIView.animate(withDuration: 0.5) {
                self.titleLabel.isHidden = false
                self.titleLabel.alpha = 1
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5,delay: 0.5) {
                    self.registrationTextFieldView.isHidden = false
                    self.signUpButton.isHidden = false
                    self.policyButton.isHidden = false
                    self.registrationTextFieldView.alpha = 1
                    self.signUpButton.alpha = 1
                    self.policyButton.alpha = 1
                    self.signUpButton.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.5)
                }
            }
        }
    }
}
//MARK: - EXTENSIONS
//MARK:-UITextFieldDelegate
extension RegistrationController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet.letters.inverted
        let numbersSet = CharacterSet.alphanumerics.inverted
        
        if string.rangeOfCharacter(from: characterSet) != nil && string.rangeOfCharacter(from: numbersSet) != nil {
            return false
        }
        return true
    }
}
//MARK:-FormViewModel
extension RegistrationController:FormViewModel {
    func updateForm() {
        signUpButton.isEnabled = viewModel.formIsValid
        UIView.animate(withDuration: 0.3) {
            self.signUpButton.backgroundColor = self.viewModel.buttonBackgroundColor
            self.view.layoutIfNeeded()
        }
    }
}
