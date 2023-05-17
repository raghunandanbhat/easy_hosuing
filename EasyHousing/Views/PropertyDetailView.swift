//
//  PropertyDetailView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PropertyDetailView: View {
    var propertyDetails: [String: Any]
    var documentId: String
    
    @State private var showContactSheet = false
    @State private var showPredictionSheet = false
    
    // For prediction model
    @State private var beds: Int = 0
    @State private var baths: Int = 0
    @State private var livingArea: Double = 0.0
    @State private var hasAmenities: String = ""
    @State private var houseTyep: String = ""
    @State private var petFriendly: String = ""
    @State private var listedPrice: Double = 0.0
    
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
                                    .font(.title3)
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
                
                // Contact Details
                VStack{
                    Button{
                        self.showContactSheet = true
                    } label: {
                        HStack{
                            Spacer()
                            Text("Contact")
                                .foregroundColor(Color.white)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.vertical)
                            Spacer()
                        }
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
                .sheet(isPresented: $showContactSheet) {
                    self.showContactSheet = false
                } content: {
                    ContactSheetView(email: String(describing: propertyDetails["email"] ?? "email@email.com"))
                }
                
                //Price predictor
                if(propertyDetails["listType"] as! String != "Rent"){
                    VStack{
                        Button{
                            self.showPredictionSheet = true
                            
                        } label: {
                            HStack{
                                Spacer()
                                Text("Recommendation")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(Color.purple)
                            .cornerRadius(8)
                        }
                    }
                    .sheet(isPresented: $showPredictionSheet) {
                        self.showPredictionSheet = false
                    } content: {
                        RecommendationView(details: propertyDetails)
                    }
                } else {
                    EmptyView()
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
    }
}

struct PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(propertyDetails: [:], documentId: "abcs")
    }
}
