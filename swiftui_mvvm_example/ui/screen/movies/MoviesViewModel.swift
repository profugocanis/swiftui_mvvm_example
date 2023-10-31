import Foundation
import Combine

class MoviesViewModel: BaseViewModel {
    
    let state = MoviesScreenState()
    private let searchMoviesUseCase: SearchMoviesUseCase
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
        super.init()
        self.state.$search
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                guard let self = self else { return }
                task {
                    await self.loadSearch(t)
                }
            })
            .store(in: &subscriptions)
    }
    
    @MainActor
    private func loadSearch(_ text: String) {
        if text.count < 3 { return }
        state.handleMovies(.processing)
        task { [weak self] in
            guard let self = self else { return }
            state.handleMovies(await searchMoviesUseCase.invoke(text: text))
        }
    }
    
    override func onCanceled() {
        super.onCanceled()
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}
