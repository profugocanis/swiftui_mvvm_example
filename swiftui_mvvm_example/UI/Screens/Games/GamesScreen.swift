import SwiftUI
 
struct GamesScreen: BaseScreen {
    
    private let viewModel: GamesViewModel
    
    init(_ vc: ScreenViewController) {
        self.viewModel = AppComponent.shared.injectViewModel(vc)
    }
    
    var body: some View {
        GamesContent(
            state: viewModel.state,
            onIntent: viewModel.onIntent
        )
    }
    
    // MARK: open
    static func open(_ nv: UINavigationController?) {
        let vc = ScreenViewController { vc in
            GamesScreen(vc)
        }
        vc.title = "Games"
        nv?.pushViewController(vc, animated: true)
    }
}

#Preview {
    GamesContent(
        state: .init(games: ["Game 1", "Game 2", "Game 3"]),
        onIntent: { _ in }
    )
}

@Observable
class GamesState: BaseState {
    
    var games: [String] = []
    var isLoading: Bool = false
    
    init(games: [String] = []) {
        self.games = games
    }
}

enum GamesScreenIntent {
    case searchGames(text: String)
}

private struct GamesContent: View {
    
    let state: GamesState
    let onIntent: (GamesScreenIntent) -> Void
    
    var body: some View {
        VStack {
            Text("Games Screen")
                .font(.subheadline)
            
            ScrollView {
                ForEach(state.games, id: \.self) { game in
                    Text(game)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Button("Search Games") {
                onIntent(.searchGames(text: "Example search text"))
            }
        }
        .overlay {
            if state.isLoading {
                ProgressView("Loading...")
            }
        }
    }
}

@MainActor
final class GamesViewModel: BaseViewModel {
    
    let state = GamesState()
    
    func onIntent(_ intent: GamesScreenIntent) {
        switch intent {
        case .searchGames(text: let text):
            searchGames(text: text)
        }
    }
    
    private func searchGames(text: String) {
        task { [weak self] in
            guard let self else { return }
            state.isLoading = true
            try? await Task.sleep(for: .seconds(2))
            state.games.append("Game 1")
            state.games.append("Game 2")
            state.isLoading = false
        }
    }
}
