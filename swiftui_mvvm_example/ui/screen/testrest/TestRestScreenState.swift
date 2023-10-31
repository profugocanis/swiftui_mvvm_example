import Foundation

class TestRestScreenState: BaseState {
    
    @Published private(set) var isLoading = false
    @Published private(set) var albums: [Album] = []
    
    func handleAlbums(_ source: Source<[Album]>) {
        switch source {
        case .processing: isLoading = true
        case .success(let data):
            self.albums = data ?? []
            isLoading = false
        case .error(let error):
            showError(error)
            isLoading = false
        }
    }
}
