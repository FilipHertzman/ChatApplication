//
//  MainTabView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            TabView {
                ConversationsView()
                    .tabItem {
                        Image(systemName: "bubble.left")
                        Text("Chats")
                    }

                SettingsView()

                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }

    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())

            .preferredColorScheme(.dark)
    }
}
