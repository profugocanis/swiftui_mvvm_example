import Foundation

@MainActor
final class GamesViewModel: BaseViewModel {
    
    let state = GamesState()
    
    func onIntent(_ intent: GamesState.Intent) {
        switch intent {
        case .searchGames(text: let text):
            searchGames(text: text)
        }
    }
}

extension GamesViewModel {
    
    private func searchGames(text: String) {
        state.isLoading = true
        launchSafely(
            launch: { [weak self] in
                guard let self else { return }
                try? await Task.sleep(for: .seconds(2))
                state.games.append("Game 1")
                state.games.append("Game 2")
                state.isLoading = false
            },
            onError: { [weak self] error in
                self?.state.showErrorDialog(error)
                self?.state.isLoading = false
            }
        )
    }
}
