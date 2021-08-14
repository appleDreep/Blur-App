//
//  CustomAccesoryView.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the text container of the chat controller to send messages etc.

protocol CustomAccesoryViewDelegate:AnyObject {
    func inputView(_ inputView: CustomAccesoryView,wantsToUploadText text:String)
    func inputView(_ inputView: CustomAccesoryView)
}

class CustomAccesoryView:UIView {
    //MARK: - DATA
    weak var delegate:CustomAccesoryViewDelegate?
    
    //MARK: - PROPERTIES
    private lazy var commentTextView:InputTextView = {
        let tv = InputTextView()
        tv.isScrollEnabled = false
        tv.font = .flower
        tv.delegate = self
        return tv
    }()
    private let emojiButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(handleEmojiButton), for: .touchUpInside)
        return button
    }()
    private let sendButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.systemPurple, for: .normal)
        button.titleLabel?.font = .flowerLabelBold
        button.alpha = 0
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        return button
    }()
    private let backgroundTextView:UIView = {
        let effect = UIBlurEffect(style: .systemChromeMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 44 / 2
        view.clipsToBounds = true
        return view
    }()
    private let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private lazy var customAccesoryViewStackView:UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emojiButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        return stack
    }()
    private var layoutConstraintTextView:NSLayoutConstraint?
    private var layoutConstraintBackgroundTextView:NSLayoutConstraint?
    //MARK: - LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(backgroundTextView)
        addSubview(commentTextView)
        addSubview(sendButton)
        addSubview(customAccesoryViewStackView)
        
        commentTextView.anchor(top: topAnchor,left: leadingAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor,paddingLeft: 19, paddingBottom: 12)
        
        layoutConstraintTextView = commentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19)
        layoutConstraintTextView?.isActive = true
        
        backgroundTextView.anchor(top: commentTextView.topAnchor, left: commentTextView.leadingAnchor, bottom: commentTextView.bottomAnchor, paddingTop: -4.25, paddingLeft: -11, paddingBottom: -4.25)
        
        layoutConstraintBackgroundTextView = backgroundTextView.trailingAnchor.constraint(equalTo: commentTextView.trailingAnchor, constant: 11)
        layoutConstraintBackgroundTextView?.isActive = true
        
        backgroundView.anchor(top: backgroundTextView.topAnchor, left: leadingAnchor, bottom: backgroundTextView.bottomAnchor, right: trailingAnchor,paddingTop: 21,paddingBottom: -UIScreen.main.bounds.height / 2)
        
        sendButton.centerY(inView: backgroundTextView)
        sendButton.anchor(right: backgroundTextView.trailingAnchor,paddingRight: 16)
        
        customAccesoryViewStackView.centerY(inView: backgroundTextView)
        customAccesoryViewStackView.anchor(right: backgroundTextView.trailingAnchor,paddingRight: 13)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidBegin), name: UITextView.textDidBeginEditingNotification, object: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    //MARK: - SELECTORS
    @objc func handleEmojiButton() {
        delegate?.inputView(self, wantsToUploadText: "🌈")
    }
    @objc func handleSendButton() {
        delegate?.inputView(self, wantsToUploadText: commentTextView.text)
    }
    @objc func handleTextDidBegin() {
        delegate?.inputView(self)
    }
    //MARK: - API
    //MARK: - HELPERS
    func clearInputTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
//MARK: - EXTENSIONS
//MARK:-UITextViewDelegate
extension CustomAccesoryView:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let characterSet = CharacterSet.newlines
        
        if text.rangeOfCharacter(from: characterSet) != nil {
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        layoutConstraintTextView?.constant = textView.text.isEmpty ? -19 : -80
        layoutConstraintBackgroundTextView?.constant = textView.text.isEmpty ? 11 : 72
        
        UIView.animate(withDuration: 0.2) {
            self.customAccesoryViewStackView.alpha = textView.text.isEmpty ? 1 : 0
            self.sendButton.alpha = textView.text.isEmpty ? 0 : 1
            self.customAccesoryViewStackView.isHidden = !textView.text.isEmpty
            self.sendButton.isHidden = textView.text.isEmpty
            self.layoutIfNeeded()
        }
    }
}
