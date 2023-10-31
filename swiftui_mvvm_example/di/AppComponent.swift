import Foundation

class AppComponent {
    
    static let shared = AppComponent()
    
    private init() {}
    
    func setup() {
        setupSingeltons()
        setupUseCases()
        setupViewModels()
    }
    
    private func setupSingeltons() {
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
