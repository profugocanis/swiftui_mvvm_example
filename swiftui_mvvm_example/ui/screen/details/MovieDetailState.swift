import Foundation

class MovieDetailState: BaseState {
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var movieDetails: MovieDetails?

    func handleDetail(_ source: Source<MovieDetails>) {
        switch source {
        case .processing:
            isLoading = true
        case .success(let data):
            isLoading = false
            movieDetails = data
        case .error(let error):
            isLoading = false
            showErrorDialog(error)
        }
    }
}
