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
    }
    
    private func setupSingletons() {
        singelton { _ in RestManager() }
    }
    
    private func setupUseCases() {
        factory { SearchMoviesUseCase(restManager: $0.get()!) }
    }
    
    private func setupViewModels() {
        factory {
            MoviesViewModel(
                state: $0.get()!,
                searchMoviesUseCase: $0.get()!
            )
        }
    }
}
