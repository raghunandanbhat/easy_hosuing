//
//  UserPropertiesView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import SwiftUI

struct UserPropertiesView: View {
    @State private var propList = [1, 2]
    @State private var showAddPropertyScreen = false
    
    @StateObject private var proertyViewModel = PropertyViewModel()
    
    var body: some View {
        ZStack{
            VStack{
                NavigationView{
                    VStack{
                        if(proertyViewModel.properties.count > 0){
                            List(proertyViewModel.properties, id: \.self){ property in
                                NavigationLink(destination: UserPropertyDetailView(propertyDetails: property.data() ?? [:], documentId: property.documentID)){
                                    UserPropertyCellView(properties: property.data() ?? [:], documentId: property.documentID)
                                }
                            }
                            .listStyle(PlainListStyle())
                        } else{
                            VStack(alignment: .center){
                                Text("No list Properties")
                                Text("Please use the 'Add Properties' button to add")
                            }
                            .padding()
                        }
                        
                        VStack{
                            
                            VStack{
                                Button{
                                    self.showAddPropertyScreen = true
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Add Properties")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 18, weight: .semibold))
                                            .padding(.vertical)
                                        Spacer()
                                    }
                                    .background(Color.green)
                                    .cornerRadius(8)
                                    .fullScreenCover(isPresented: $showAddPropertyScreen) {
                                        AddPropertyView()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Your Properties")
                }
                .onAppear{
                    proertyViewModel.fetchUserListedProperties(for: FirebaseManager.shared.auth.currentUser?.uid ?? "")
                }
                
//                VStack{
//
//                    VStack{
//                        Button{
//                            self.showAddPropertyScreen = true
//                        } label: {
//                            HStack{
//                                Spacer()
//                                Text("Add Properties")
//                                    .foregroundColor(Color.white)
//                                    .font(.system(size: 18, weight: .semibold))
//                                    .padding(.vertical)
//                                Spacer()
//                            }
//                            .background(Color.green)
//                            .cornerRadius(8)
//                            .fullScreenCover(isPresented: $showAddPropertyScreen) {
//                                AddPropertyView()
//                            }
//                        }
//                    }
//                }
//                .padding()
            }
            
        }
        .onReceive(proertyViewModel.$properties, perform: { _ in
            proertyViewModel.fetchUserListedProperties(for: FirebaseManager.shared.auth.currentUser?.uid ?? "")
        })
    }
}

struct UserPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        UserPropertiesView()
    }
}
