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
        state.isLoading = true
        launchSafely { [weak self] error in
            guard let self = self else { return }
            state.showErrorDialog(error)
            state.isLoading = false
        } launch: { [weak self] in
            guard let self = self else { return }
            let result = try await searchMoviesUseCase.invoke(text: state.search, page: state.page)
            state.setMovies(result)
            state.isLoading = false
            
        }
    }
    
    @MainActor
    func loadMore() {
        if state.search.count < 3 { return }
        state.page += 1
        launchSafely { error in
            self.state.showErrorDialog(error)
        } launch: { [weak self] in
            guard let self = self else { return }
            let result = try await searchMoviesUseCase.invoke(text: state.search, page: state.page)
            state.addMovies(result)
        }
    }
}
