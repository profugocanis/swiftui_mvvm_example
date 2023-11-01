import SwiftUI

struct MainScreen: BaseScreen {
    
    var body: some View {
        VStack {
            
            Button {
                MoviesScreen.open(navigationController)
            } label: {
                Text("Movies")
            }
        }
        .padding()
    }
}
