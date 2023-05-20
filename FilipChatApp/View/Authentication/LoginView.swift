//
//  LoginView.swift
//  FilipChatApp
//
//  Created by Filip Hertzman on 2023-04-12.
//

import SwiftUI

struct LoginView: View {
    // Holds the value for user input
    @State private var email = ""
    @State private var password = ""
    @State private var isShowing = false

    @State private var showAlert = false
    @State private var animation = false

    // Access to the viewmodel
    @EnvironmentObject var viewModel: AuthViewModel

    // MARK: - BODY

    var body: some View {
        NavigationView {
            ZStack {
                Image("Group16")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .offset(x: 69, y: -310)
                    .shadow(color: Color.accentColor, radius: 10, x: 0, y: 10)

                if isShowing {
                    Image("Point_right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .offset(y: -250)
                        .transition(.move(edge: .leading))
                        .animation(.easeIn(duration: 1.0).repeatCount(1), value: animation)
                }

                VStack {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Login")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundColor(.accentColor)

                            Spacer()
                        } //: HSTACK

                        HStack {
                            Text("Please sign in to continue")
                                .font(.system(size: 20))
                                .foregroundColor(Color(.darkGray))

                            Spacer()
                        } //: HSTACK
                    } //: VSTACK
                    .padding(.top, 150)
                    .padding(.bottom, 40)

                    VStack {
                        // Custom textfield
                        InputTextField(SfImage: "envelope", placeHolderText: "Email", text: $email, isSecureField: false)

                        InputTextField(SfImage: "lock", placeHolderText: "Password", text: $password, isSecureField: true)
                    } //: VSTACK
                    .padding(.bottom, 50)

                    HStack {
                        Spacer()

                        Button {
                            print("DEBUG LoginView: Log in")
                            // log in with help from viewmodel
                            viewModel.login(email: email, password: password)

                        } label: {
                            Text("LOGIN")
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
                    .padding(.horizontal, 10)

                    Spacer()

                    // Navigate to RegistrationView
                    NavigationLink {
                        RegistrationView()

                    } label: {
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.darkGray))

                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                        } //: HSTACK
                    }
                } //: VSTACK
                .padding()
                
                //animate on appear
                .onAppear {
                    withAnimation {
                        isShowing = true
                        animation = true
                    }
                }
                // show an alert if there is any error.
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
            }
        
        } //: NAVIGATIONVIEW
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}
