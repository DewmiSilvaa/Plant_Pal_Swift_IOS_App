import SwiftUI

struct EditPostView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var post: CommunityPost?
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    @State private var toastMessage = ""
    @State private var showToast = false
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: Binding(
                    get: { post?.title ?? "" },
                    set: { post?.title = $0 }
                ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Description", text: Binding(
                    get: { post?.description ?? "" },
                    set: { post?.description = $0 }
                ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
                
                Button("Save Changes") {
                    saveChanges()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
                .navigationBarBackButtonHidden(false)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Edit Post")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showToast) {
                          Alert(title: Text(toastMessage), dismissButton: .default(Text("OK")))
                      }
        }
    }

    private func saveChanges() {
        Task {
            do {
                if let existingPost = post {
                    try await CommunityPostService.shared.updatePost(existingPost)
                    toastMessage = "Post updated successfully!"
                } else {
                    
                    let newPost = CommunityPost(
                        userId: post?.userId ?? "",
                           username: post?.username ?? "",
                           title: post?.title ?? "",
                           description: post?.description ?? "",
                           createdAt: post?.createdAt ?? Date(),
                        updatedAt: post?.updatedAt ?? Date()
                    )
                    try await CommunityPostService.shared.createPost(newPost)
                }
                showToast = true
            } catch {
                print("Error saving post: \(error.localizedDescription)")
            }
        }
    }
}
