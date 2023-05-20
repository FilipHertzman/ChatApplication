//
//  InputTextField.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct InputTextField: View {
     // MARK: - PROPERTIES
    
    let SfImage: String
    let placeHolderText: String
    //Binding to Login & Register view
    @Binding var text: String
    let isSecureField: Bool

     // MARK: - BODY
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: SfImage)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)

            // Display the secure field if isSecureField is true, otherwise display a regular text field
            if isSecureField {
                SecureField(placeHolderText, text: $text)

            } else {
                TextField(placeHolderText, text: $text)
            }
        }

        .padding()
        .padding(.horizontal, 4)

        Divider()
            .background(Color.accentColor)
            .padding(.horizontal)
    }
}

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        InputTextField(SfImage: "envelope", placeHolderText: "Email", text: .constant("example@gmail.com"), isSecureField: false)
            .preferredColorScheme(.dark)
    }
}
