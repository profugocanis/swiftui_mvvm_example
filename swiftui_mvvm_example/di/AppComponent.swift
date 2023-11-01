import Foundation

class AppComponent {
    
    static let shared = AppComponent()
    
    private init() {}
    
    func setup() {
        setupSingletons()
        setupUseCases()
        setupViewModels()
    }
    
    private func setupSingletons() {
        singelton { _ in RestManager() }
    }
    
    private func setupUseCases() {
        factory { SearchMoviesUseCase(restManager: $0.get()!) }
    }
    
    private func setupViewModels() {
        factory {
            MoviesViewModel(searchMoviesUseCase: $0.get()!)
        }
    }
}
