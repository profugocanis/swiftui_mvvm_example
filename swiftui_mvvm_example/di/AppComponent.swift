import Foundation

class AppComponent: BaseAppComponent {
    
    static let shared = AppComponent()
    
    private override init() {}
    
    func setup() {
        setupViewStates()
        setupSingletons()
        setupUseCases()
        setupViewModels()
    }
    
    private func setupViewStates() {
        factory { _ in MoviesScreenState() }
        factory { _ in MovieDetailState() }
    }
    
    private func setupSingletons() {
        singelton { _ in RestManager() }
    }
    
    private func setupUseCases() {
        factory { SearchMoviesUseCase(restManager: $0.get()!) }
        factory { GetMovieDetailsUseCase(restManager: $0.get()!) }
    }
    
    private func setupViewModels() {
        factory {
            MoviesViewModel(
                state: $0.get()!,
                searchMoviesUseCase: $0.get()!
            )
        }
        factory {
            MovieDetailViewModel(
                state: $0.get()!,
                getDetailUseCase: $0.get()!
            )
        }
    }
}
