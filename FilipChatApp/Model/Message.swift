//
//  Message.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-19.
//

import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

// New struct for messages
struct Message: Identifiable, Decodable {
    // Use the @DocumentID property wrapper to mark the "id" variable as the document ID in Firestore
    @DocumentID var id: String?
    let fromId: String
    let toId: String
    let read: Bool
    let text: String
    let timestamp: Timestamp

    //A user so we can handle who we send and receive from
    var user: User?
    
     // Define a new initializer that takes a "CDMessage" object as input
    init(cdMessage: CDMessage) {
        self.id = cdMessage.messageId
        self.text = cdMessage.text ?? ""
        self.fromId = cdMessage.fromId ?? ""
        self.toId = cdMessage.toId ?? ""
        self.timestamp = Timestamp(date: cdMessage.timestamp ?? Date())
        self.read = cdMessage.read
      
    }
    
    
}


let MOCK_USER = User(fullname: "Filip Hertzman", email: "filip.hertzman@gmail.com")
