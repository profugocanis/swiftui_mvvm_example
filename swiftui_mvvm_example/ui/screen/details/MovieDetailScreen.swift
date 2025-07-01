import SwiftUI

struct MovieDetailScreen: BaseScreen {
    
    @ObservedObject private var state: MovieDetailState
    private var viewModel: MovieDetailViewModel

    init(_ vc: ScreenViewController, movie: Movie) {
        self.viewModel = AppComponent.shared.injectViewModel(vc)
        self.state = self.viewModel.state
        self.viewModel.loadDetail(imdbID: movie.imdbID ?? "")
    }

    var body: some View {
        content
    }

    // MARK: open
    static func open(_ nv: UINavigationController?, movie: Movie) {
        let vc = ScreenViewController { vc in
            MovieDetailScreen(vc, movie: movie)
        }
        nv?.pushViewController(vc, animated: true)
    }
}

extension MovieDetailScreen {

    private var content: some View {
        EmptyView()
    }
}
