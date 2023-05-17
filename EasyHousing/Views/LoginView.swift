//
//  LoginView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var isLoginMode = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var loginStatusMessage: String = ""
    @State private var showErrorAlert = false
    
    @State var image: UIImage?
    @State var showImagePicker = false
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                VStack(spacing: 16){
                    // Picker to pick login/ signup
                    Picker(selection: $isLoginMode, label: Text("Picker")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                    .pickerStyle(.segmented)
                    
                    if !isLoginMode {
                        //Image picker to select a profile image while creating account
                        Button{
                            self.showImagePicker.toggle()
                        } label: {
                            VStack{
                                if let image = self.image{
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else{
                                    Image("user")
                                        .resizable()
                                        .frame(width: 128, height: 128)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                        .shadow(radius: 5)
                                        .padding()
                                }
                            }

                        }
                    }
                    
                    Group{
                        //Email
                        // Validated with isValidEmail()
                        HStack{
                            Image(systemName: "mail")
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                            
                            Spacer()
                            
                            if (email.count != 0){
                                Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                                    .foregroundColor(email.isValidEmail() ? .green : .red)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        
                        //Password
                        // minimum 6 characters, 1 upper, 1 special char
                        // Validated with isValidPassword()
                        HStack{
                            Image(systemName: "lock")
                            SecureField("Password", text: $password)
                                .autocorrectionDisabled(true)
                                .autocapitalization(.none)
                            
                            Spacer()
                            
                            if(password.count != 0){
                                Image(systemName: password.isValidPassword(password) ? "checkmark" : "xmark")
                                    .fontWeight(.bold)
                                    .foregroundColor(password.isValidPassword(password) ? .green : .red)
                            }
                        }
                        
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    
                    //Login/Signup button
                    Button{
                        if isLoginMode{
                            //call firebase login
                            FirebaseManager.shared.auth.signIn(withEmail: email, password: password){ result, error in
                                if let error = error{
                                    print("Failed to login, \(error)")
                                    self.loginStatusMessage = error.localizedDescription
                                    self.showErrorAlert = true
                                    return
                                }
                                
                                if let result = result{
                                    print("Logged in with user id: \(result.user.uid)")
                                    self.loginStatusMessage = "Logged in with user id: \(result.user.uid)"
                                }
                            }
                        } else {
                            //call firebase sign to create a new account
                            FirebaseManager.shared.auth.createUser(withEmail: email, password: password){ result, error in
                                if let error = error {
                                    print("Failed to create account, \(error)")
                                    self.loginStatusMessage = error.localizedDescription
                                    self.showErrorAlert = true
                                    return
                                }
                                
                                if let result = result{
                                    print("Account created successfully with user id \(result.user.uid)")
                                    self.loginStatusMessage = "Account created successfully with user id \(result.user.uid)"
                                    
                                    print("Saving user info")
                                    loginViewModel.saveUser(email: email, uid: result.user.uid, profileImage: self.image)
                                }
                            }
                        }
                    } label: {
                        HStack{
                            Spacer()
                            
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.vertical)
                            
                            Spacer()
                        }
                        .background(Color.green)
                        .cornerRadius(8)
                        
                    }
                    .alert(isPresented: $showErrorAlert){
                        Alert(title: Text("Error"), message: Text(self.loginStatusMessage), dismissButton: .default(Text("Close")))
                    }
                }
                .padding()
                
                
            }
            .navigationTitle(isLoginMode ? "Login": "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
            
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


