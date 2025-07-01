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
        state.handleDetail(.processing)
        task { [weak self] in
            guard let self = self else { return }
            let result = await self.getDetailUseCase.invoke(imdbID: imdbID)
            await MainActor.run {
                self.state.handleDetail(result)
            }
        }
    }
}
