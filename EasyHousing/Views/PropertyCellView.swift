//
//  PropertyCellView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PropertyCellView: View {
    var properties: [String: Any]
    var documentId: String 
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
            
            
            VStack(alignment: .leading, spacing: 5){
                HStack{
                    Text("\(String(describing: properties["streetAddress"] ?? "Street Address")),")
                        .bold()
                        .font(.headline)
                    
                    Text("\(String(describing: properties["city"] ?? "City")),")
                        .bold()
                        .font(.headline)
                    
                    Text("\(String(describing: properties["state"] ?? "__"))")
                        .bold()
                        .font(.headline)
                }
                
                HStack(spacing: 10){
                    Text("Living Area: \(String(describing: properties["livingArea"] ?? 0)) sqft")
                    
                    Text("\(String(describing: properties["hometype"] ?? "House"))")
                }
                
                HStack(spacing: 20){
                    if(properties["listType"] as! String == "Rent"){
                        Text("For: \(String(describing: properties["listType"] ?? "N/A"))")
                    } else{
                        Text("For: Sale")
                    }
                    Text("Price: $\(String(describing: properties["price"] ?? 0))")
                }
            }
            
        }
    }
}

struct PropertyCellView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyCellView(properties: [:], documentId: "abcs")
    }
}
