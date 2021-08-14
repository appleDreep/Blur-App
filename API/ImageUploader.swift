//
//  ImageUploader.swift
//  Blur
//
//  Created by Drep on 13/08/21.
//

import Foundation
import Firebase

struct ImageUploader {
    
    //MARK: - ImageUploader
    
    // upload an image by compressing the quality and placing it in the firebase storage and the firebase database this function returns a url of the uploaded image.
    
    static func imageUploader(image:UIImage,metaData:StorageMetadata,imageUrl:@escaping(String)-> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        ref.putData(imageData, metadata: metaData) { meta, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                imageUrl(profileImageUrl)
            }
        }
    }
}
