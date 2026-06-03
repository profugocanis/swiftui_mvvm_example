import Foundation

@Observable
final class GamesState: BaseState {
    
    enum Intent {
        case searchGames(text: String)
    }
    
    var searchText: String = ""
    var games: [String] = []
    var isLoading: Bool = false
    
    init(games: [String] = []) {
        self.games = games
    }
}
