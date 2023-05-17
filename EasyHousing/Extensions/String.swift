//
//  String.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/2/23.
//

import Foundation

extension String {
    //check if a typed email is valid
    func isValidEmail() -> Bool{
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        
        return regex.firstMatch(in: self, range: NSRange(location: 0, length: count)) != nil
    }
    
    // Check if a password is valid
    // minimum 6 characters, 1 upper, 1 special
    func isValidPassword(_ password: String) -> Bool{
        let regexPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return regexPassword.evaluate(with: password)
    }
}

