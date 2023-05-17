//
//  AuthViewModel.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    
    var user: User? {
           didSet {
               objectWillChange.send()
           }
       }
       
   func listenToAuthState() {
       FirebaseManager.shared.auth.addStateDidChangeListener { [weak self] _, user in
           guard let self = self else {
               return
           }
           self.user = user
       }
   }
}
