//
//  InputTextView.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the InputTextView added to the main text container.

class InputTextView:UITextView {
    //MARK: - DATA
    //MARK: - PROPERTIES
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Message..."
        label.textColor = .secondaryLabel
        label.font = .flower
        return label
    }()
    //MARK: - LIFECYCLE
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
 
        backgroundColor = .clear
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: leadingAnchor,paddingLeft: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SELECTORS
    @objc func handleTextDidChange() {
        checkMaxLenght(textView: self)
        placeholderLabel.isHidden = !text.isEmpty
    }
    //MARK: - API
    //MARK: - HELPERS
    func checkMaxLenght(textView:UITextView) {
        if textView.text.count > 350 {
            self.deleteBackward()
        }
    }
}
//MARK: - EXTENSIONS
