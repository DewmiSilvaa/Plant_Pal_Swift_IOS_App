import Foundation
import FirebaseFirestore

class CommunityPostService {
    static let shared = CommunityPostService()
    private let db = Firestore.firestore().collection("communityPosts")
    
    private init() {}

    // MARK: - Create Post
    func createPost(_ post: CommunityPost) async throws {
        var newPost = post
        newPost.createdAt = Date()
        newPost.updatedAt = Date()
        
        try await db.addDocument(from: newPost)
    }
    
    // MARK: - Read All Posts
    func getAllPosts() async throws -> [CommunityPost] {
        let snapshot = try await db.getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: CommunityPost.self)
        }
    }

    // MARK: - Read Single Post
    func getPost(byId id: String) async throws -> CommunityPost? {
        let document = try await db.document(id).getDocument()
        return try document.data(as: CommunityPost.self)
    }
    
    // MARK: - Update Post
    func updatePost(_ post: CommunityPost) async throws {
        guard let postId = post.id else {
            throw NSError(domain: "CommunityPostService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post ID is missing"])
        }
        
        var updatedPost = post
        updatedPost.updatedAt = Date()
        
        try await db.document(postId).setData(from: updatedPost)
    }
    
    // MARK: - Delete Post
    func deletePost(byId id: String) async throws {
        try await db.document(id).delete()
    }
}
