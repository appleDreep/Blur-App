//
//  AuthViewModel.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import UIKit

// the AuthenticationViewModel used to model the authentication controllers.

protocol FormViewModel {
    func updateForm()
}
protocol AuthenticationViewModel {
    var formIsValid:Bool { get }
    var buttonBackgroundColor:UIColor { get }
}
struct AuthenticationButtonViewModel: AuthenticationViewModel {
    var text:String?
    
    var formIsValid:Bool {
        return text?.isEmpty == false
    }
    var buttonBackgroundColor:UIColor {
        return formIsValid ? UIColor.secondarySystemBackground : UIColor.secondarySystemBackground.withAlphaComponent(0.5)
    }
}
