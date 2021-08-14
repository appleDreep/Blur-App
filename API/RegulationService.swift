//
//  RegulationService.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

struct RegulationService {
    
    //MARK: -fetchUserViolations
    
    // fetch current user violations
    
    static func fetchUserViolations(completion:@escaping([Violation]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_REGULATION.document(uid).collection("violation").order(by: "timeCreated")
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else {return}
            
            let violations = documents.map({Violation(dictionary: $0.data())})
            completion(violations)
        }
    }
    
    //MARK: -updateUserViolationWarning
    
    // Update the boolean value for the violation and warning controller.
    
    static func updateUserViolationWarning(completion:@escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let data:[String:Any] = ["violation":false]
        
        COLLECTION_USERS.document(uid).updateData(data, completion: completion)
    }
    
    //MARK: -
    
    static func reportUser(user:User,type:ViolationType,completion:@escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_REGULATION.document(user.uid).collection("violation").whereField("type", isEqualTo: type.rawValue).getDocuments { snap, error in
            
            snap?.documents.forEach({ doc in
                if doc.exists {
                    COLLECTION_REGULATION.document(user.uid).collection("report").document(uid).setData([:], completion: completion)
                }
            })
        }
    }
    
    //MARK: - blockUser
    
    static func blockUser(user:User,completion:@escaping(FirestoreCompletion)) {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("blocked-users").document(user.uid).setData([:], completion: completion)
    }
    
    //MARK: - UnblockUser
    
    static func unblockUser(user:User,completion:@escaping(FirestoreCompletion)) {
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_USERS.document(currentUser).collection("blocked-users").document(user.uid).delete(completion: completion)
        
    }
    
    
    //MARK: - checkIfCurrentUserIsBlocked
    
    static func checkIfCurrentUserIsBlocked(user:User,completion:@escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_USERS.document(user.uid).collection("blocked-users").document(currentUid)
        
        query.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let blocked = snapshot?.exists else {return}
            completion(blocked)
        }
    }
    
    //MARK: - checkIfUserIsBlocked
    
    static func checkIfUserIsBlocked(user:User,completion:@escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_USERS.document(currentUid).collection("blocked-users").document(user.uid)
        
        query.getDocument { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let blocked = snapshot?.exists else {return}
            completion(blocked)
        }
    }
}
