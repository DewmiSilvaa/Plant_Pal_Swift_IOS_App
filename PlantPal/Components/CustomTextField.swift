import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    let isSecure: Bool
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .autocapitalization(.none)
    }
}
