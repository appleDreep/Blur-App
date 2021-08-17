//
//  LogInController.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the LogInController is the controller to enter the app through authentication.
enum AuthCompleteType {
    case normal
    case async
}

protocol AuthenticationDelegate:AnyObject {
    func AuthenticationDidComplete(type:AuthCompleteType)
}

class LogInController:UIViewController {
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
        label.text = "Log in to Blur"
        label.textColor = .label
        label.font = .sunFlower
        label.textAlignment = .center
        label.alpha = 0
        label.isHidden = true
        return label
    }()
    private let logInFacebookButton:UIButton = {
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
    private let logInAppleButton:UIButton = {
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
    private let signUpButton:UIButton = {
        let button = Utilities().attributedButton(part1: "Don't have an account?", part2: "Sign up.", color1: .secondaryLabel, color2: .secondaryLabel)
        button.alpha = 0
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    private lazy var logInStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoImageView,titleLabel,logInAppleButton,logInFacebookButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 21
        stack.setCustomSpacing(13, after: logInAppleButton)
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
        let controller = SignUpController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
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
        
        view.addSubview(logInStackView)
        logInStackView.center(inView: view)
        
        view.addSubview(signUpButton)
        signUpButton.centerX(inView: view)
        signUpButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 21)
        signUpButton.anchor(left: view.leadingAnchor,right: view.trailingAnchor,paddingLeft: 55,paddingRight: 55)
    }
    func animateLogInStackView() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            UIView.animate(withDuration: 0.5) {
                self.titleLabel.isHidden = false
                self.logoImageView.alpha = 1
                self.titleLabel.alpha = 1
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.5,delay: 0.5) {
                    self.logInFacebookButton.isHidden = false
                    self.logInAppleButton.isHidden = false
                    self.signUpButton.alpha = 1
                    self.logInFacebookButton.alpha = 1
                    self.logInAppleButton.alpha = 1
                }
            }
        }
    }
}
//MARK: - EXTENSIONS
