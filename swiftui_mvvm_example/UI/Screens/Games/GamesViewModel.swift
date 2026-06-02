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
        launchSafely(
            onError: { error in
                self.state.showErrorDialog(error)
            },
            launch: { [weak self] in
                guard let self else { return }
                state.isLoading = true
                try? await Task.sleep(for: .seconds(2))
                state.games.append("Game 1")
                state.games.append("Game 2")
                state.isLoading = false
            }
        )
    }
}
