import Foundation
import Combine

class MoviesViewModel: BaseViewModel {
    
    let state: MoviesScreenState
    private let searchMoviesUseCase: SearchMoviesUseCase
    
    init(
        state: MoviesScreenState,
        searchMoviesUseCase: SearchMoviesUseCase
    ) {
        self.state = state
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
