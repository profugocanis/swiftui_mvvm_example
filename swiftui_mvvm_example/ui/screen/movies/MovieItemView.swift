import SwiftUI

struct MovieItemView: View {
    
    let movie: MoviesSearchResponse.Movie
   
    var body: some View {
        VStack {
            HStack {
                Text("\(movie.title ?? "")")
                Spacer()
            }
            Divider()
        }
        .padding(.top, 8)
    }
}
