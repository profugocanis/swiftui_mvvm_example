import Foundation

@Observable
class MovieDetailState: BaseState {
    
    var isLoading: Bool = false
    private(set) var movieDetails: MovieDetails?
    
    func setMovieDetails(_ details: MovieDetails) {
        movieDetails = details
    }

//    func handleDetail(_ source: Source<MovieDetails>) {
//        switch source {
//        case .processing:
//            isLoading = true
//        case .success(let data):
//            isLoading = false
//            movieDetails = data
//        case .error(let error):
//            isLoading = false
//            showErrorDialog(error)
//        }
//    }
}
