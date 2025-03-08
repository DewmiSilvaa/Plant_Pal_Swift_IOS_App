import SwiftUI
import FirebaseAuth

struct PostContainer: View {
    @State private var posts: [CommunityPost] = []
    @State private var isLoading = true
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showEditPostView = false
    @State private var selectedPost: CommunityPost?
    
   

    private let currentUserId = Auth.auth().currentUser?.uid

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading Posts...")
                        .padding()
                } else if posts.isEmpty {
                    Text("No Posts Available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(posts) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(post.username)
                                    .font(.headline)
                                    .foregroundColor(.green)
                                Spacer()
                                if post.userId == currentUserId {
                                    Menu {
                                        Button("Edit", action: { editPost(post) })
                                        Button("Delete", role: .destructive, action: { deletePost(post) })
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            Text(post.title)
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(post.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Community Posts")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchPosts)
            .background(
                NavigationLink(
                    destination: EditPostView(post: $selectedPost, onSave: {
                        fetchPosts() 
                    }),
                    isActive: $showEditPostView
                ) {
                    EmptyView()
                }


            )
        }
        .alert("Error", isPresented: $showError, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(errorMessage)
        })
    }

    // MARK: - Fetch Posts
    private func fetchPosts() {
        isLoading = true
        Task {
            do {
                posts = try await CommunityPostService.shared.getAllPosts()
                isLoading = false
            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }

    // MARK: - Edit Post
    private func editPost(_ post: CommunityPost) {
        selectedPost = post
        showEditPostView = true
    }

    // MARK: - Delete Post
    private func deletePost(_ post: CommunityPost) {
        Task {
            do {
                if let postId = post.id {
                    try await CommunityPostService.shared.deletePost(byId: postId)
                    fetchPosts() // Refresh posts
                }
            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }

    // MARK: - Show Error
    private func showError(message: String) {
        DispatchQueue.main.async {
            errorMessage = message
            showError = true
        }
    }
}
