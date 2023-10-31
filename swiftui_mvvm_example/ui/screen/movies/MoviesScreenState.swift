import Foundation

class MoviesScreenState: BaseState {
    
    @Published var search = ""
    @Published private(set) var isLoading = false
    @Published private(set) var movies = [MoviesSearchResponse.Movie]()
    
    func handleMovies(_ source: Source<MoviesSearchResponse>) {
        switch source {
        case .processing: isLoading = true
        case .success(let response):
            if let error = response?.error {
                showError(error)
            }
            if let movies = response?.search {
                self.movies = movies
            }
            isLoading = false
        case .error(let error):
            showError(error)
            isLoading = false
        }
    }
}
