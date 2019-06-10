import SwiftUI

struct SearchBar : View {
    
    @Binding var text: String
    @State var handler: () -> ()
    
    var body: some View {
        HStack {
            TextField($text, placeholder: Text("Input Search Word"))
                .padding([.leading, .trailing], 32)
                .frame(height: 40)
                .foregroundColor(Color.blue)
            Button(action: handler) {
                Text("Search")
                    .foregroundColor(Color.black)
            }
                .padding([.leading, .trailing], 16)
        }
        .frame(height: 64)
    }
}

#if DEBUG
struct SearchBar_Previews : PreviewProvider {
    static var previews: some View {
        SearchBar(text: Binding.constant(""), handler: {})
    }
}
#endif
