import SwiftUI

struct MainScreen: BaseScreen {
    
    var body: some View {
        VStack {
            
            Button {
                TestRestScreen.open(viewController?.navigationController)
            } label: {
                Text("Albums")
            }

            Button {
                MoviesScreen.open(viewController?.navigationController)
            } label: {
                Text("Movies")
            }
        }
        .padding()
    }
}
