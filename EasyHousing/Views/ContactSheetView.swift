//
//  ContactSheetView.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/5/23.
//

import SwiftUI

struct ContactSheetView: View {
    var email: String
    var body: some View {
        Text("For more information, please contact \(email)")
    }
}

struct ContactSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ContactSheetView(email: "email@email.com")
    }
}
