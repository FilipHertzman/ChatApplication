//
//  FilipChatAppApp.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI
import Firebase

@main
struct FilipChatAppApp: App {
    
    // Configure Firebase
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
                .preferredColorScheme(.dark)
        }
    }
}
