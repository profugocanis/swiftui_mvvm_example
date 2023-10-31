import SwiftUI

struct TestRestScreen: BaseScreen {
    
    @InjectViewModel private var viewModel: TestRestViewModel
    @ObservedObject private var state = TestRestScreenState()
    
    init() {
        viewModel.state = state
    }
    
    var body: some View {
        content
            .padding(8)
            .onAppear {
                if state.albums.isEmpty {
                    viewModel.load()
                }
            }
            .overlay(
                ProgressView()
                    .opacity(state.isLoading ? 1 : 0)
            )
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            Text("Albums")
            ScrollView {
                ForEach(state.albums, id: \.collectionId) { album in
                    VStack {
                        HStack {
                            Text("\(album.collectionName ?? "")")
                            Spacer()
                        }
                        Divider()
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    static func open(_ nv: UINavigationController?) {
        let vc = BaseHostingViewController(rootView: TestRestScreen())
        vc.title = "Second Screen"
        nv?.pushViewController(vc, animated: true)
    }
}
