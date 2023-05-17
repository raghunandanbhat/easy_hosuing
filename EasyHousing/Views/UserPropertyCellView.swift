//
//  UserPropertyCellView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserPropertyCellView: View {
    var properties: [String: Any]
    var documentId: String
    
    @State private var showDeleteAlert = false
    @StateObject private var propertyViewModel = PropertyViewModel()
    
    var body: some View {
            HStack{
                
                if let imgUrl = properties["photoUrl"] {
                    if(imgUrl as! String == ""){
                        Image("home")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 70)
                            .cornerRadius(7)
                    } else {
                        WebImage(url: URL(string: imgUrl as! String))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 70)
                            .cornerRadius(7)
                    }
                    
                } else{
                    Image("home")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 70)
                        .cornerRadius(7)
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    HStack{
                        Text("\(String(describing: properties["streetAddress"] ?? "Street Address"))")
                        Spacer()
                        Text("\(String(describing: properties["city"] ?? "City"))")
                    }
                    
                    HStack{
                        Text("Living Area: \(String(describing: properties["livingArea"] ?? 0)) sqft")
                        Spacer()
                        Text("\(String(describing: properties["hometype"] ?? "House"))")
                    }
                    
                    HStack{
                        Text("Beds: \(String(describing: properties["beds"] ?? 0))")
                        Spacer()
                        Text("Baths: \(String(describing: properties["baths"] ?? 0))")
                    }
                    
                    HStack{
                        Text("Price")
                        Text("\(String(describing: properties["price"] ?? 0))")
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
    }
}

struct UserPropertyCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserPropertyCellView(properties: [:], documentId: "abcs")
    }
}
