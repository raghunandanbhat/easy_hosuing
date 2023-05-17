//
//  EasyHousingApp.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import SwiftUI
import FirebaseCore

@main
struct EasyHousingApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel())
        }
    }
}
