import Foundation
import Alamofire

class GetMovieDetailsUseCase: BaseUseCase {
    
    private let restManager: RestManager

    init(restManager: RestManager) {
        self.restManager = restManager
    }

    func invoke(imdbID: String) async -> Source<MovieDetails> {
        await handle {
            return try await restManager.fetch(
                url: Endpoints.movies,
                parameters: [
                    "plot": "full",
                    "i": imdbID,
                    "apikey": BuildUtils.shared.moviesApiKey
                ]
            ) as MovieDetails
        }
    }
}
