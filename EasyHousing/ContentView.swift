//
//  ContentView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    
    var body: some View {
        
        Group{
            if (authModel.user != nil){
                //User login is active
                //Home screen of the App
                HomepageView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authModel.listenToAuthState()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
