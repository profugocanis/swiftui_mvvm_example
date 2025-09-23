import Foundation

class MoviesScreenState: BaseState {
    
    var page = 1
    @Published var search = "One"
    @Published var isLoading = false
    @Published private(set) var movies = [Movie]()
    
    func setMovies(_ movies: [Movie]) {
        self.movies = movies
    }
    
    func addMovies(_ movies: [Movie]) {
        self.movies.append(contentsOf: movies)
    }
}
