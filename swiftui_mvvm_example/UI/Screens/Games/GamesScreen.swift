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

// MARK: Content
private struct GamesContent: View {
    
    @State var state: GamesState
    let onIntent: (GamesState.Intent) -> Void
    
    var body: some View {
        VStack {
            Text("Games Screen")
                .font(.subheadline)
            
            TextField("Search games...", text: $state.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ScrollView {
                ForEach(state.games, id: \.self) { game in
                    Text(game)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
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

// MARK: Preview
#Preview {
    GamesContent(
        state: .init(games: ["Game 1", "Game 2", "Game 3"]),
        onIntent: { _ in }
    )
}
