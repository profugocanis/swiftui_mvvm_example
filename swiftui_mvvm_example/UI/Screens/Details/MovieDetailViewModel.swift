import Foundation
import Combine

class MovieDetailViewModel: BaseViewModel {
    
    let state: MovieDetailState
    private let getDetailUseCase: GetMovieDetailsUseCase

    init(state: MovieDetailState, getDetailUseCase: GetMovieDetailsUseCase) {
        self.state = state
        self.getDetailUseCase = getDetailUseCase
    }

    @MainActor
    func loadDetail(imdbID: String) {
        state.isLoading = true
        launchSafely(
            launch: { [weak self] in
                guard let self = self else { return }
                let result = try await getDetailUseCase.invoke(imdbID: imdbID)
                state.setMovieDetails(result)
                state.isLoading = false
                
            },
            onError: { error in
                self.state.showErrorDialog(error)
            }
        )
    }
}
