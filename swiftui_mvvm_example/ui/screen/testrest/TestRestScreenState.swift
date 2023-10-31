import Foundation

class TestRestScreenState: BaseState {
    
    @Published private(set) var isLoading = false
    @Published private(set) var albums: [Album] = []
    
    func handleAlbums(_ source: Source<[ITunesResult]>) {
        switch source {
        case .processing: isLoading = true
        case .success(let data):
            isLoading = false
            var albums = [Album]()
            data?.forEach { result in
                result.results.forEach { album in
                    albums.append(album)
                }
            }
            self.albums = albums
        case .error(let error):
            showError(error)
            isLoading = false
        }
    }
}
