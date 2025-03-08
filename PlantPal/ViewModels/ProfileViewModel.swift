import Foundation
import FirebaseAuth
class ProfileViewModel: ObservableObject {
@Published var displayName = ""
@Published var photoURL = "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
@Published var email: String?
@Published var showError = false
@Published var errorMessage = ""
@Published var showSuccessAlert = false

private var userId: String?

func initialize(with user: User?) {
    guard let user = user else { return }
    self.userId = user.id
    self.email = user.email
    self.displayName = user.displayName ?? ""
    self.photoURL = user.photoURL ?? ""
}

func updateProfile() async {
    guard let userId = userId, let email = email else { return }
    
    let updatedUser = User(
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        createdAt: Date(),
        updatedAt: Date()
    )
    
    do {
        try await UserService.shared.updateUser(updatedUser, userId: userId)
        DispatchQueue.main.async {
            self.showSuccessAlert = true
        }
    } catch {
        showError(message: error.localizedDescription)
    }
}

func signOut() {
    do {
        try AuthService().signOut()
    } catch {
        showError(message: error.localizedDescription)
    }
}

private func showError(message: String) {
    DispatchQueue.main.async {
        self.errorMessage = message
        self.showError = true
    }
}
}
