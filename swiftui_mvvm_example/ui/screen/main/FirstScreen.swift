import SwiftUI

struct MainScreen: BaseScreen {
    
    @Environment(\.viewController) var viewController
    
    var body: some View {
        VStack {
            
            Button {
                MoviesScreen.open(viewController?.navigationController)
            } label: {
                Text("Movies")
            }
        }
        .padding()
    }
}
