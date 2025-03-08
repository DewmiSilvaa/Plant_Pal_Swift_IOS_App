import SwiftUI

struct HomeView: View {
    // State to manage current selected tab
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Disease Tab
            DiseaseView()
                .tabItem {
                    Label("Diseases", systemImage: "leaf.fill")
                }
                .tag(1)
            
            // Community Tab
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .tag(2)
        }
        // Optional: Accent color for selected tab
        .accentColor(.green)
    }
}



#Preview {
    HomeView()
}
