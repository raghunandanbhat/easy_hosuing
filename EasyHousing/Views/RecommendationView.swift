//
//  RecommendationVIew.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/5/23.
//

import SwiftUI
import CoreML

struct RecommendationView: View {
    
    var details: [String: Any]
    
    var body: some View {
        VStack(spacing: 10){
            // property details
            HStack{
                Spacer()
                
                VStack(alignment: .center, spacing: 5){
                    Text("Property Details")
                        .bold()
                        .font(.title)
                    
                    HStack{
                        Text("Number of Beds: ")
                            .bold()
                            .font(.title3)
                        
                        Text("\(String(describing: details["beds"] ?? 0))")
                            .font(.title3)
                    }
                    
                    HStack{
                        Text("Number of Bathrooms: ")
                            .bold()
                            .font(.title3)
                        
                        Text("\(String(describing: details["baths"] ?? 0))")
                            .font(.title3)
                    }
                    
                    HStack{
                        Text("Living Area: ")
                            .bold()
                            .font(.title3)
                        
                        Text("\(String(describing: details["livingArea"] ?? 0.0))")
                            .font(.title3)
                        Text("sqft")
                            .font(.title3)
                    }
                    
                    HStack{
                        Text("House Type: ")
                            .bold()
                            .font(.title3)
                        
                        Text("\(String(describing: details["hometype"] ?? "Condo"))")
                            .font(.title3)
                    }
                    
                    HStack{
                        Text("Pet Friendly")
                            .bold()
                            .font(.title3)
                        
                        if(details["isPetFriendly"] as! Bool){
                            Text("Yes")
                                .font(.title3)
                        } else{
                            Text("No")
                                .font(.title3)
                        }
                    }
                    
                    HStack{
                        Text("Listing Price:")
                            .bold()
                            .font(.title3)
                        
                        Text("\(String(describing: details["price"] ?? 0.0 ))")
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            
            // Our recommended price
            HStack{
                Spacer()
                
                VStack{
                    HStack{
                        Text("\(predictPrice())")
                            .bold()
                            .font(.title2)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        
    }
    
    private func predictPrice() -> String {
        
        
        //Model input params
        var beds_count: Int
        var baths_count: Int
        var living_Area: Int
        var has_Amenities: Int
        var house_Type: Int
        var pet_Friendly: Int
        var listed_Price: Int
        
        //prepare model params
        //beds
        if let beds = details["beds"] as? Int {
            beds_count = beds
        } else{
            beds_count = 0
        }
        
        //baths
        if let baths = details["baths"] as? Int {
            baths_count = baths
        } else{
            baths_count = 0
        }
        
        //area
        if let livingArea = details["livingArea"] as? Double{
            living_Area = Int(livingArea)
        } else {
            living_Area =  0
        }
        
        //amenities
        if let amenities = details["amenities"] as? [String]{
            if amenities.count > 0{
                has_Amenities = 1
            } else {
                has_Amenities = 0
            }
        } else {
            has_Amenities = 1
        }
        
        // pet friendly
        if let petFriend = details["isPetFriendly"] as? Bool{
            if petFriend{
                pet_Friendly = 1
            } else {
                pet_Friendly = 0
            }
        } else{
            pet_Friendly = 1
        }
        
        // house type
        if let houseType = details["hometype"] as? String{
            if houseType == "Condo"{
                house_Type = 1
            } else if(houseType == "Cooperative"){
                house_Type = 2
            } else if(houseType == "MobileManufactured"){
                house_Type = 3
            } else if(houseType == "MultiFamily"){
                house_Type = 4
            } else if(houseType == "SingleFamily"){
                house_Type = 5
            } else {
                house_Type = 6
            }
            
        } else {
            house_Type =  1
        }
        
        // price
        if let price = details["price"] as? Double{
            listed_Price = Int(price)
        } else {
            listed_Price =  0
        }
        
        //ML
        guard let model = try? price_prediction_model(configuration: MLModelConfiguration()) else {
            fatalError("Failed to load model")
        }
        
        guard let inputFeatues = convertIntArrayToMLMultiArray(intArray: [beds_count, baths_count, living_Area, has_Amenities, pet_Friendly, house_Type]) else { return "Insufficient Data" }
        
        guard let prediction = try? model.prediction(input: inputFeatues) else {
            fatalError("Failed to make prediction")
        }

        // Get the predicted price
        print(Int(abs(prediction.prediction)))
        if (listed_Price > Int(abs(prediction.prediction))){
            return "Over priced"
        } else {
            return "Worth Buying"
        }

    }
    
    func convertIntArrayToMLMultiArray(intArray: [Int]) -> MLMultiArray? {
        guard let multiArray = try? MLMultiArray(shape: [intArray.count as NSNumber], dataType: .double) else {
            return nil
        }
        
        for (index, element) in intArray.enumerated() {
            try? multiArray[index] = NSNumber(value: element)
        }
        
        return multiArray
    }
    
}

struct RecommendationVIew_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView(details: [:])
    }
}

