//
//  UserCell.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import FirebaseFirestore
import SwiftUI

struct ConversationCell: View {
    // MARK: - PROPERTIES

    @ObservedObject var viewModel: ConversationCellViewModel
    
    // OnTap used for navigate when a cell is tapped
    var onTap: () -> Void

    // MARK: - BODY

    var body: some View {
        // Only display the cell if the message has a user
        if viewModel.message.user != nil {
            // Create a button for the cell that calls the onTap closure when tapped
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack { Spacer() }

                    Text(viewModel.fullname)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color.accentColor)
                        .padding(.bottom, 4)

                    Text(viewModel.message.text)
                        .font(.system(size: 15))
                        .foregroundColor(.white)

                    Divider()
                        .foregroundColor(.accentColor)
                        .padding(.top)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - PREVIEW

// struct ConversationCell_Previews: PreviewProvider {
//    static var previews: some View {
//
//
//        ConversationCell()
//    }
// }
