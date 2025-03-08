import SwiftUI

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    Image("plant_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                    
                    Text("Plant Pal")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    
                    // Title
                    Text(isSignUp ? "Create Account" : "Welcome Back")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    // Input Fields
                    VStack(spacing: 16) {
                        CustomTextField("Email", text: $viewModel.email)
                        
                        CustomTextField("Password", text: $viewModel.password, isSecure: true)
                    }
                    .padding(.bottom, 8)
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        CustomButton(isSignUp ? "Sign Up" : "Sign In") {
                            Task {
                                if isSignUp {
                                    await viewModel.signUp()
                                } else {
                                    await viewModel.signIn()
                                }
                            }
                        }
                        
                        CustomButton(
                            isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up",
                            isSecondary: true
                        ) {
                            withAnimation {
                                isSignUp.toggle()
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .background(Color.white)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

// Preview Provider
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
