//
//  ChatBubble.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import SwiftUI

struct ChatBubble: Shape {
    // MARK: - PROPERTIES
    
    // variable used to style the bubble if it's from current user or not
    var isFromCurrentUser: Bool
    
    // MARK: - BODY
    
    // Returns a Path object that defines the shape of the chat bubble
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isFromCurrentUser ? .bottomLeft : .bottomRight] , cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}

 // MARK: - PREVIEW
struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(isFromCurrentUser: true)
            
    }
}
