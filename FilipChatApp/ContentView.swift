//
//  ContentView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct ContentView: View {
     // MARK: - PROPERTIES
    
    @EnvironmentObject var viewModel: AuthViewModel
    
     // MARK: - BODY
    var body: some View {
        Group {
            if viewModel.userSession != nil{
                MainTabView()
            } else {
                LoginView()
            }
 
        }
       
    }
}

 // MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
