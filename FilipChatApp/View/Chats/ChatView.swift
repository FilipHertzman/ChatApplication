//
//  ChatView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct ChatView: View {
    // MARK: - PROPERTIES

    //holds the message text
    @State private var messageText = ""
    @ObservedObject var viewModel: ChatViewModel
    //The user that the chat is with
    private let user: User
    
    @State private var showWeeklySummary = false

// Initializes with the selected user.
    init(user: User) {
        self.user = user
        viewModel = ChatViewModel(user: user)
    }

    // MARK: - BODY

    var body: some View {
        VStack {
            ScrollView {
                // Loop through all message and make so we always are at the bottom of the ScrollView
                ScrollViewReader { scrollViewProxy in
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageView(viewModel: MessageViewModel(message))
                        }
                    } //: VSTACK
                    // Automatically scrolls to the bottom of the messages when a new message is added
                    .onChange(of: viewModel.messages.count) { _ in
                        scrollToBottom(scrollViewProxy)
                    }
                    // Automatically scrolls to the bottom of the messages when the view appears
                    .onAppear {
                        scrollToBottom(scrollViewProxy)
                    }
                }
            } //: SCROLLVIEW
            .padding(.bottom)

            // INPUT VIEW
            CustomInputView(text: $messageText, action: sendMessage)
        } //: VSTACK
        .navigationBarTitle("", displayMode: .inline)
              .toolbar {
                  ToolbarItem(placement: .principal) {
                      VStack(spacing: 5) {
                          Text(user.fullname)
                              .font(.headline)
                          // display the total amount of messages we have sent
                          Text("\(viewModel.totalMessagesSent())")
                              .font(.callout)
                              .foregroundColor(.gray)
                      }
                      .padding(.vertical)
                  }
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button {
                          // show WeeklySummaryView when is tapped
                          showWeeklySummary.toggle()
                      } label: {
                          Image(systemName: "checkmark.message.fill")
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 24, height: 24)
                      }

                  }
              }
              .padding(.vertical)
              // show the sheet when showWeeklySummary is toggle
              .sheet(isPresented: $showWeeklySummary) {
                  WeeklySummaryView(viewModel: viewModel)
              }
              
          }

    // send message and clear the input when the message is sent
    func sendMessage() {
        viewModel.sendMessage(messageText)
        messageText = ""
    }

    // function that handles that we are at the bottom
    private func scrollToBottom(_ scrollViewProxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    

}

// MARK: - PREVIEW

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(user: MOCK_USER)
                .preferredColorScheme(.dark)
        }
    }
}
