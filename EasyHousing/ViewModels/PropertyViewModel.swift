//
//  PropertyViewModel.swift
//  EasyHousing
//
//  Created by Raghunandan Bhat on 5/3/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import UIKit

class PropertyViewModel: ObservableObject {
    @Published var properties: [DocumentSnapshot] = []
    @Published var allProperties: [DocumentSnapshot] = []
    
    private var imageURL: String = ""
    
    // Save property image in Storage and get a url
    func savePhoto(_ image: UIImage) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData){ metadata, error in
            if let error = error {
                print("Failed to save property image in Storage: \(error)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to get photo url of stored image, \(error)")
                    return
                }
                
                //URL retrival successful
                guard let url = url else { return }
                self.imageURL = url.absoluteString
            }
        }
    }
    
    func savePropertyInfo(address: Address, features: Features, listType: String, price: Double, completion: @escaping (Bool) -> ()){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let email = FirebaseManager.shared.auth.currentUser?.email else { return }
        
        //let property = PropertyModel(pid: UUID(), address: address, list_type: listType, features: features, photosURL: self.imageURL)
        
        let propertyToSave = [
            "email": email,
            "uid": uid,
            "streetAddress": address.street_address,
            "city": address.city,
            "state": address.state,
            "zipcode": address.zipcode,
            "listType": listType,
            "price": price,
            "beds": features.beds,
            "baths": features.baths,
            "livingArea": features.livingArea,
            "hometype": features.hometype,
            "isPetFriendly": features.isPetFriendly,
            "amenities": features.amenities ?? [],
            "photoUrl": self.imageURL
        ] as [String : Any]
        
        //Save to Firestore - properties
        FirebaseManager.shared.firestore.collection("properties").addDocument(data: propertyToSave){ error in
            if let error = error {
                print("Failed to save property info, \(error)")
                completion(false)
                return
            }
            
            //Success
            print("New property added successfully...")
            completion(true)
        }
        
//        // Save to all_properties
//        let property = [
//            "email": email,
//            "streetAddress": address.street_address,
//            "city": address.city,
//            "state": address.state,
//            "zipcode": address.zipcode,
//            "listType": listType,
//            "price": price,
//            "beds": features.beds,
//            "baths": features.baths,
//            "isPetFriendly": features.isPetFriendly,
//            "amenities": features.amenities ?? [],
//            "photoUrl": self.imageURL
//        ] as [String : Any]
//
//        // Save to Firestore - all_properties
//        FirebaseManager.shared.firestore.collection("all_properties").addDocument(data: property){ error in
//            if let error = error {
//                print("Failed to save property info, \(error)")
//                completion(false)
//                return
//            }
//
//            //Success
//            print("New property added successfully...")
//            completion(true)
//        }
    }
    
    func fetchUserListedProperties(for userId: String){
        let fetchQuery = FirebaseManager.shared.firestore.collection("properties").whereField("uid", isEqualTo: userId)
        
        fetchQuery.getDocuments { results, error in
            if let error = error{
                print("Failed to fetch properties listed by user, \(error)")
                return
            } else {
//                print("Fetching properties...")
//                print("fecthed \(String(describing: results?.documents.count)) properties...")
                self.properties = results?.documents ?? []
            }
        }
    }
    
    // Remove a property listed by user
    func deleteProperty(for user: String, documentId: String){
        FirebaseManager.shared.firestore.collection("properties").document(documentId).delete(){ error in
            if let error = error {
                print("Failed to remove property, \(error)")
                return
            }
            
            //Success
            print("Property de-listed successfully")
            
            //Refresh
            self.fetchUserListedProperties(for: user)
            self.fetchAllProperties()
        }
    }
    
    // fetch all properties
    func fetchAllProperties(){
        FirebaseManager.shared.firestore.collection("properties").getDocuments { dataSnapshot, error in
            if let error = error {
                print("Failed to get documents, \(error)")
                return
            } else {
                self.allProperties = dataSnapshot?.documents ?? []
            }
            
        }
    }
}
