//
//  UserPropertyDetailView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserPropertyDetailView: View {
    
    var propertyDetails: [String: Any]
    var documentId: String
    
    @State private var showDeleteAlert = false
    @StateObject private var propertyVM = PropertyViewModel()
    
    var body: some View {
        ScrollView{
            VStack{
                Spacer()
                // Address
                VStack{
                    HStack{
                        Spacer()
                        
                        VStack{
                            Text("\(String(describing: propertyDetails["streetAddress"] ?? "Street Address"))")
                                .bold()
                                .font(.title)
                            
                            HStack{
                                Text("\(String(describing: propertyDetails["city"] ?? "City")),")
                                    .bold()
                                    .font(.title2)
                                
                                Text("\(String(describing: propertyDetails["state"] ?? "__"))")
                                    .bold()
                                    .font(.title2)
                            }
                            
                            Text("\(String(describing: propertyDetails["zipcode"] ?? ""))")
                                .bold()
                                .font(.title2)
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                // Images
                ScrollView(.horizontal){
                    if let imgUrl = propertyDetails["photoUrl"] {
                        if(imgUrl as! String == ""){
                            Image("home")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(7)
                        } else {
                            WebImage(url: URL(string: imgUrl as! String))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(7)
                        }
                        
                    } else{
                        Image("home")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(7)
                    }
                }
                
                // Property details
                VStack(alignment: .center, spacing: 5){
                    HStack{
                        Spacer()
                        VStack(alignment: .center, spacing: 5){
                            // Area
                            HStack(spacing: 10){
                                Text("Living Area:")
                                    .bold()
                                    .font(.title3)
                                Text("\(String(describing: propertyDetails["livingArea"] ?? 0)) sqft")
                                    .font(.title3)
                            }
                            
                            HStack{
                                Text("Home Type:")
                                    .bold()
                                    .font(.title3)
                                
                                Text("\(String(describing: propertyDetails["hometype"] ?? "House"))")
                            }
                            
                            // Type and price
                            VStack{
                                if(propertyDetails["listType"] as! String == "Rent"){
                                    HStack{
                                        Text("For:")
                                            .bold()
                                            .font(.title3)
                                        
                                        Text("\(String(describing: propertyDetails["listType"] ?? "N/A"))")
                                            .font(.title3)
                                    }
                                    
                                    HStack{
                                        Text("Price:")
                                            .bold()
                                            .font(.title3)
                                        
                                        Text("$\(String(describing: propertyDetails["price"] ?? 0)) per month")
                                            .font(.title3)
                                    }
                                    
                                } else{
                                    HStack{
                                        Text("For:")
                                            .bold()
                                            .font(.title3)
                                        
                                        Text("Sale")
                                            .font(.title3)
                                    }
                                    
                                    HStack{
                                        Text("Price:")
                                            .bold()
                                            .font(.title3)
                                        
                                        Text("$\(String(describing: propertyDetails["price"] ?? 0))")
                                            .font(.title3)
                                    }
                                }
                                
                            }
                            
                            // Bed & bath
                            HStack{
                                Text("Beds:")
                                    .bold()
                                    .font(.title3)
                                Text("\(String(describing: propertyDetails["beds"] ?? 0))")
                                    .font(.title3)
                            }
                            
                            HStack{
                                Text("Baths:")
                                    .bold()
                                    .font(.title3)
                                Text("\(String(describing: propertyDetails["baths"] ?? 0))")
                                    .font(.title3)
                            }
                            
                            // Pet freindly
                            HStack{
                                Text("Pet Friendly?:")
                                    .bold()
                                    .font(.title3)
                                
                                if(propertyDetails["isPetFriendly"] as! Bool){
                                    Text("Yes")
                                        .font(.title3)
                                } else{
                                    Text("No")
                                        .font(.title3)
                                }
                                
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                // Amenities
                VStack{
                    HStack{
                        Spacer()
                        
                        VStack(alignment: .center){
                            Text("Amenities:")
                                .bold()
                                .font(.title3)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(propertyDetails["amenities"] as! [String], id: \.self){ amenity in
                                        Text(amenity)
                                            .foregroundColor(Color.white)
                                            .bold()
                                            .minimumScaleFactor(0.5)
                                            .frame(width: CGFloat(amenity.count + 75), height: 30, alignment: .center)
                                            .background(Color.blue)
                                            .cornerRadius(7)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                
                VStack{
                    Button{
//                        self.showDeleteAlert = true
                        propertyVM.deleteProperty(for: propertyDetails["uid"] as! String, documentId: documentId)
                    } label: {
                        HStack{
                            Spacer()
                            Text("Remove")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Color.red)
                        .cornerRadius(8)
                    }
//                    .alert(isPresented: $showDeleteAlert) {
//                        Alert(title: Text("Are you sure?"),
//                              message: Text("Remove property listing?"),
//                              primaryButton: .destructive(Text("Delete"), action: {
//                                  // Handle primary button action
//                                  self.showDeleteAlert = false
//                                  propertyVM.deleteProperty(for: propertyDetails["uid"] as! String, documentId: documentId)
//                              }),
//                              secondaryButton: .cancel(Text("Cancel"), action: {
//                                  // Handle secondary button action
//                                  self.showDeleteAlert = false // Add this line to close the alert
//                              }))
//                    }
                }
                
                
                Spacer()
            }
            .padding()
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
    }
}

struct UserPropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserPropertyDetailView(propertyDetails: [:], documentId: "abcs")
    }
}
