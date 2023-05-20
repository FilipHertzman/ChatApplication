//
//  MessageViewModel.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import Foundation

struct MessageViewModel{
    
    // Property to store the message for this view model
    let message: Message
    
    // Initializer for the view model that sets the message
    init(_ message: Message) {
        self.message = message
      
    }
    
    // Computed property to get the ID of the current user
    var currentUid: String {
        return AuthViewModel.shared.userSession?.uid ?? ""
    }
    
    // Computed property to determine whether the message was sent by the current user
    var isFromCurrentUser: Bool {
        return message.fromId == currentUid
    }
    
   
    
}
