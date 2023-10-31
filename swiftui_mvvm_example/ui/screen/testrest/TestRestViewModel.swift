import Foundation

class TestRestViewModel: BaseViewModel {
    
    var state: TestRestScreenState!
    private let getAlbumUseCase: GetAlbumUseCase
    
    init(getAlbumUseCase: GetAlbumUseCase) {
        self.getAlbumUseCase = getAlbumUseCase
    }
    
    @MainActor
    func load() {
        state.handleAlbums(.processing)
        task { [weak self] in
            guard let self = self else { return }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            let source = await getAlbumUseCase.invoke(ids: [3, 2])
            state.handleAlbums(source)
        }
    }
}
