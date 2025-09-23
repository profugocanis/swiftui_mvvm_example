import Foundation
import Alamofire

class GetMovieDetailsUseCase: BaseUseCase {
    
    private let restManager: RestManager
    
    init(restManager: RestManager) {
        self.restManager = restManager
    }
    
    func invoke(imdbID: String) async throws -> MovieDetails {
        try await restManager.fetch(
            url: BuildUtils.shared.moviesApi,
            payload: [
                "plot": "full",
                "i": imdbID,
                "apikey": BuildUtils.shared.moviesApiKey
            ]
        )
    }
}
