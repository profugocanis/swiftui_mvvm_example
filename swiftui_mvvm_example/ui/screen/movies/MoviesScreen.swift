import SwiftUI

struct MoviesScreen: BaseScreen {
    
    @InjectViewModel private var viewModel: MoviesViewModel
    @ObservedObject private var state = MoviesScreenState()
    
    init() {
        viewModel.state = state
    }
    
    var body: some View {
        content
            .overlay(
                ProgressView()
                    .opacity(state.isLoading ? 1 : 0)
            )
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            TextField("Search", text: $state.search)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(state.movies, id: \.imdbID) { movie in
                        MovieItemView(movie: movie)
                    }
                    if !state.movies.isEmpty {
                        ProgressView()
                            .padding()
                            .onAppear {
                                viewModel.loadMore()
                            }
                    }
                }
            }
        }
    }
    
    static func open(_ nv: UINavigationController?) {
        let vc = BaseHostingViewController(rootView: MoviesScreen())
        vc.title = "Movies"
        nv?.pushViewController(vc, animated: true)
    }
}
