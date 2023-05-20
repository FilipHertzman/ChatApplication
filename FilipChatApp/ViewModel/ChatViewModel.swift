//
//  ChatViewModel.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-20.
//

import CoreData
import Firebase
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    // An array of Message objects, which is published so that changes to it can be observed
    @Published var messages = [Message]()

    // The user that the current user is chatting with
    let user: User

    // The initializer function that is called when an instance of the class is created
    init(user: User) {
        self.user = user
        fetchMessages()
    }

    // A function that returns the number of messages that the current user has sent to the chat partner
    func totalMessagesSent() -> Int {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return 0 }

        let sentMessages = messages.filter { $0.fromId == currentUid }
        return sentMessages.count
    }

    // A function that fetches the messages between the current user and the chat partner from Firestore
    func fetchMessages() {
        // Get the UID of the current user and the ID of the chat partner
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        guard let chatPartnerId = user.id else { return }

        // Create a Firestore query to get the messages between the two users
        let query = COLLECTION_MESSAGES.document(currentUid).collection(chatPartnerId)

        // Listen for changes to the messages collection
        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")

                self.fetchMessagesFromCoreData()

                return
            }
            // Create an array of Message objects from the documents returned by the query
            var messages = documents.compactMap { try? $0.data(as: Message.self) }

            print("DEBUG ChatViewModel s: \(self.messages)")

            // Set the user property of the messages that were sent by the chat partner to the chat partner's user object
            for (index, message) in messages.enumerated() where message.fromId != currentUid {
                messages[index].user = self.user
            }

            // Sort messages by timestamp
            messages.sort { $0.timestamp.compare($1.timestamp) == .orderedAscending }

            // Set the messages array to the new messages
            self.messages = messages

            // self.saveMessagesToCoreData(messages)
        }
    }

    func sendMessage(_ messageText: String) {
        // Get the UID of the current user and the ID of the chat partner
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        guard let chatPartnerId = user.id else { return }

        // Create references to the messages collections for the current user and the chat partner
        let currentUseRef = COLLECTION_MESSAGES.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = COLLECTION_MESSAGES.document(chatPartnerId).collection(currentUid)

        // Create references to the recent-messages collections for the current user and the chat partner
        let recentCurrentRef = COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(chatPartnerId)
        let recentPartnerRef = COLLECTION_MESSAGES.document(chatPartnerId).collection("recent-messages").document(currentUid)

        // Generate a new message ID
        let messageId = currentUseRef.documentID

        // Create a dictionary of message data
        let data: [String: Any] = ["text": messageText,
                                   "fromId": currentUid,
                                   "toId": chatPartnerId,
                                   "read": false,
                                   "timestamp": Timestamp(date: Date()),
        ]

        // Save the message to the messages collections for both users
        currentUseRef.setData(data)
        chatPartnerRef.document(messageId).setData(data)

        // Update the recent-messages collections for both users
        recentCurrentRef.setData(data)
        recentPartnerRef.setData(data)
    }

    private func saveMessagesToCoreData(_ messages: [Message]) {
        let context = CoreDataStack.shared.persistentContainer.viewContext

        // Create a new CDMessage object for each Message object and save it to Core Data
        for message in messages {
            let cdMessage = CDMessage(context: context)
            cdMessage.fromId = message.fromId
            cdMessage.messageId = message.id
            cdMessage.text = message.text
            cdMessage.timestamp = message.timestamp.dateValue() // Convert the Timestamp object to a Date object
            cdMessage.toId = message.toId
        }

        do {
            // Save the changes to Core Data
            try context.save()
            print("DEBUG ChatViewModel S: Saved messages to Core Data: \(messages)")
        } catch let error {
            print("DEBUG ChatViewModel F: Error saving messages to Core Data: \(error)")
        }
    }

    private func fetchMessagesFromCoreData() {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDMessage> = CDMessage.fetchRequest()

        // Fetch the CDMessage objects from Core Data
        do {
            // Convert the CDMessage objects to Message objects and set the messages array to the new messages
            let cdMessages = try context.fetch(fetchRequest)
            let messages = cdMessages.map { Message(cdMessage: $0) }
            print("DEBUG ChatViewModel S: Fetched messages from Core Data: \(messages)")
            self.messages = messages.sorted { $0.timestamp.dateValue().compare($1.timestamp.dateValue()) == .orderedAscending }
        } catch let error {
            print("DEBUG ChatViewModel F: Error fetching messages from Core Data: \(error)")
        }
    }

    func messagesSentPerDayOfWeek() -> [String: Int] {
        // Get the current user's ID
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return [:] }

        // Filter the messages to only include messages sent by the current user
        let sentMessages = messages.filter { $0.fromId == currentUid }

        // Initialize a dictionary to keep track of the number of messages sent per day of the week
        var messagesPerDay: [String: Int] = ["Monday": 0, "Tuesday": 0, "Wednesday": 0, "Thursday": 0, "Friday": 0, "Saturday": 0, "Sunday": 0]

        // Create a calendar object and set it to use the US English locale
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")

        // Set the first weekday to Monday because Sunday is used for 1
        calendar.firstWeekday = 2

        // Get today's date and the start of the week for today
        let today = Date()
        let startOfWeekToday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        // Loop through each message sent by the current user
        for message in sentMessages {
            // Get the date the message was sent
            let date = message.timestamp.dateValue()

            // Get the start of the week for the messages date
            let startOfWeekMessageDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!

            // If the message was sent during the current week, increment the count for the corresponding day of the week
            if startOfWeekMessageDate == startOfWeekToday {
                let dayIndex = calendar.component(.weekday, from: date) - 1
                let dayName = calendar.weekdaySymbols[dayIndex % 7]

                if let count = messagesPerDay[dayName] {
                    messagesPerDay[dayName] = count + 1
                } else {
                    print("DEBUG: ChatViewModel S: Unexpected day name: \(dayName)")
                }
            }
        }
        // Return the dictionary containing the number of messages sent per day of the week
        return messagesPerDay
    }
}
