import Foundation

class SearchMoviesUseCase: BaseUseCase {
    
    private let restManager: RestManager
    
    init(restManager: RestManager) {
        self.restManager = restManager
    }
    
    func invoke(text: String, page: Int) async throws -> [Movie] {
        let result: MoviesSearchResponse = try await restManager.fetch(
            url: BuildUtils.shared.moviesApi,
            payload: [
                "plot": "full",
                "s": text,
                "y": "",
                "page": "\(page)",
                "apikey": BuildUtils.shared.moviesApiKey
            ]
        )
        
        if let error = result.error {
            throw CustomError(error)
        }
        
        return result.search ?? []
    }
}
