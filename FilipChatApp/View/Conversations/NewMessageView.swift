//
//  NewMessageView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct NewMessageView: View {
    @Binding var showChatView: Bool
    @Environment(\.presentationMode) var mode
    @Binding var user: User?
    @ObservedObject var viewModel = NewMessageViewModel()

    var body: some View {
        ScrollView {

            VStack(alignment: .leading) {
                // Button for each user in the view model
                ForEach(viewModel.users) { user in
                    Button {
                        showChatView.toggle()
                        self.user = user
                        mode.wrappedValue.dismiss()
                     
                    } label: {
                        UserCell(user: user)
                    }
                }
            }
            .padding(.top)
        }
        
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView(showChatView: .constant(true), user: .constant(nil))
            .preferredColorScheme(.dark)
    }
}
