import SwiftUI
import FirebaseAuth

struct CreatePostView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var username: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccessToast = false // State for the toast message
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // AppBar-like Title
            Text("Create Post")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(.systemGray6))
            
            Spacer()
            
            // Input Fields
            CustomTextField("Title", text: $title)
            CustomTextArea("Description", text: $description)
            
            // Submit Button
            CustomButton("Submit Post") {
                Task {
                    await handleCreatePost()
                }
            }
            
            // Cancel Button
            CustomButton("Cancel", isSecondary: true) {
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
            
            // Show Success Toast
            if showSuccessToast {
                ToastView(message: "Post posted successfully!")
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 40)
                    .animation(.spring(), value: showSuccessToast)
            }
        }
        .padding()
        .onAppear {
            Task {
                await fetchUsername()
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Fetch the username by user ID
    private func fetchUsername() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            showError(message: "User is not authenticated.")
            return
        }
        
        do {
            let user = try await UserService.shared.getUser()
            self.username = user.displayName ?? "Unknown"
        } catch {
            showError(message: "Failed to fetch username: \(error.localizedDescription)")
        }
    }
    
    // Handle post creation
    private func handleCreatePost() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            showError(message: "User is not authenticated.")
            return
        }
        
        if username.isEmpty {
            showError(message: "Username is not set.")
            return
        }
        
        let newPost = CommunityPost(
            userId: userId,
            username: username,
            title: title,
            description: description,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        do {
            try await CommunityPostService.shared.createPost(newPost)
            // Clear input fields and show success message
            title = ""
            description = ""
            username = ""
            showSuccessToast = true
            
            
            
            // Hide the toast message after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSuccessToast = false
            }
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    // Show error message
    private func showError(message: String) {
        self.errorMessage = message
        self.showError = true
    }
}

// Toast view to display the success message
struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 10)
    }
}

#Preview {
    CreatePostView()
}
