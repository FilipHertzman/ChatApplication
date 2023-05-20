//
//  CustomInputView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import SwiftUI

struct CustomInputView: View {
    // MARK: - PROPERTIES

    //Binding to the text in ChatView
    @Binding var text: String
    
    //Action we used in Chat View to send message 
    var action: () -> Void

    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                TextField("Message...", text: $text)
                    .padding(12)
                    .background(Color.clear)
                    .font(.system(size: 16))
                    .foregroundColor(Color(.label))
                    .padding(.leading)
                    .padding(.trailing, 10)
                    .frame(minHeight: 44)

                Button(action: action) {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 12))
                        .foregroundColor(.accentColor)
                }
                .padding(.trailing)
            }//: HSTACK
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.separator), lineWidth: 1)
            )
            .padding(.bottom, 8)
            .padding(.horizontal, 24)
        }//: VSTACK
    }
}
 // MARK: - PREVIEW
struct CustomInputView_Previews: PreviewProvider {
    
    @State static private var text: String = ""
    static var previews: some View {
        CustomInputView(text: $text, action: {})
            .preferredColorScheme(.dark)
    }
}
