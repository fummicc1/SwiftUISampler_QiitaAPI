import SwiftUI

struct QiitaRow : View {
    
    @State var qiita: Qiita
    
    var body: some View {
        VStack {
            Text("id: \(qiita.id)")
            Text("title: \(qiita.title)")
        }
    }
}

#if DEBUG
struct QiitaRow_Previews : PreviewProvider {
    static var previews: some View {
        QiitaRow(
            qiita: Qiita(id: "", title: "")
        )
    }
}
#endif
