//
//  Utilities.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// utilities for use in the application or reuse of code.

class Utilities {
    func createTextFieldView(textField:UITextField,title:String? = nil,height:CGFloat? = nil,cornerRadius:CGFloat? = nil,color:UIColor? = nil) -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        
        if let color = color {
            view.backgroundColor = color
        }else {
            let effect = UIBlurEffect(style: .systemChromeMaterial)
            let effectView = UIVisualEffectView(effect: effect)
            
            view.addSubview(effectView)
            effectView.fillSuperview()
        }
        if let height = height,let cornerRadius = cornerRadius{
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            view.layer.cornerRadius = cornerRadius / 2
            
        }else {
            view.heightAnchor.constraint(equalToConstant: 44).isActive = true
            view.layer.cornerRadius = 44 / 2
        }
        view.addSubview(textField)
        textField.centerY(inView: view)
        textField.anchor(left:view.leadingAnchor,right: view.trailingAnchor, paddingLeft: 15,paddingRight: 15)
        textField.textColor = .label
        
        if let title = title {
            textField.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor:UIColor.placeholderText,NSAttributedString.Key.font: UIFont.flower])
        }
        return view
    }
    func attributedButton(part1:String,part2:String,color1:UIColor,color2:UIColor) -> UIButton{
        let button = UIButton(type: .system)
        let attributed = NSMutableAttributedString(string: "\(part1) ", attributes: [NSAttributedString.Key.foregroundColor:color1,NSAttributedString.Key.font: UIFont.flowerSystemBold])
        attributed.append(NSAttributedString(string: part2, attributes: [NSAttributedString.Key.foregroundColor:color2,NSAttributedString.Key.font:UIFont.flowerSystemHeavy]))
        button.setAttributedTitle(attributed, for: .normal)
        return button
    }
}
