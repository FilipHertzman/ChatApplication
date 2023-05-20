//
//  AuthViewModel.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-13.
//

import Firebase
import FirebaseFirestore



class AuthViewModel: ObservableObject {
    
    //Here we use a published property that we store if the user is Authenticated
    // then we navigate to MainTabView
    @Published var didAuthenticateUser = false
    
    //Published property to see if the user is logged in
    @Published var userSession: FirebaseAuth.User?
    
    // single instance of AuthViewModel so we can use it everywhere in the app
    static let shared = AuthViewModel()
    
    // User that we fetch from Firebase with information
    @Published var currentUser: User?
    
    // Published property to store any error messages that occur during authentication
    @Published var errorMessage: String?
    
     init() {
        print("DEBUG AuthViewModel S: Did init")
        // check if I am auth once
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    // Log the user in with their email and password
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // print out if there is an error
            if let error = error {
                print("DEBUG AuthViewModel F: Failed to sign in with error \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }
            // Clear any previous error message
            self.errorMessage = nil
            
            self.userSession = result?.user
            self.fetchUser()
            print("DEBUG AuthViewModel S: Login User \(String(describing: self.userSession))")
        }
       
    }

    // Register the user
    func register(email: String, password: String, fullname: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            // print out if there is an error
            if let error = error {
                print("DEBUG AuthViewModel F: Failed to register with error \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                return
            }

            self.errorMessage = nil

            // Send data from the user to firestore
            guard let user = result?.user else { return }

            let data: [String: Any] = ["email": email,
                                       "fullname": fullname]

           COLLECTION_USERS.document(user.uid).setData(data) { _ in
                print("DEBUG AuthViewModel S: Updated user info in firestore")
               self.userSession = result?.user
               self.fetchUser()
                self.didAuthenticateUser = true
            }
        }
    }
    
    

    func signout() {
        //sign out in the frontend
        self.userSession = nil
        //sign out in the backend
        try? Auth.auth().signOut()
        print("DEBUG AuthViewModel: Log user out ")
    }
    
    // fetch the user from Firebase
    func fetchUser() {
        guard let uid = userSession?.uid else { return }

        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG AuthViewModel F: Error fetching user data: \(error.localizedDescription)")
                return
            }

            guard let user = try? snapshot?.data(as: User.self) else { return }
            self.currentUser = user

            print("DEBUG AuthViewModel S: User object is \(user)")
        }
    }
}
