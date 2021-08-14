//
//  AuthService.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase
import FacebookLogin

struct AuthService {
    
    //MARK: - checkIfUserIsRegistered
    
    // create a bool value checking if the current user document exists in the users collection and firebase database.
    
    static func checkIfUserIsRegistered(completion:@escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let registered = snapshot?.exists else {return}
            completion(registered)
        }
    }
    
    //MARK: - authenticationFacebook
    
    // use facebook authentication services to obtain a valid access token and register it and work with firebase authentication asking for a credential,
    // after giving a result use the checkIfUserIsRegistered function to ensure the registration of the user in the firebase database.
    
    static func authenticationFacebook(controller: UIViewController,completion:@escaping(Bool) -> Void) {
        let logInManagerFacebook = LoginManager()
        logInManagerFacebook.logOut()
        logInManagerFacebook.logIn(permissions: [.email], viewController: controller) { (result) in
            
            switch result {
            
            case .success(granted: _, declined: _, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    checkIfUserIsRegistered(completion: completion)
                }
            case .cancelled:
                controller.showLoader(false)
                break
            case .failed(_):
                break
            }
        }
    }
    
    //MARK: - registerUser
    
    // register user using date of birth and username in firebase database.
    
    static func registerUser(username:String,completion:@escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let data:[String:Any] = ["uid":uid,"username":username,"date":Timestamp(date: Date())]
        
        COLLECTION_USERS.document(uid).setData(data, completion: completion)
    }
}
