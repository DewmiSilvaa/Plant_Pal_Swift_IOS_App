import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    private var userId: String? {
           return Auth.auth().currentUser?.uid
    }
       
    func createUser(_ user: User, userId: String) async throws {
        try await db.collection("users").document(userId).setData(from: user)
    }
    
    func getUser() async throws -> User {
        guard let currentUserId = userId else {
            throw NSError(
                      domain: "UserService",
                      code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "User ID not found"]
                  )
        }
        let snapshot = try await db.collection("users").document(currentUserId).getDocument()
        guard let user = try? snapshot.data(as: User.self) else {
            throw NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        return user
    }
    
    func updateUser(_ user: User, userId: String) async throws {
        var updatedUser = user
        updatedUser.updatedAt = Date()
        try await db.collection("users").document(userId).setData(from: updatedUser)
    }
    
    func deleteUser(userId: String) async throws {
        try await db.collection("users").document(userId).delete()
    }
}
