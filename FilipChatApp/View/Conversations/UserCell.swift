//
//  UserCell.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct UserCell: View {
     // MARK: - PROPERTES
    
    // Property for the user to be displayed
    let user: User

     // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack { Spacer() }

            // Display the users fullname
            Text(user.fullname)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.accentColor)
                .padding(.bottom, 4)

            // Display the users email
            Text(user.email)
                .font(.system(size: 15))
                .foregroundColor(.white)

            Divider()
                .foregroundColor(.accentColor)
                .padding(.top)
            
        }
        .padding(.horizontal)
    }
}

 // MARK: - PREVIEW
struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        let exampleUser = User(fullname: "Filip Hertzman", email: "filip.hertzman@gmail.com")
        UserCell(user: exampleUser)
            .preferredColorScheme(.dark)
    }
}
