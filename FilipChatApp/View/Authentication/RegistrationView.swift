//
//  RegistrationView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct RegistrationView: View {
    // MARK: - PROPERTIES

    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var showAlert = false

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var viewModel: AuthViewModel

    // MARK: - BODY

    var body: some View {
        ZStack {
            // Navigation link to main tab view once the user is authenticated
            NavigationLink(destination: MainTabView(),
                           isActive: $viewModel.didAuthenticateUser,
                           label: {})

            Image("Group16")
                .resizable()
                .scaledToFit()
                .frame(width: 400)
                .offset(y: -300)
                .padding(.bottom, 20)
                .rotationEffect(Angle(degrees: 45))
                .shadow(color: Color.accentColor, radius: 10, x: 10, y: 20)

            VStack {
                HStack {
                    Text("Create \nAccount")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(.accentColor)

                    Spacer()
                } //: HSTACK

                Spacer()

                // Input fields for full name, email, and password
                VStack(spacing: 10) {
                    InputTextField(SfImage: "person",
                                   placeHolderText: "Full name",
                                   text: $fullname,
                                   isSecureField: false)

                    InputTextField(SfImage: "envelope",
                                   placeHolderText: "Email",
                                   text: $email, isSecureField: false)

                    InputTextField(SfImage: "lock",
                                   placeHolderText: "Password",
                                   text: $password,
                                   isSecureField: true)
                } //: VSTACK

                Spacer()

                HStack {
                    Spacer()

                    Button {
                        // if fullname is empty display an error message
                        print("DEBUG RegistrationView: Sign in")
                        if !fullname.isEmpty {
                            viewModel.register(email: email, password: password, fullname: fullname)
                        } else {
                            viewModel.errorMessage = "Full name is required"
                            showAlert = false
                        }

                    } label: {
                        Text("SIGN UP")
                            .font(.headline)
                            .fontWeight(.heavy)
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .foregroundColor(.white)
                    .frame(width: 150, height: 55)
                    .background(Color.accentColor.gradient)
                    .clipShape(Capsule())
                } //: HSTACK

                Spacer()

            
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.darkGray))

                        Text("Log In")
                            .font(.system(size: 14, weight: .semibold))
                    } //: HSTACK
                }
                // Show an alert if there's an error message
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? "Unknown error"),
                        dismissButton: .default(Text("OK")) {
                            viewModel.errorMessage = nil
                        }
                    )
                }
                // When the errorMessage in the viewModel is updated, update the showAlert state variable
                .onReceive(viewModel.$errorMessage) { errorMessage in
                    if errorMessage != nil {
                        showAlert = true
                    }
                }
            } //: VSTACK
            .padding()
        }
    }
}

// MARK: - PREVIEW

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
