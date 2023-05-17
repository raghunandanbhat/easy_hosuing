//
//  ProfileView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject var profile = ProfileViewModel()
    @State var isUserEditing = false
    @State var showProfileImgPicker = false
    
    @State var profileImage: UIImage?
    @State var displayName: String = ""
    @State var userEmail: String = ""
    @State var userPhone: String = ""
    @State var photoURL:  String = ""
    
    var body: some View {
        ZStack{
                VStack{
                    
                    // Button to choose profile image
                    // When clicked, present the image picker
                    // If no image is choosen, default image "person.fill" is shown
                    Button{
                        showProfileImgPicker.toggle()
                    } label: {
                        //Profile image
                        VStack{
                            if let photoURL = profile.usrInfo?.photoURL{
                                WebImage(url: URL(string: photoURL))
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                    .shadow(radius: 10)
                                    .padding(20)
                            } else{
                                
                                if let image = self.profileImage{
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        .shadow(radius: 10)
                                        .padding(20)
                                }else{
                                    Image("user")
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        .shadow(radius: 10)
                                        .padding(20)
                                }
                            }
                        }
                    }
                    
                    
                    //User profile information Here
                    VStack{
                        // Display name
                        HStack{
                            Text("Name:")
                                
                            if !isUserEditing{
                                if(self.displayName.count != 0){
                                    Text(self.displayName)
                                        
                                } else {
                                    Text(profile.user?.displayName ?? "Add/Edit Name")
                                        
                                }
                            } else {
                                TextField("", text: $displayName, prompt: Text("Enter a name"))
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.words)
                            }
                            
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                        )
                        
                        //User ID or uid
                        HStack{
                            Text("User ID:")
                            
                            Text(profile.user?.uid ?? "")
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                        )
                        
                        // Email
                        HStack{
                            Text("Email:")
                            
                            Text(profile.user?.email ?? "email@example.com")
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                        )
                        
                        // Email Verified
                        HStack{
                            Text("Email Verification:")
                            
                            Text((profile.user?.isEmailVerified ?? false) ? "Verified" : "Not Verified")
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                        )
                    }
                    
                    //Save changes button
                    Button {
                        // call chnageRequest here
                        if !isUserEditing{
                            isUserEditing.toggle()
                        } else {
                            isUserEditing.toggle()
                            if(displayName.count != 0){
                                profile.saveDisplayNameChanges(name: displayName)
                            }
                        }
                    } label: {
                        
                        HStack{
                            Spacer()
                            
                            Text(isUserEditing ? "Save Changes" : "Edit Profile")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.vertical)
                            
                            Spacer()
                        }
                    }
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding()

                    Spacer()
                    
                    // Sign out
                    Button {
                        let firebaseAuth = FirebaseManager.shared.auth
                        do{
                            try firebaseAuth.signOut()
                            
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }label: {
                        HStack{
                            Spacer()
                            
                            Text("Sign Out")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.vertical)
                            
                            Spacer()
                        }
                        
                    }
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding()
                }
            }
            .fullScreenCover(isPresented: $showProfileImgPicker, onDismiss: {
                profile.persistProfileImage(self.profileImage ?? UIImage(imageLiteralResourceName: "user"))
            }){
                ImagePicker(image: $profileImage)
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
