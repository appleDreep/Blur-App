//
//  SignUpController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// SignUpControllerr is the controller to enter the application by registering.

class SignUpController:UIViewController {
    //MARK: - DATA
    weak var delegate:AuthenticationDelegate?
    
    //MARK: - PROPERTIES
    private let logoImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "heart")
        iv.tintColor = .label
        iv.setDimensions(height: 34, width: 34)
        iv.alpha = 0
        return iv
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Sign up for Blur"
        label.textColor = .label
        label.font = .sunFlower
        label.textAlignment = .center
        label.alpha = 0
        label.isHidden = true
        return label
    }()
    private let signUpFacebookButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "facebook.icon"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.5)
        button.setDimensions(height: 55, width: 233)
        button.layer.cornerRadius = 21 / 2
        button.alpha = 0
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSignUpFacebook), for: .touchUpInside)
        return button
    }()
    private let signUpAppleButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.5)
        button.setDimensions(height: 55, width: 233)
        button.layer.cornerRadius = 21 / 2
        button.alpha = 0
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSignUpApple), for: .touchUpInside)
        return button
    }()
    private let logInButton:UIButton = {
        let button = Utilities().attributedButton(part1: "Already have an account?", part2: "Log In.", color1: .secondaryLabel, color2: .secondaryLabel)
        button.alpha = 0
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    private lazy var signUpStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoImageView,titleLabel,signUpAppleButton,signUpFacebookButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 21
        stack.setCustomSpacing(13, after: signUpAppleButton)
        stack.setCustomSpacing(34, after: titleLabel)
        return stack
    }()
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
        animateLogInStackView()
        
    }
    //MARK: - SELECTORS
    @objc func handleSignUp() {
        navigationController?.popViewController(animated: true)
    }
    @objc func handleSignUpFacebook() {
        showLoader(true)
        AuthService.authenticationFacebook(controller: self) { (registered) in
            self.showLoader(false)
            if registered {
                self.delegate?.AuthenticationDidComplete(type: .normal)
            }else {
                let controller = RegistrationController()
                controller.delegate = self.delegate
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    @objc func handleSignUpApple() {
        
    }
    //MARK: - API
    //MARK: - HELPERS
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(signUpStackView)
        signUpStackView.center(inView: view)
        signUpStackView.anchor(left: view.leadingAnchor, right: view.trailingAnchor,paddingLeft: 55,paddingRight: 55)
        
        view.addSubview(logInButton)
        logInButton.centerX(inView: view)
        logInButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 21)
        logInButton.anchor(left: view.leadingAnchor,right: view.trailingAnchor,paddingLeft: 55,paddingRight: 55)
    }
    func animateLogInStackView() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.5) {
                self.titleLabel.isHidden = false
                self.logoImageView.alpha = 1
                self.titleLabel.alpha = 1
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5,delay: 0.5) {
                    self.signUpFacebookButton.isHidden = false
                    self.signUpAppleButton.isHidden = false
                    self.logInButton.alpha = 1
                    self.signUpFacebookButton.alpha = 1
                    self.signUpAppleButton.alpha = 1
                }
            }
        }
    }
}
//MARK: - EXTENSIONS
