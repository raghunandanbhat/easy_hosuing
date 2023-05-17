//
//  LoginViewModel.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import Foundation
import FirebaseAuth
import UIKit


class LoginViewModel: ObservableObject{
    
    func saveUser(email: String, uid: String, profileImage: UIImage?){
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = profileImage?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData){ metadata, error in
            if let error  = error{
                print("Failed to save profile image to Storage, \(error)")
                return
            }
            
            ref.downloadURL{ url, error in
                if let error = error{
                    print("Failed to retrieve URL for image, \(error)")
                    return
                }
                
                // successs
                // update in currentUser
                let updateRequest = FirebaseManager.shared.auth.currentUser?.createProfileChangeRequest()
                
                updateRequest?.photoURL = url
                updateRequest?.commitChanges{ error in
                    if let error = error{
                        print("Failed to set currentUser profile photo, \(error)")
                        return
                    }
                    print("Success, currentUser profile photo URL photo updated...")
                }
                
                guard let url = url else { return }
                
                print("Trying to save user info")
                let userInfo = ["email": email, "uid": uid, "profileImageUrl": url.absoluteString]
                
                FirebaseManager.shared.firestore.collection("users").document(uid).setData(userInfo) { error in
                    if let error = error {
                        print("Failed to save user information: \(error)")
                        return
                    }
                    print("Success! Saved user info in Firestore for user: \(uid)")
                }

            }
        }
    }
}
