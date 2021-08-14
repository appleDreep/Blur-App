//
//  Extensions.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit
import JGProgressHUD

// extensions for code reuse.

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leadingAnchor,
               bottom: view.bottomAnchor, right: view.trailingAnchor)
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static let JasColor = UIColor.rgb(red: 0, green: 208, blue: 255)
    static let customPurple = UIColor.rgb(red: 180, green: 81, blue: 203)
    static let customPink = UIColor.rgb(red: 227, green: 101, blue: 144)
    
}
extension Character {
    // A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    // Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

extension UIFont {
    // fonts for emojis
    static let flowerEmoji = UIFont.systemFont(ofSize: 41)
    
    // fonts for large titles
    static let sunFlower = UIFont.systemFont(ofSize: 24,weight: .bold)
    static let sunFlowerSlim = UIFont.systemFont(ofSize: 24)
    
    // fonts for titles
    static let flowerLabel = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    static let flowerLabelBold = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
    static let flowerLabelSuperBold = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .bold)
    static let flowerLabelHeavy = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .heavy)
    
    // fonts for normal labels
    static let flower = UIFont.systemFont(ofSize: 16)
    static let flowerBold = UIFont.boldSystemFont(ofSize: 16)
    static let flowerSuperBold = UIFont.systemFont(ofSize: 16, weight: .bold)
    static let flowerHeavy = UIFont.systemFont(ofSize: 16,weight: .heavy)
    
    // fonts for small labels
    static let flowerSystem = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    static let flowerSystemBold = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    static let flowerSystemSuperBold = UIFont.systemFont(ofSize: UIFont.systemFontSize,weight: .bold)
    static let flowerSystemHeavy = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy)
    
    // fonts for ultra small labels
    static let flowerUltraSmall = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
}
