//
//  MessageView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import SwiftUI
import FirebaseFirestore

struct MessageView: View {
     // MARK: - PROPERTIES
 
    // Get the data so we can display the correct information
    let viewModel: MessageViewModel
    
     // MARK: - BODY
    var body: some View {
        HStack {
            //if the message is from current user, display it to right
            // else display it to the left 
            if viewModel.isFromCurrentUser {
                Spacer()
                
                Text(viewModel.message.text)
                    .padding(12)
                    .background(Color.accentColor)
                    .font(.system(size: 15))
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundColor(.white)
                    .padding(.leading, 100)
                    .padding(.horizontal)
            } else {
                HStack(alignment: .bottom) {
                    Text(viewModel.message.text)
                        .padding(12)
                        .background(Color(.white))
                        .font(.system(size: 15))
                        .clipShape(ChatBubble(isFromCurrentUser: false))
                        .foregroundColor(.black)
                }//: HSTACK
                .padding(.horizontal)
                .padding(.trailing, 80)
                
                Spacer()
                
            }// IF ELSE
           
        }//: HSTACK
    }
}

 // MARK: - BODY
//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleMessage = Message(fromId: "1", toId: "2", read: false, text: "Hello, World!", timestamp: Timestamp(), user: MOCK_USER)
//        MessageView(viewModel: MessageViewModel(sampleMessage))
//            .preferredColorScheme(.dark)
//    }
//}
