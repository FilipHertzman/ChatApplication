//
//  ConversationCellViewModel.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import SwiftUI

// This class is used to manage the data and state for a single conversation cell in a list
class ConversationCellViewModel: ObservableObject {
    
    // Published property to store the message for this cell
    @Published var message: Message
    
    // Initializer for the view model that sets the message and fetches the user data
    init(_ message: Message) {
        self.message = message
        fetchUser()
      
    }

    // Computed property to get the ID of the chat partner for this message
    var chatPartnerId: String {
        return message.fromId == AuthViewModel.shared.userSession?.uid ? message.toId : message.fromId
    }
    
    // Computed property to get the full name of the user associated with this message
    var fullname: String {
        guard let user = message.user else { return "" }
        return user.fullname
    }
    
    
    // Fetches the user object for the chat partner associated with this message
    func fetchUser() {
        // Get a reference to the chat partner's document in the users collection
        COLLECTION_USERS.document(chatPartnerId).getDocument { snapshot, _ in
            // If the fetch was successful, try to decode the user data and store it in the message object
            self.message.user = try? snapshot?.data(as: User.self)
            
        }
        
    }
    
}
