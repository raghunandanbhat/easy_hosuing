//
//  PropertyListView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import SwiftUI

struct PropertyListView: View {
    
    @StateObject private var propertyViewModel = PropertyViewModel()
    
    var body: some View {
        ZStack{
            VStack{
                NavigationView{
                    VStack{
                        if(propertyViewModel.allProperties.count > 0){
                            
                                List(propertyViewModel.allProperties, id: \.self){ property in
                                    NavigationLink(destination: PropertyDetailView(propertyDetails: property.data() ?? [:], documentId: property.documentID)){
                                        PropertyCellView(properties: property.data() ?? [:], documentId: property.documentID)
                                    }
                                }
                                .listStyle(PlainListStyle())
                            
                        } else {
                            VStack{
                                Text("No Listed properties")
                            }
                        }
                    }
                    .navigationTitle("All Properties")
                }
                .onAppear{
                    propertyViewModel.fetchAllProperties()
                }
            }
        }
    }
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyListView()
    }
}
