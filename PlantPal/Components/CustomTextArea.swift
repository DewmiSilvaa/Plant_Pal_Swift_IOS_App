import SwiftUI

struct CustomTextArea: View {
    let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        VStack() {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 12)
            }
            
            TextEditor(text: $text)
                
                .frame(minHeight: 100, maxHeight: 200) // Adjust height as needed
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)
                .padding(.top, 8) // Adjusts the placeholder position
        } .background(Color(.systemGray6))
    }
}

#Preview {
    CustomTextArea("Enter your text here", text: .constant(""))
}
