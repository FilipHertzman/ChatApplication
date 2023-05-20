//
//  WeeklySummaryView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-24.
//

import SwiftUI

struct WeeklySummaryView: View {
     // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChatViewModel
    
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
     // MARK: - BODY
    var body: some View {
        NavigationView {
               List {
                   // Total messages per day section
                   Section(header: Text("Messages sent per day") .foregroundColor(Color.accentColor)) {
                       // loop through weekdays
                       ForEach(weekdays, id: \.self) { day in
                           // Get the count of messages for the current day
                           let count = viewModel.messagesSentPerDayOfWeek()[day] ?? 0
                           HStack {
                               Text(day)
                                   .font(.headline)
                               
                               Spacer()
                               Text("\(count)")
                                   .font(.subheadline)
                                   .foregroundColor(.accentColor)
                           }
                       }
                   }
        
                   
                   // Total messages sent to user section
                   Section(header: Text("Total messages sent to user").foregroundColor(Color.accentColor)) {
                       HStack {
                           Text("Total")
                               .font(.headline)
                           
                           Spacer()
                           Text("\(viewModel.totalMessagesSent())")
                               .font(.subheadline)
                               .foregroundColor(.accentColor)
                       }
                   }
               }
               .listStyle(.plain)
               .navigationBarTitle(currentWeekDisplay(), displayMode: .inline)
               .navigationBarItems(trailing: Button(action: {
                   presentationMode.wrappedValue.dismiss()
               }) {
                   Image(systemName: "xmark")
               })
           }
       }
       
    // Function to create a string with the current week number
       func currentWeekDisplay() -> String {
           let calendar = Calendar.current
           let today = Date()
           let weekOfYear = calendar.component(.weekOfYear, from: today)
           
           return " Summary Week \(weekOfYear)"
       }
   }
struct WeeklySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleUser = User(fullname: "Filip", email: "Hertzman")
        WeeklySummaryView(viewModel: ChatViewModel(user: exampleUser))
            .preferredColorScheme(.dark)
    }
}
