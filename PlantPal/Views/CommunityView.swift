import SwiftUI

struct CommunityView: View {
    @StateObject private var authService = AuthService()
    
    
    
    var body: some View {
       
            NavigationStack {
                HStack(spacing:20){
                    NavigationLink(destination: CreatePostView()) {
                        Text("Create Post")
                            .fontWeight(.semibold)
                    }
                    NavigationLink(destination: ProfileView().environmentObject(authService)) {
                        Text("Profile")
                            .fontWeight(.semibold)
                    }
                }.padding()
                VStack {
                    
                    // Centered Title
                    Text("Plant Pal Community")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                        .multilineTextAlignment(.center)
                    PostContainer()
                   
                }
             
                
            }
        
    }
}

// Previews
#Preview {
    CommunityView()
        .environmentObject(AuthService()) // Provide a mock or real AuthService
}
