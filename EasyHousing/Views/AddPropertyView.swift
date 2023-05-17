//
//  AddPropertyView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import SwiftUI

struct AddPropertyView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var propertyViewModel = PropertyViewModel()
    
    let states = ["AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas", "CA": "California", "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware", "FL": "Florida", "GA": "Georgia", "HI": "Hawaii", "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa", "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine", "MD": "Maryland", "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota", "MS": "Mississippi", "MO": "Missouri", "MT": "Montana", "NE": "Nebraska", "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico", "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio", "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island", "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas", "UT": "Utah", "VT": "Vermont", "VA": "Virginia", "WA": "Washington", "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming"]
    
    let roomCounts = [1, 2, 3, 4, 5]
    let petFriendliness = ["Yes", "No"]
    var allAmenities = ["Pool", "Gym", "Laundry", "Bar", "Backyard", "Has AC", "No AC", "Parking", "Garage", "None"]
    let hometypes = ["Condo", "Cooperative", "MobileManufactured","MultiFamily","SingleFamily","Townhome"]
    
    //Address
    @State private var streetAddress: String = ""
    @State private var cityName: String = ""
    @State private var state: String = ""
    @State private var zipcode: String = ""
    
    @State private var isAddrssValid = false
    @State private var showInvalidAddressAlert = false
    
    //Features
    @State private var hometype: String = ""
    @State private var beds: Int = 0
    @State private var baths: Int = 0
    
    @State private var petFriendly = "Yes"
    @State private var isPetFriendly = true
    
    @State private var selectedAmenities: [String] = []
    
    //Photo
    @State private var propertyPhoto: UIImage?
    @State private var showAmenitiesSheet = false
    @State private var showPhotos = false
    
    //Listing Type
    @State private var isRenting = true
    @State private var listType = ""
    
    //Living area
    @State private var area: Double = 0
    
    //Listing price
    @State private var price: Double = 0
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 10){
                    
                    // Address
                    VStack(alignment: .leading){
                        Text("Address")
                            .font(.headline)
                            .bold()
                        Group{
                            //Street address
                            TextField("Street Address", text: $streetAddress)
                            
                            //City
                            TextField("City", text: $cityName)
                                .textInputAutocapitalization(.words)
                            
                            //State
                            HStack{
                                Text("State")
                                Spacer()
                                Picker("State", selection: $state) {
                                    ForEach(Array(states.keys.sorted()), id: \.self) { key in
                                        Text("\(key) - \(states[key]!)")
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            
                            //Pincode
                            TextField("Zipcode", text: $zipcode)
                                .keyboardType(.numberPad)// convert to int before storing
                        }
                        .padding(15)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    
                    //Features
                    VStack(alignment: .leading ){
                        Text("Details")
                            .font(.headline)
                            .bold()
                        
                        Group{
                            //Home type townhomes, house, apartment
                            HStack{
                                Text("Home Type")
                                Spacer()
                                Picker("hometype", selection: $hometype){
                                    ForEach(hometypes, id: \.self){ value in
                                        Text("\(value)")
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            //Living Area in sqft
                            HStack{
                                Text("Living Area")
                                    .bold()
                                    .font(.headline)
                                
                                TextField("Price", value: $area, formatter: formatter)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(15)
                                
                                Text("sq. ft")
                            }
                            
                            
                            HStack{
                                //Beds
                                HStack{
                                    Text("Bed(s)")
                                    Spacer()
                                    Picker("Beds", selection: $beds){
                                        ForEach(roomCounts, id: \.self){ value in
                                            Text("\(value)")
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                                
                                //Baths
                                HStack{
                                    Text("Bath(s)")
                                    Spacer()
                                    Picker("Baths", selection: $baths){
                                        ForEach(roomCounts, id: \.self){ value in
                                            Text("\(value)")
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                            
                            //Pet Friendly
                            HStack{
                                Text("Pet Friendly?")
                                Spacer()
                                Picker("pet_friendly", selection: $petFriendly) {
                                    ForEach(petFriendliness, id: \.self) { key in
                                        Text(key)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                    
                    //Amenities
                    VStack(alignment: .leading){
                        HStack{
                            Text("Amenities")
                                .bold()
                                .font(.headline)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 2){
                                    ForEach(selectedAmenities, id: \.self){ item in
                                        HStack{
                                            Spacer()
                                            Text(item)
                                                .bold()
                                                .frame(width: CGFloat(item.count * 15), height: 30, alignment: .center)
                                                .foregroundColor(Color.white)
                                            Spacer()
                                        }
                                        .background(Color.blue)
                                        .cornerRadius(7)
                                    }
                                }
                            }
                        }
                        
                        
                        Button{
                            showAmenitiesSheet = true
                        } label: {
                            HStack{
                                Spacer()
                                Text("Add Amenities")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(Color.green)
                            .cornerRadius(8)
                            
                        }
                    }
                    .sheet(isPresented: $showAmenitiesSheet) {
                        AmenitiesSelectionView(selectedAmenities: $selectedAmenities, allAmenities: allAmenities) {
                            showAmenitiesSheet = false
                        }
                    }
                    
                    // Add photo
                    VStack(alignment: .leading){
                        Button{
                            showPhotos = true
                        } label: {
                            HStack{
                                Spacer()
                                Text("Add Photo")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(Color.green)
                            .cornerRadius(8)
                        }
                    }
                    .sheet(isPresented: $showPhotos, onDismiss: {
                        // save to db here
                        propertyViewModel.savePhoto(propertyPhoto ?? UIImage(imageLiteralResourceName: "home"))
                    }) {
                        ImagePicker(image: $propertyPhoto)
                    }
                    
                    //Mark it on Map
                    VStack{
                        
                    }
                    
                    //Rent or Sell
                    VStack{
                        Picker("listType", selection: $isRenting) {
                            Text("Rent")
                                .tag(true)
                                .bold()
                                .padding(.vertical)
                            
                            Text("Sell")
                                .tag(false)
                                .bold()
                                .padding(.vertical)
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical)
                    }
                    
                    //Price
                    VStack(alignment: .leading){
                        HStack{
                            Text("Listing Price")
                                .bold()
                                .font(.headline)
                            
                            TextField("Price", value: $price, formatter: formatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(15)
                        }
                    }
                    
                    // Save Button
                    VStack{
                        Button{
                            // Check if address is ok, all fields should be filled
                            if(streetAddress.count != 0 && cityName.count != 0 &&  state.count != 0 && zipcode.count == 5){
                                self.isAddrssValid = true
                            } else { self.isAddrssValid = false}
                            
                            // Address
                            let newAddress = Address(street_address: streetAddress, city: cityName, state: state, zipcode: Int(zipcode) ?? 111222)
                            
                            // Feature
                            if(petFriendly == "Yes"){
                                self.isPetFriendly = true
                            } else {
                                self.isPetFriendly = false
                            }
                            
                            let newFeatures = Features(baths: baths, beds: beds, hometype: hometype, livingArea: area, isPetFriendly: self.isPetFriendly, amenities: self.selectedAmenities)
                            
                            //Listing type
                            if(self.isRenting){
                                self.listType = "Rent"
                            } else {
                                self.listType = "Sell"
                            }
                            
                            if(self.isAddrssValid){
                                // save to DB
                                propertyViewModel.savePropertyInfo(address: newAddress, features: newFeatures, listType: self.listType, price: self.price) { success in
                                    if success {
                                        self.alertTitle = "Success"
                                        self.alertMessage = "Property saved!"
                                        self.showAlert = true
                                    } else {
                                        self.alertTitle = "Error"
                                        self.alertMessage = "Failed to save property"
                                        self.showAlert = true
                                    }
                                }
                                
                            } else {
                                // warning
                                self.alertTitle = "Error"
                                self.alertMessage = "Inavalid address. Please correct and try again"
                                self.showInvalidAddressAlert = true
                                self.showAlert = true
                            }
                            
                        } label: {
                            HStack{
                                Spacer()
                                Text("Save")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.vertical)
                                Spacer()
                            }
                            .background(Color.green)
                            .cornerRadius(8)
                        }
                        .alert(isPresented: $showAlert){
                            Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("Close"), action: {
                                if(!self.showInvalidAddressAlert){
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.showAlert = false
                                }
                            }))
                        }
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Add your Property")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
    }
}

struct AddPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        AddPropertyView()
    }
}
