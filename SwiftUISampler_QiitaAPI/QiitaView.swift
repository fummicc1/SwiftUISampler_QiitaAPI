import SwiftUI

struct QiitaView : View {
    
    @ObjectBinding var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: viewModel[\.textName]) {
                    self.viewModel.search()
                }
                
                if viewModel.qiitaList.isNotEmpty {
                    List(viewModel.qiitaList) { qiita in
                        QiitaRow(qiita: qiita).onAppear { print(qiita) }
                    }
                }
            }.navigationBarTitle(Text("Search Qiita"))
        }
    }
}

#if DEBUG
struct QiitaView_Previews : PreviewProvider {
    static var previews: some View {
        QiitaView()
    }
}
#endif
