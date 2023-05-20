//
//  ConversationsView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct ConversationsView: View {
    // MARK: - PROPERTIES

    @State private var showNewMessageView = false
    @State private var showChatView = false
    @State var selectedUser: User?

    @ObservedObject var viewModel = ConversationViewModel()

    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                // If a user is selected, navigate to the chat view
                if let user = selectedUser {
                    NavigationLink(destination: ChatView(user: user),
                                   isActive: $showChatView,
                                   label: {})
                }

                ScrollView {
                    VStack(alignment: .leading) {
                        // Loop through the recent messages and display a cell for each message
                        ForEach(viewModel.recentMessages) { message in
                            let cellViewModel = ConversationCellViewModel(message)
                            ConversationCell(viewModel: cellViewModel) {
                                // When a cell is tapped, set the selected user and show the chat view
                                self.selectedUser = cellViewModel.message.user
                                self.showChatView = true
                            }
                        }
                    } //: VSTACK
                } //: SCROLLVIEW

                .navigationBarTitle("Chats")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showNewMessageView.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .sheet(isPresented: $showNewMessageView) {
                            NewMessageView(showChatView: $showChatView, user: $selectedUser)
                        }
                    }
                }
            } //: ZSTACK
        } //: NAVIGATIONVIEW
    }
}

// MARK: - PREVIEW

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
            .preferredColorScheme(.dark)
    }
}
