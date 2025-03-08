import Foundation
import FirebaseFirestore

struct CommunityPost: Codable, Identifiable {
    @DocumentID var id: String? // Firestore document ID
    let userId: String
    let username: String
    var title: String
    var description: String
    var createdAt: Date
    var updatedAt: Date
}
