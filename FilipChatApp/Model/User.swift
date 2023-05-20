//
//  User.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-19.
//

import FirebaseFirestoreSwift


struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let fullname: String
    let email: String
}
