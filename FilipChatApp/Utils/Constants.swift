//
//  Constants.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import Foundation
import FirebaseFirestore

// Constant for Firebase Collections
let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
