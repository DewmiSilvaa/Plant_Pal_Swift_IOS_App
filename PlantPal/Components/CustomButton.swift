import SwiftUI

struct CustomButton: View {
    let title: String
    let isSecondary: Bool
    let action: () -> Void
    
    init(_ title: String, isSecondary: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isSecondary = isSecondary
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isSecondary ? Color.clear : Color.green.opacity(0.8))
                .foregroundColor(isSecondary ? .green : .white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSecondary ? Color.green : Color.clear, lineWidth: 1)
                )
        }
    }
}
