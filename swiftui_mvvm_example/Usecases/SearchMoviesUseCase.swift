import Foundation

class SearchMoviesUseCase: BaseUseCase {
    
    private let restManager: RestManager
    
    init(restManager: RestManager) {
        self.restManager = restManager
    }
    
    func invoke(text: String, page: Int) async -> Source<MoviesSearchResponse> {
        await handle {
            return try await restManager.fetch(url: Endpoints.movies, parameters: [
                "plot": "full",
                "s": text,
                "y": "",
                "page": "\(page)",
                "apikey": BuildUtils.shared.moviesApiKey
            ])
        }
    }
}
