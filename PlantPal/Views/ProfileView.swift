import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image Section
                    VStack(spacing: 16) {
                       
                        // Circular Profile Image
                        if let photoURL = viewModel.photoURL.isEmpty ?? true ? nil : viewModel.photoURL ,
                           !photoURL.isEmpty,
                           let url = URL(string: photoURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.green.opacity(0.8), lineWidth: 2))
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                                .overlay(Circle().stroke(Color.green.opacity(0.8), lineWidth: 2))
                        }
                        
                        Text(viewModel.email ?? "")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.top, 20)
                    
                    // Profile Information Section
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Profile Information")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        CustomTextField("Display Name", text: $viewModel.displayName)
                    }
                    .padding(.horizontal, 16)
                    
                    // Buttons Section
                    VStack(spacing: 16) {
                        CustomButton("Update Profile") {
                            Task {
                                await viewModel.updateProfile()
                            }
                        }
                        
                        CustomButton("Sign Out", isSecondary: true) {
                            viewModel.signOut()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Profile")
            .background(Color(.white))
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .onAppear {
                Task {
                    do {
                        let user = try await UserService.shared.getUser()
                        DispatchQueue.main.async {
                            viewModel.initialize(with: user)
                        }
                    } catch {
                        // Handle error
                    }
                }
            }
        }
    }
}

// Success Alert Modifier
struct SuccessAlert: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        content.alert("Success", isPresented: $isPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(message)
        }
    }
}

// Preview Provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthService())
    }
}
