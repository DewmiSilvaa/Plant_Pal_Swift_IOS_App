import Foundation
import Firebase
import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthStateHandler()
    }
    
    private func setupAuthStateHandler() {
        Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }
            self.isAuthenticated = firebaseUser != nil
            if let firebaseUser = firebaseUser {
                self.fetchUser(userId: firebaseUser.uid)
            } else {
                self.user = nil
            }
        }
    }
    
    func signUp(email: String, password: String) async throws {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(
            email: email,
            createdAt: Date(),
            updatedAt: Date()
        )
        try await UserService.shared.createUser(user, userId: authResult.user.uid)
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    private func fetchUser(userId: String) {
        Task {
            self.user = try await UserService.shared.getUser()
        }
    }
}
