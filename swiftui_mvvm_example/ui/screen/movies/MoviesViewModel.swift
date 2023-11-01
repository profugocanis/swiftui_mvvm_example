import Foundation
import Combine

class MoviesViewModel: BaseViewModel {
    
    var state: MoviesScreenState! {
        didSet {
            state.$search
                .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
                .sink(receiveValue: { [weak self] t in
                    guard let self = self else { return }
                    task {
                        await self.loadSearch(t)
                    }
                })
                .store(in: &subscriptions)
        }
    }
    private let searchMoviesUseCase: SearchMoviesUseCase
    
    init(searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
    
    @MainActor
    private func loadSearch(_ text: String) {
        if text.count < 3 { return }
        state.page = 1
        state.handleMovies(.processing)
        task { [weak self] in
            guard let self = self else { return }
            state.handleMovies(await searchMoviesUseCase.invoke(text: text, page: state.page))
        }
    }
    
    @MainActor
    func loadMore() {
        if state.search.count < 3 { return }
        state.page += 1
        state.handleMovies(.processing)
        task { [weak self] in
            guard let self = self else { return }
            state.handleMovies(await searchMoviesUseCase.invoke(text: state.search, page: state.page))
        }
    }
}
