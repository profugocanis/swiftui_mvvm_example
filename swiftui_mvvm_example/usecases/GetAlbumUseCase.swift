import Foundation

class GetAlbumUseCase: BaseUseCase {
    
    private let restManager: RestManager
    
    init(restManager: RestManager) {
        self.restManager = restManager
    }
    
    func invoke(ids: [Int]) async -> Source<[Album]> {
        await handle {
            let results: [ITunesResult] = try await ids.parallelMap { [weak self] id in
                guard let self = self else { throw NSError() }
                return try await self.restManager.fetch(url: Endpoints.albums)
                
            }
            var albums = [Album]()
            results.forEach { result in
                result.results.forEach { album in
                    albums.append(album)
                }
            }
            return albums
        }
    }
}
