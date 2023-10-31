import Foundation

class SearchMoviesUseCase: BaseUseCase {
    
    private let restManager: RestManager
    
    init(restManager: RestManager) {
        self.restManager = restManager
    }
    
    func invoke(text: String) async -> Source<MoviesSearchResponse> {
        await handle {
            return try await restManager.fetch(url: Endpoints.movies, parameters: [
                "s": text,
                "y": "",
                "page": "1",
                "apikey": BuildUtils.shared.moviesApiKey,
            ])
        }
    }
}
