//
//  ConversationViewModel.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import Foundation

class ConversationViewModel: ObservableObject {
    
    // Published property to store the recent messages for the user
    @Published var recentMessages = [Message]()
    
    // Initializer for the view model that fetches the recent messages for the user
    init() {
        fetchRecentMessages()
        
    }
    
    // Fetches the recent messages for the user from Firestore
    func fetchRecentMessages() {
        // Get the user's ID from the authentication session
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        // Firestore query to get the recent messages for the user, ordered by timestamp
        let query = COLLECTION_MESSAGES.document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        // Listener to the query to receive updates whenever the data changes
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG ConversationViewModel: Failed to fetch recent messages with error: \(error.localizedDescription)")
                return
            }
            // If the snapshot is not nil, get the documents and decode them into Message objects
            guard let documents = snapshot?.documents else { return }
            self.recentMessages = documents.compactMap({ try? $0.data(as: Message.self) })
        }
    }
    
    
   
    
}
