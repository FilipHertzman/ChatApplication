//
//  NewMessageViewModel.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import Firebase
import FirebaseFirestore
import SwiftUI

class NewMessageViewModel: ObservableObject {
    
    // An array of User objects, which is published so that changes to it can be observed
    @Published var users = [User]()

    init() {
        // Call the fetchUsers() function to fetch the list of users
        fetchUsers()
    }

    func fetchUsers() {
        // Access the Firestore collection named "users"
        COLLECTION_USERS.getDocuments { snapshot, _ in
            // Check if any documents were returned from the collection
            guard let documents = snapshot?.documents else { return }
            
            // Use compactMap to create an array of User objects from the documents
            // If a document cannot be converted to a User object, it is filtered out
            self.users = documents.compactMap({ try? $0.data(as: User.self) })

            // Sort users by name
            self.users.sort { $0.fullname.lowercased() < $1.fullname.lowercased() }

            print("DEBUG NewMessageViewModel S: Users \(self.users)")
        }
    }
}
