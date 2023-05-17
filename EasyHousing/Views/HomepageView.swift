//
//  HomepageView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import SwiftUI

struct HomepageView: View {
    var body: some View {
        TabView{
            Group{
                
                PropertyListView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("All Properties")
                            .bold()
                    }
                
                UserPropertiesView()
                    .tabItem{
                        Image(systemName: "star")
                        Text("Your Properties")
                            .bold()
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                            .bold()
                    }
            }
        }
    }
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
