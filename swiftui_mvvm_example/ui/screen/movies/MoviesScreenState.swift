import Foundation

class MoviesScreenState: BaseState {
    
    var page = 1
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
                if page == 1 {
                    self.movies = movies
                } else {
                    self.movies.append(contentsOf: movies)
                }
            }
            isLoading = false
        case .error(let error):
            showError(error)
            isLoading = false
        }
    }
}
