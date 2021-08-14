//
//  UserService.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    
    //MARK: - fetchCurrentUser
    
    // download the current user information by adding a listener to return in real time the information when it is updated by the user.
    
    static func fetchCurrentUser(completion:@escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        COLLECTION_USERS.document(uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    //MARK: - fetchUsers
    
    static func fetchUsers(completion:@escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            let users = snapshot.documents.map({User(dictionary: $0.data())})
            completion(users)
        }
    }
    
    //MARK: - fetchUsersWithUid
    
    static func fetchUser(withUid uid:String,completion:@escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    //MARK: - updateUser
    
    // update user information based on the User object that is requested by the function.
    
    static func updateUser(user:User,completion:@escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["username":user.username,"fullname":user.fullname]
        COLLECTION_USERS.document(uid).updateData(data, completion: completion)
    }
    
    //MARK: - uploadProfileImage
    
    // first upload current user profile photo to firebase database and firebase storage using ImageUploader function.
    
    static func uploadProfileImage(image:UIImage,completion:@escaping(String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let meta = StorageMetadata()
        meta.customMetadata = ["currentUid":uid]
        
        ImageUploader.imageUploader(image: image, metaData: meta) { (url) in
            let data = ["profileImageUrl":url]
            
            COLLECTION_USERS.document(uid).updateData(data) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion(url)
            }
        }
    }
    
    //MARK: - updateProfileImage
    
    // update the profile picture of the current user first by removing the previous reference of his profile picture in the firebase storage,
    // using the ImageUploader function and the User object which is requested by the function
    
    static func updateProfileImage(forUser user:User,image:UIImage,completion:@escaping(String?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Storage.storage().reference(forURL: user.profileImageUrl).delete(completion: nil)
        
        let meta = StorageMetadata()
        meta.customMetadata = ["currentUid":uid]
        
        ImageUploader.imageUploader(image: image, metaData: meta) { (url) in
            let data = ["profileImageUrl":url]
            
            COLLECTION_USERS.document(uid).updateData(data) { (error) in
                completion(url,error)
            }
        }
    }
}
