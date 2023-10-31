import SwiftUI

struct MainScreen: BaseScreen {
    
    var body: some View {
        VStack {
            
            Text("swiftui_mvvm_exampleApp")
            
            Button {
                TestRestScreen.open(viewController?.navigationController)
            } label: {
                Text("TestRestScreen")
            }

        }
        .padding()
    }
}
