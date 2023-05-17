//
//  ProfileViewModel.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import Foundation
import FirebaseAuth
import UIKit

class ProfileViewModel: ObservableObject{
    @Published var user: User?
    @Published var usrInfo: UserModel?
    
    init(){
        self.user = FirebaseManager.shared.auth.currentUser
        
        fetchUserInfo()
    }
    
    // Fetch user information from Firestore database, includes uid, image url and email
    private func fetchUserInfo() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error{
                print("Failed to fetch used info for user: \(uid), \(error)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found in Firestore for User: \(uid)")
                return
            }
            
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImgUrl = data["profileImageUrl"] as? String ?? ""
            
            self.usrInfo = UserModel(uid: uid, email: email, photoURL: profileImgUrl)
        }
    }
    
    // store image in Firebase storage
    func persistProfileImage(_ image: UIImage) {
        guard let uid = self.user?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData){ metadta, error in
            if let error = error{
                print("Failed to save profile image to Storage: \(error)")
                return
            }
            ref.downloadURL { url, error in
                if let error = error{
                    print("Failed to retrieve profile photo URL from Storage: \(error)")
                    return
                }
                
                //success
                let changeRquest = FirebaseManager.shared.auth.currentUser?.createProfileChangeRequest()
                changeRquest?.photoURL = url
                changeRquest?.commitChanges{ error in
                    if let error = error{
                        print("Failed to set currentUsre.photoURL for current user: \(error)")
                        return
                    }
                    print("Success, currentUser.photoURL updated with URL: \(String(describing: url))")
                }
                guard let url = url else { return }
                
                print("Trying to save user info to Firestore Database...")
                self.saveUserInfo(url)
            }
        }
    }
    
    // Save user info to Firestore. user id, email, image URL saved/ updated here
    func saveUserInfo(_ imageURL: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { userinfo, error in
            if let error = error{
                print("Failed to retrive data: \(error)")
                return
            }
            
            guard let userInfoExists = userinfo?.exists else {
                print("User does not exist...")
                return
            }
            
            if (userInfoExists){
                //User info exists
                // Update the URL
                print("User already exists, updating profile photot URL")
                FirebaseManager.shared.firestore.collection("users").document(uid).updateData(["profileImageUrl": imageURL.absoluteString]){ error in
                    if let error = error{
                        print("Failed to update profile URL for user : \(uid), Error: \(error)")
                        return
                    }
                    print("Success! Updated profile photo URL for user id: \(uid)")
                }
            } else {
                // New user / user info does not exist
                // Create new documnet in firestore
                
                let userInfo = ["email": email, "uid": uid, "profileImageUrl": imageURL.absoluteString]
                
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
    
    // Save changes in display name
    func saveDisplayNameChanges(name displayName: String){
        let changeRquest = FirebaseManager.shared.auth.currentUser?.createProfileChangeRequest()
        
        changeRquest?.displayName = displayName
        changeRquest?.commitChanges{ error in
            if let error = error {
                print("Failed to update display name: \(error)")
                return
            }
            print("Display Name updated successfully")
        }
    }
}
