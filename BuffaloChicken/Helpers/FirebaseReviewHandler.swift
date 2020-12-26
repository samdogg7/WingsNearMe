//
//  FirebaseReviewHandler.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 12/14/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import FirebaseDatabase
import CodableFirebase
import FirebaseAuth

class FirebaseReviewHandler: NSObject {
    static private let databaseRef = Database.database().reference()
    
    static func addRestaurantReview(placeId: String, userReview: UserReview) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        if let userDict = userReview.toDictionary {
            databaseRef.child(placeId).child(user.uid).setValue(userDict, withCompletionBlock: { err, ref in
                if let error = err {
                    print("Review was not saved. Error: \(error.localizedDescription)")
                } else {
                    print("Review [by: \(user.uid)] saved successfully!")
                }
            })
        } else {
            print("Failed to encode user review. Function: \(#function)")
        }
    }
    
    static func getRestaurant(placeId: String, completion: @escaping (RestaurantReviews) -> Void) {
        databaseRef.child(placeId).observeSingleEvent(of: .value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                }
            }
            
            if let value = snapshot.value, let decodedReview = try? FirebaseDecoder().decode(RestaurantReviews.self, from: value) {
                completion(decodedReview)
            } else {
                completion(RestaurantReviews())
            }
        })
    }
}
