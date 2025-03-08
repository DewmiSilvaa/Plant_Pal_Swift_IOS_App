import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let authService = AuthService()
    
    func signUp() async {
        do {
            try await authService.signUp(email: email, password: password)
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    func signIn() async {
        do {
            try await authService.signIn(email: email, password: password)
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
