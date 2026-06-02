import Foundation

@Observable
class MoviesScreenState: BaseState {
    
    var page = 1
    var search = "One"
    var isLoading = false
    private(set) var movies = [Movie]()
    
    var searchTask: Task<Void, Never>?
    
    func setMovies(_ movies: [Movie]) {
        self.movies = movies
    }
    
    func addMovies(_ movies: [Movie]) {
        self.movies.append(contentsOf: movies)
    }
}
