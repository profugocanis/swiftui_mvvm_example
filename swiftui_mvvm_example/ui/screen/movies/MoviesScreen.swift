import SwiftUI

struct MoviesScreen: BaseScreen {

    @ObservedObject private var state = MoviesScreenState()
    private var viewModel: MoviesViewModel { injectViewModel(state) }
    
    func viewDidLoad() {
        state.$search
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink {
                if $0.count < 3 { return }
                viewModel.loadSearch()
            }
            .store(in: &viewModel.subscriptions)
    }
    
    var body: some View {
        content
            .overlay(
                ProgressView()
                    .opacity(state.isLoading ? 1 : 0)
            )
    }
    
    private let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
    private var content: some View {
        VStack(alignment: .leading) {
            TextField("Search", text: $state.search)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 4) {
//                LazyVStack {
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
                .padding(.horizontal, 4)
            }
            .refreshable {
                viewModel.loadSearch()
            }
        }
    }
    
    static func open(_ nv: CustomNavigationController?) {
        let vc = BaseHostingViewController(rootView: MoviesScreen())
        vc.title = "Movies"
        nv?.pushViewController(vc, animated: true)
    }
}
