//
//  SettingsView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - PROPERTIES

    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var vibrationEnabled = false
    @State private var selectedLanguage = "English"

    @EnvironmentObject var authViewModel: AuthViewModel

    // MARK: - BODY

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile").foregroundColor(Color.accentColor)) {
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            // Display the current users full name
                            Text(authViewModel.currentUser?.fullname ?? "N/A")
                                .fontWeight(.bold)
                        }
                    } //: VSTACK
                } //: SECTION
                Section(header: Text("Preferences").foregroundColor(Color.accentColor)) {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell")
                            Text("Notifications")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))

                    Toggle(isOn: $soundEnabled) {
                        HStack {
                            Image(systemName: "speaker.wave.2")
                            Text("Sound")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))

                    Toggle(isOn: $vibrationEnabled) {
                        HStack {
                            Image(systemName: "iphone.radiowaves.left.and.right")
                            Text("Vibration")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.accentColor))
                } //: SECTION

                Section(header: Text("Language").foregroundColor(Color.accentColor)) {
                    NavigationLink(destination: Text("Language Settings")) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Language")
                            Spacer()
                            Text(selectedLanguage)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Button {
                    print("Filip: Log out")
                    // Sign out the user
                    AuthViewModel.shared.signout()
                } label: {
                    Text("Log out")
                        .foregroundColor(.red)
                }
            } //: LIST
            .listStyle(InsetGroupedListStyle())

            .navigationTitle("Settings")
        } //: NAVIGATIONVIEW
    }
}

// MARK: - PREVIEW

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel.shared)

            .preferredColorScheme(.dark)
    }
}
