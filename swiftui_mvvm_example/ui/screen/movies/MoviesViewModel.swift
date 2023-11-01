import Foundation

class MoviesViewModel: BaseViewModel, StateViewModelProtocol {
    
    var state: MoviesScreenState!
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    
    init(searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
    
    @MainActor
    func loadSearch() {
        state.page = 1
        state.handleMovies(.processing)
        task { [weak self] in
            guard let self = self else { return }
            state.handleMovies(await searchMoviesUseCase.invoke(text: state.search, page: state.page))
        }
    }
    
    @MainActor
    func loadMore() {
        if state.search.count < 3 { return }
        state.page += 1
        task { [weak self] in
            guard let self = self else { return }
            state.handleMovies(await searchMoviesUseCase.invoke(text: state.search, page: state.page))
        }
    }
}
